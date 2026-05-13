nx_EKF = 7;
nx_EKF_euler = 6;
nd_EKF = 0;
nu_EKF = 7;
nx_hat = nx_EKF + nd_EKF;
nx_hat_euler = nx_EKF_euler + nd_EKF;
x0_EKF = [q0_quat; zeros(3,1)];
x0_EKF_euler = [q0;zeros(3,1)];


% Parameters
sigma_angles = 100;
sigma_anglerates = 10000;
%sigma_disturbance = 1e3;  % Change to 0 to remove disturbance
%sigma_disturbance = 1;
sigma_disturbance = 0;
Qx_kf = blkdiag(eye(4)*sigma_angles, eye(3)*sigma_anglerates);
Qx_kf_euler = blkdiag(eye(3)*sigma_angles, eye(3)*sigma_anglerates);
Qd_kf = eye(nd_EKF)*sigma_disturbance;
Q_kf = blkdiag(Qx_kf, Qd_kf);
Q_kf_euler = blkdiag(Qx_kf_euler, Qd_kf);
R_kf = eye(3);
P0 = blkdiag(ones(nx_hat));
P0_euler = blkdiag(ones(nx_hat_euler));
H = [eye(size(R_kf,1)), zeros(size(R_kf,1),nx_hat-size(R_kf,1))];
H_euler = [eye(size(R_kf,1)), zeros(size(R_kf,1),nx_hat_euler-size(R_kf,1))];


% Create struct
EKF_settings.nx = nx_EKF;
EKF_settings.nx_euler = nx_EKF_euler;
EKF_settings.nd = nd_EKF;
EKF_settings.nu = nu_EKF;
EKF_settings.Q = Q_kf;
EKF_settings.Q_euler = Q_kf_euler;
EKF_settings.R = R_kf;
EKF_settings.H = H;
EKF_settings.H_euler = H_euler;
EKF_settings.P0 = P0;
EKF_settings.P0_euler = P0_euler;
EKF_settings.x0 = x0_EKF;
EKF_settings.x0_euler = x0_EKF_euler;


% Create bus object for simulink
evalin('base', ['clear ' 'EKFBus']);
EKF_bus_info = Simulink.Bus.createObject(EKF_settings);
oldName = EKF_bus_info.busName;
busObj = evalin('base', oldName);
assignin('base', 'EKFBus', busObj);

% Remove the auto name
evalin('base', ['clear ' oldName]);