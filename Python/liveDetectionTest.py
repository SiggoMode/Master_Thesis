import cv2 as cv
import numpy as np

# ---------- Camera Setup ----------
camera_id = 0  # change to 1, 2, etc. if needed
cap = cv.VideoCapture(camera_id)

if not cap.isOpened():
    raise RuntimeError("Could not open USB camera")

# ---------- ArUco Setup ----------
dictionary = cv.aruco.getPredefinedDictionary(cv.aruco.DICT_6X6_250)
parameters = cv.aruco.DetectorParameters()

detector = cv.aruco.ArucoDetector(dictionary, parameters)

print("Press 'q' to quit")

# ---------- Main Loop ----------
while True:
    ret, frame = cap.read()
    if not ret:
        break

    gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)

    corners, ids, rejected = detector.detectMarkers(gray)

    if ids is not None:
        cv.aruco.drawDetectedMarkers(frame, corners, ids)

        # Optional: print IDs to console
        for marker_id in ids.flatten():
            print(f"Detected marker ID: {marker_id}")

    cv.imshow("ArUco Marker Detection", frame)

    if cv.waitKey(1) & 0xFF == ord('q'):
        break

# ---------- Cleanup ----------
cap.release()
cv.destroyAllWindows()
