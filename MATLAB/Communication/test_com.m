%% Test meas2Twh
IDs = [16, 16];
rvecs = [2.18187; -2.17011; -0.194662];
rvecs = [rvecs, rvecs];
tvecs = [-0.0181131; 0.0102561; 0.483989];
tvecs = [tvecs, tvecs];
camera = 'TopCam';


T_top_test = meas2Twh(IDs, rvecs, tvecs, camera, T_topwc, T_sidewc, aruco_markers)
T_top_avg = average_translations(T_top_test)