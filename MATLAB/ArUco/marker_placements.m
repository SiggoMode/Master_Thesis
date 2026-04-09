% Generates the translation matrices Tmh humerus -> marker coordinates
% Also divided by 1000 to convert mm to m

%id6 = right marker (looking from the front towards humerus)
id6.tvec = [-173.86; 54.07; -19.8]/1000;
%id6.R = rotz(-pi/2)*rotx(-pi/2);
id6.R = [0,1,0; 0, 0, -1; -1, 0, 0]';
id6.T = T_gen(id6.R, id6.tvec);

%id8 = bottom marker (looking from the front towards humerus)
id8.tvec = [0; 54.07; -193.6]/1000;
%id8.R = rotz(-pi/2)*rotx(pi);
id8.R = [0,1,0; 1,0,0; 0,0,-1]';
id8.T = T_gen(id8.R, id8.tvec);

%id16 = top marker (looking from the front towards humerus)
id16.tvec = [-54.07; 0; 154.06]/1000;
id16.R = rotz(pi);
id16.T = T_gen(id16.R, id16.tvec);

%id18 = left marker (looking from the front towards humerus)
id18.tvec = [54.07; -173.86; -19.8]/1000;
id18.R = rotx(pi/2);
id18.T = T_gen(id18.R, id18.tvec);

%id26 = front marker (looking from the front towards humerus)
id26.tvec = [0; 173.862; -73.874]/1000;
%id26.R = rotz(pi/2)*rotx(-pi/2);
id26.R = [0,-1,0;0,0,1;-1,0,0];
id26.T = T_gen(id26.R, id26.tvec);

aruco_markers.id6.Tmh = id6.T;
aruco_markers.id8.Tmh = id8.T;
aruco_markers.id16.Tmh = id16.T;
aruco_markers.id18.Tmh = id18.T;
aruco_markers.id26.Tmh = id26.T;

% Create bus element
% Create bus object for Simulink
evalin('base', ['clear ' 'aruco_marker_bus']);
Sys_params_bus_info = Simulink.Bus.createObject(aruco_markers);
oldName = Sys_params_bus_info.busName;
busObj = evalin('base', oldName);
assignin('base', 'aruco_marker_bus', busObj);
% Remove the auto name
evalin('base', ['clear ' oldName]);