import cv2 as cv

dictionary = cv.aruco.getPredefinedDictionary(cv.aruco.DICT_6X6_250)

marker_image = cv.aruco.generateImageMarker(dictionary, 23, 200)

cv.imwrite("markers/marker23.png", marker_image)
cv.imshow("Marker 23", marker_image)
cv.waitKey(0)