% Inverted T to get Tmc

top_cam.id31.rvec = [3.11495, 0.0057026, -0.00993241]';
top_cam.id31.tvec = [0.0993779, 0.0741715, 0.284096]';
top_cam.id31.R = rodrigues(top_cam.id31.rvec);
top_cam.id31.Tcm = T_gen(top_cam.id31.R, top_cam.id31.tvec);

top_cam.id34.rvec = [3.13971, 0.0414933, 0.0890102]';
top_cam.id34.tvec = [-0.120776, 0.0722064, 0.277229]';
top_cam.id34.R = rodrigues(top_cam.id34.rvec);
top_cam.id34.Tcm = T_gen(top_cam.id34.R, top_cam.id34.tvec);

side_cam.id24.rvec = [-2.98071, -0.12854, -0.424238]';
side_cam.id24.tvec = [-0.0819325, -0.013755, 0.594197]';
side_cam.id24.R = rodrigues(side_cam.id24.rvec);
side_cam.id24.Tcm = T_gen(side_cam.id24.R, side_cam.id24.tvec);

side_cam.id20.rvec = [3.11386, 0.111102, 0.00489623]';
side_cam.id20.tvec = [-0.0906739, 0.13365, 0.579788]';
side_cam.id20.R = rodrigues(side_cam.id20.rvec);
side_cam.id20.Tcm = T_gen(side_cam.id20.R, side_cam.id20.tvec);



