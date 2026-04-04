% Inverted T to get Tcm (from camera to marker)

top_cam.id31.rvec = [3.11495, 0.0057026, -0.00993241]';
top_cam.id31.tvec = [0.0993779, 0.0741715, 0.284096]';
top_cam.id31.R = rodrigues(top_cam.id31.rvec);
top_cam.id31.Tcm = T_gen(top_cam.id31.R, top_cam.id31.tvec);

top_cam.id34.rvec = [3.13971, 0.0414933, 0.0890102]';
top_cam.id34.tvec = [-0.120776, 0.0722064, 0.277229]';
top_cam.id34.R = rodrigues(top_cam.id34.rvec);
top_cam.id34.Tcm = T_gen(top_cam.id34.R, top_cam.id34.tvec);

side_cam.id24.rvec = [-3.08971, -0.0574261, 0.0509216]';
side_cam.id24.tvec = [-0.0877013, -0.0126847, 0.590784]';
side_cam.id24.R = rodrigues(side_cam.id24.rvec);
side_cam.id24.Tcm = T_gen(side_cam.id24.R, side_cam.id24.tvec);

side_cam.id20.rvec = [-3.22283, -0.0444061, -0.0870376]';
side_cam.id20.tvec = [-0.0944825, 0.140494, 0.605655]';
side_cam.id20.R = rodrigues(side_cam.id20.rvec);
side_cam.id20.Tcm = T_gen(side_cam.id20.R, side_cam.id20.tvec);



