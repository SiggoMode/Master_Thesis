#include <thread>
#include <ThreadSafeValue.hpp>
#include <UdpClient.hpp>
#include <qcoreapplication.h>
#include <QCoreApplication>
#include <opencv2/objdetect/aruco_detector.hpp>
#include <iostream>
#include "aruco_samples_utility.hpp"
#include <csignal>


ThreadSafeValue<bool>* globalStopFlag = nullptr;


void signalHandler(int signum) {
    if (globalStopFlag) {
        globalStopFlag->set(true);
    }
    std::cout << "\nInterrupt signal (" << signum << ") received.\n";
}

void sendCoordinates(QHostAddress targetAddress, quint16 targetPort, ThreadSafeValue<QByteArray>& coordinateData, ThreadSafeValue<bool>& stopFlag) {
    UdpClient udpClient(targetAddress, targetPort);

    QByteArray data;

    while(true) {
        if (coordinateData.hasNewValue()) {
            data = coordinateData.take();
            udpClient.send(data);
        }
        if (stopFlag.take()) {
            std::cout << "UDP client on port: " << targetPort << " Shutting down" << std::endl;
            break;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(5));
        
    }
}


void detectPosition(const int camId, const std::string camParamsPath, cv::aruco::DetectorParameters detectorParams, 
    ThreadSafeValue<QByteArray>& coordinateData, ThreadSafeValue<bool>& stopFlag) {
    //detectorParams.readDetectorParameters(dp_fs.root());
    //dp_fs.release();


    cv::aruco::Dictionary dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);

    QByteArray data;

    cv::Mat camMatrix, distCoeffs;
    cv::FileStorage camParams(camParamsPath, cv::FileStorage::READ);
    if (!camParams.isOpened()) {
        std::cerr << "Error: Could not open file " << camParamsPath << std::endl;
        stopFlag.set(true);
        return;
    }
    camParams["camera_matrix"] >> camMatrix;
    camParams["distortion_coefficients"] >> distCoeffs;

    camParams.release();


    cv::aruco::ArucoDetector detector(dictionary, detectorParams);
    cv::VideoCapture inputVideo;
    inputVideo.open(camId);

    if (!inputVideo.isOpened()) {
        std::cerr << "Failed to open camera\n";
        stopFlag.set(true);
        return;
    }

    int waitTime = 1;

    float markerLength = 0.033f;

    //! [aruco_pose_estimation2]
    // set coordinate system
    cv::Mat objPoints(4, 1, CV_32FC3);
    objPoints.ptr<cv::Vec3f>(0)[0] = cv::Vec3f(-markerLength/2.f, markerLength/2.f, 0);
    objPoints.ptr<cv::Vec3f>(0)[1] = cv::Vec3f(markerLength/2.f, markerLength/2.f, 0);
    objPoints.ptr<cv::Vec3f>(0)[2] = cv::Vec3f(markerLength/2.f, -markerLength/2.f, 0);
    objPoints.ptr<cv::Vec3f>(0)[3] = cv::Vec3f(-markerLength/2.f, -markerLength/2.f, 0);

    while(inputVideo.grab()) {
        cv::Mat image;
        inputVideo.retrieve(image);

        //! [aruco_pose_estimation3]
        std::vector<int> ids;
        std::vector<std::vector<cv::Point2f> > corners;

        detector.detectMarkers(image, corners, ids);

        size_t nMarkers = corners.size();
        std::vector<cv::Vec3d> rvecs(nMarkers), tvecs(nMarkers);

        if (!ids.empty()) {
            // Calculate pose for each marker
            for (size_t i = 0; i < nMarkers; i++) {
                cv::solvePnP(objPoints, corners.at(i), camMatrix, distCoeffs, rvecs.at(i), tvecs.at(i));
            }

            QStringList messages;

            for (size_t i = 0; i < ids.size(); i++) {
                QString msg = QString("I:%1q:%2r:%3s:%4x:%5y:%6z:%7;")
                    .arg(ids[i])
                    .arg(rvecs[i][0], 0, 'f', 3)
                    .arg(rvecs[i][1], 0, 'f', 3)
                    .arg(rvecs[i][2], 0, 'f', 3)
                    .arg(tvecs[i][0], 0, 'f', 3)
                    .arg(tvecs[i][1], 0, 'f', 3)
                    .arg(tvecs[i][2], 0, 'f', 3);
                messages.append(msg);
            }
            
            QString combined = messages.join("\n");

            data = combined.toUtf8();
            coordinateData.set(data);
        }

        if (stopFlag.take()) {
            std::cout << "Marker detection from cam: " << camId << " Shutting down" << std::endl;
            break;
        }

    }
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    
    // Threadsafe values
    ThreadSafeValue<bool> stopFlag(false);    
    ThreadSafeValue<QByteArray> coordinateDataTop;
    ThreadSafeValue<QByteArray> coordinateDataSide;

    // Camera parameters:
    const int topCamId = 0;
    const int sideCamId = 2;
    std::string topCamParamsPath = "../CameraParams/TopCam.yml";
    std::string sideCamParamsPath = "../CameraParams/SideCam.yml";
    cv::FileStorage dp_fs("../CameraParams/generic_dp.yml", cv::FileStorage::READ);
    cv::aruco::DetectorParameters detectorParams;
    detectorParams.readDetectorParameters(dp_fs.root());

    // UDP client parameters:
    QHostAddress targetAddress{"192.168.0.209"};
    quint16 targetPortTopCam{8080};
    quint16 targetPortSideCam{8081};

    // Initialize threads
    std::thread topPoseDetectionThread(detectPosition, topCamId, topCamParamsPath, detectorParams , std::ref(coordinateDataTop), std::ref(stopFlag));
    std::thread sidePoseDetectionThread(detectPosition, sideCamId, sideCamParamsPath, detectorParams , std::ref(coordinateDataSide), std::ref(stopFlag));
    
    std::thread topUdpClientThread(sendCoordinates, targetAddress, targetPortTopCam, std::ref(coordinateDataTop), std::ref(stopFlag));
    std::thread sideUdpClientThread(sendCoordinates, targetAddress, targetPortSideCam, std::ref(coordinateDataSide), std::ref(stopFlag));


    // Handle CTRL + C
    globalStopFlag = &stopFlag;
    std::signal(SIGINT, signalHandler);

    while (!stopFlag.take()) {
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    if (topPoseDetectionThread.joinable()) { topPoseDetectionThread.join(); } 
    if (sidePoseDetectionThread.joinable()) { sidePoseDetectionThread.join(); } 
    if (topUdpClientThread.joinable()) { topUdpClientThread.join(); }
    if (sideUdpClientThread.joinable()) { sideUdpClientThread.join(); }

    std::cout << "Threads stopped" << std::endl;

    return 0;
}
    