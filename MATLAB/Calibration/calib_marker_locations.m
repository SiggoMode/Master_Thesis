% t given in world coordinates to center of marker and R relates the frames
% Multiplication at the end is to convert from mm to m.

id31.t = [-0.86; 108.828; 43.804]*0.001;
id31.R = rotz(pi/2);
id31.Twm = T_gen(id31.R, id31.t);

id34.t = [-0.86; -107.972; 43.804]*0.001;
id34.R = rotz(pi/2);
id34.Twm = T_gen(id34.R, id34.t);

id24.t = [-0.86; -189.272; -14.616]*0.001;
id24.R = rotz(pi)*rotx(pi/2);
id24.Twm = T_gen(id24.R, id24.t);

id20.t = [-0.86; -189.272; -160.616]*0.001;
id20.R = rotz(pi)*rotx(pi/2);
id20.Twm = T_gen(id20.R, id20.t);


calibration_markers.id31 = id31;
calibration_markers.id34 = id34;
calibration_markers.id24 = id24;
calibration_markers.id20 = id20;