#include <thread>
#include <ThreadSafeValue.hpp>
#include <UdpClient.hpp>
#include <qcoreapplication.h>
#include <QCoreApplication>
#include <opencv2/highgui.hpp>
#include <opencv2/objdetect/aruco_detector.hpp>
#include <iostream>
#include "aruco_samples_utility.hpp"


void sendCoordinates(ThreadSafeValue<QByteArray>& coordinateData, ThreadSafeValue<bool>& stopFlag) {
    QHostAddress targetAddress{"127.0.0.1"}; 
    quint16 targetPort{8080};
    UdpClient udpClient(targetAddress, targetPort);

    QByteArray data;

    while(true) {
        if (coordinateData.hasNewValue()) {
            data = coordinateData.take();
            udpClient.send(data);
        }
        if (stopFlag.take()) {
            std::cout << "UDP thread stopped" << std::endl;
            break;
        }
    }
}


void detectPosition(ThreadSafeValue<QByteArray>& coordinateData, ThreadSafeValue<bool>& stopFlag) {
        cv::aruco::DetectorParameters detectorParams;
    //detectorParams.readDetectorParameters(dp_fs.root());
    //dp_fs.release();


    cv::aruco::Dictionary dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);

    QByteArray data;

    int camId = 0;
    cv::Mat camMatrix, distCoeffs;
    cv::FileStorage camParams("camera2.txt", cv::FileStorage::READ);
    if (!camParams.isOpened()) {
        std::cerr << "Error: Could not open file " << "camera2.txt" << std::endl;
        stopFlag.set(true);
        return;
    }
    camParams["camera_matrix"] >> camMatrix;
    camParams["distortion_coefficients"] >> distCoeffs;

    camParams.release();


    cv::aruco::ArucoDetector detector(dictionary, detectorParams);
    cv::VideoCapture inputVideo;
    inputVideo.open(camId);
    int waitTime = 10;

    float markerLength = 0.05f;

    //! [aruco_pose_estimation2]
    // set coordinate system
    cv::Mat objPoints(4, 1, CV_32FC3);
    objPoints.ptr<cv::Vec3f>(0)[0] = cv::Vec3f(-markerLength/2.f, markerLength/2.f, 0);
    objPoints.ptr<cv::Vec3f>(0)[1] = cv::Vec3f(markerLength/2.f, markerLength/2.f, 0);
    objPoints.ptr<cv::Vec3f>(0)[2] = cv::Vec3f(markerLength/2.f, -markerLength/2.f, 0);
    objPoints.ptr<cv::Vec3f>(0)[3] = cv::Vec3f(-markerLength/2.f, -markerLength/2.f, 0);


    while(inputVideo.grab()) {
        cv::Mat image, imageCopy;
        inputVideo.retrieve(image);

        //! [aruco_pose_estimation3]
        std::vector<int> ids;
        std::vector<std::vector<cv::Point2f> > corners, rejected;

        detector.detectMarkers(image, corners, ids);

        size_t nMarkers = corners.size();
        std::vector<cv::Vec3d> rvecs(nMarkers), tvecs(nMarkers);

        if (!ids.empty()) {
            // Calculate pose for each marker
            for (size_t i = 0; i < nMarkers; i++) {
                solvePnP(objPoints, corners.at(i), camMatrix, distCoeffs, rvecs.at(i), tvecs.at(i));
            }
        }

        //imshow("out", imageCopy);
        //char key = (char)cv::waitKey(waitTime);

        if (!rvecs.empty()) {
            //std::cout << ids[0] << std::endl;
            QString msg = QString("A:%1B:%2C:%3")
                  .arg(rvecs[0][0], 0, 'f', 3)
                  .arg(rvecs[0][1], 0, 'f', 3)
                  .arg(rvecs[0][2], 0, 'f', 3);
            
            data = msg.toUtf8();
            coordinateData.set(data);
            
        }

        if (stopFlag.take()) {
            std::cout << "Pose detection thread stopped" << std::endl;
            break;
        }

    }
}

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    
    // Threadsafe values
    ThreadSafeValue<bool> stopFlag(false);    
    ThreadSafeValue<QByteArray> coordinateData;

    // Initialize threads
    std::thread poseDetectionThread(detectPosition, std::ref(coordinateData), std::ref(stopFlag));
    std::thread udpClientThread(sendCoordinates, std::ref(coordinateData), std::ref(stopFlag));

    cv::Mat gui(750, 750, CV_8UC3);
    int key = 0;

    cv::imshow("Quit Window", gui);

    while (key != 27) {
        key = cv::waitKey(10);
    }

    stopFlag.set(true);

    if (poseDetectionThread.joinable()) { poseDetectionThread.join(); } 
    if (udpClientThread.joinable()) { udpClientThread.join(); }

    std::cout << "Threads stopped" << std::endl;

    return 0;
}
    
/*
    int main(){
        return 0;
    }
        */