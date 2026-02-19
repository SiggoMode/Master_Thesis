nx_EKF = 6;
nu_EKF = 7;
x0_EKF = zeros(nx_EKF,1);

% Parameters
Q_kf = eye(6)*100;
R_kf = eye(3);
P0 = eye(6);

% Function model
