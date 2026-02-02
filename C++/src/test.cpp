#include <opencv2/objdetect/aruco_detector.hpp>
#include <iostream>

int main() {
    cv::aruco::ArucoDetector detector;
    std::cout << "ArucoDetector created successfully." << std::endl;
    return 0;
}