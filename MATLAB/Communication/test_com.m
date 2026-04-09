%% Test meas2Twh
IDs = [16, 16];
rvecs = [2.18187; -2.17011; -0.194662];
rvecs = [rvecs, rvecs];
tvecs = [-0.0181131; 0.0102561; 0.483989];
tvecs = [tvecs, tvecs];
camera = 'TopCam';


T_top_test = meas2Twh(IDs, rvecs, tvecs, camera, T_topwc, T_sidewc, aruco_markers)
T_top_avg = average_translations(T_top_test)

%% Test single
ID = 6;
rvec = [0.0474269, -2.93557, 0.0781473]';
tvec = [-0.163092, 0.0150351, 0.364397]';
%rvec = [0.208935, -2.66803, -0.0532317]';
%tvec = [-0.172482, -0.0110108, 0.383612]';
camera = 'TopCam';
T_top_test = meas2Twh(ID, rvec, tvec, camera, T_topwc, T_sidewc, aruco_markers)


%% Test parsing:
camera = 'TopCam';
%data = "I:31q:3.072r:0.017s:0.045x:0.099y:0.074z:0.282;\nI:34q:3.113r:0.027s:0.093x:-0.121y:0.073z:0.277;\nI:16q:2.072r:-2.138s:-0.086x:-0.022y:0.036z:0.490;\nI:20q:-1.188r:1.188s:-1.287x:-0.220y:0.075z:0.495;";
[test_IDs, test_rvecs, test_tvecs] = parse_sensor_data(data)
[test_Twhs, no_valid_ids] = meas2Twh(test_IDs, test_rvecs, test_tvecs, camera, T_topwc, t_sidewc, aruco_markers)