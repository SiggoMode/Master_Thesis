#include <opencv2/objdetect/aruco_detector.hpp>
#include <iostream>

int main(int argc, char** argv)
{
    std::string outputFile = "../CameraParams/generic_dp.yml";

    if(argc > 1) {
        outputFile = argv[1];
    }

    // Create parameter object
    cv::aruco::DetectorParameters params;

    //params.adaptiveThreshWinSizeMin = 5;
    //params.adaptiveThreshWinSizeMax = 9;
    //params.adaptiveThreshWinSizeStep = 4;
    //params.adaptiveThreshConstant = 7;
    //params.adaptiveThreshWinSizeMin = 5;
    //params.adaptiveThreshWinSizeMax = 9;
    //params.adaptiveThreshWinSizeStep = 4;
    params.adaptiveThreshConstant = 3;
    params.adaptiveThreshWinSizeMin = 5;
    params.adaptiveThreshWinSizeMax = 21;
    params.adaptiveThreshWinSizeStep = 4;

    params.minMarkerPerimeterRate = 0.05;
    params.maxMarkerPerimeterRate = 4.0;
    params.polygonalApproxAccuracyRate = 0.03;

    params.cornerRefinementMethod = cv::aruco::CORNER_REFINE_NONE;

    params.minCornerDistanceRate = 0.05;
    params.minDistanceToBorder = 3;

    params.errorCorrectionRate = 0.4;

    params.perspectiveRemovePixelPerCell = 2;
    params.perspectiveRemoveIgnoredMarginPerCell = 0.13;

    params.markerBorderBits = 1;

    params.detectInvertedMarker = false;

    // Save to file
    cv::FileStorage fs(outputFile, cv::FileStorage::WRITE);
    //if(cv::aruco::DetectorParameters::writeDetectorParameters(fs, params)) {
    if (!fs.isOpened()) {
        std::cerr << "Failed to open file: " << outputFile << std::endl;
        return -1;
    }

    params.writeDetectorParameters(fs);

    fs.release();

    std::cout << "Detector parameters saved to: " << outputFile << std::endl;

    return 0;
}