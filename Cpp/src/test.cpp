#include <UdpClient.hpp>
#include <qcoreapplication.h>
#include <QCoreApplication>
#include <opencv2/highgui.hpp>
#include <opencv2/objdetect/aruco_detector.hpp>
#include <iostream>
#include "aruco_samples_utility.hpp"


int main(int argc, char *argv[])
{
    /*   // Camera testing
    cv::FileStorage dp_fs("../params/test.json", cv::FileStorage::WRITE);
    cv::aruco::DetectorParameters detectorParams;
    detectorParams.writeDetectorParameters(dp_fs);
    dp_fs.release();
    

    cv::aruco::DetectorParameters detectorParams;
    //detectorParams.readDetectorParameters(dp_fs.root());
    //dp_fs.release();


    cv::aruco::Dictionary dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);


    int camId = 0;
    cv::Mat camMatrix, distCoeffs;
    cv::FileStorage camParams("camera2.txt", cv::FileStorage::READ);
    if (!camParams.isOpened()) {
        std::cerr << "Error: Could not open file " << "camera2.txt" << std::endl;
        return 0;
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

    std::cout << "Working directory: "
          << std::filesystem::current_path() << std::endl;

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
            std::cout << rvecs[0] << std::endl;
        }

    }
        */

    // UDP testing

    QCoreApplication app(argc, argv);
    QHostAddress targetAddress{"127.0.0.1"}; 
    quint16 targetPort{8080};
    UdpClient udpClient(targetAddress, targetPort);

    QByteArray message = "A:109.1B:905.3";

    udpClient.send(message);

    return 0;
}