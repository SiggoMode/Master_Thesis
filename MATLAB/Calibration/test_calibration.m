top_cam_measurement_id16.rvec = [2.18187; -2.17011; -0.194662];
top_cam_measurement_id16.tvec = [-0.0181131; 0.0102561; 0.483989];
top_cam_measurement_id16.R = rodrigues(top_cam_measurement_id16.rvec);
top_cam_measurement_id16.Tcm = T_gen(top_cam_measurement_id16.R, top_cam_measurement_id16.tvec);

side_cam_measurement_id18.rvec = [-0.0100067; 3.09798; -0.0591692];
side_cam_measurement_id18.tvec = [-0.0291391; 0.127363; 0.330346];
side_cam_measurement_id18.R = rodrigues(side_cam_measurement_id18.rvec);
side_cam_measurement_id18.Tcm = T_gen(side_cam_measurement_id18.R, side_cam_measurement_id18.tvec);


T_wh_topcam = T_topwc * top_cam_measurement_id16.Tcm * aruco_markers.id16.Tmh;
T_wh_sidecam = T_sidewc * side_cam_measurement_id18.Tcm * aruco_markers.id18.Tmh;
