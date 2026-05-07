function [x_pred, z_pred, P_pred, Ad, Bd, c] = EKF_pred_quaternions(x_prev,P_prev, u_k, u_kp1, EKF_settings ,system_params)
nx = EKF_settings.nx;
nd = EKF_settings.nd;
nu = EKF_settings.nu;
x = x_prev(1:nx);
%d = x_prev(nx+1:nx+nd);
Q_kf = EKF_settings.Q;
Ts = system_params.dt;


% Predict and linearize
x_pred = runge_kutta4(x, u_k, u_kp1, Ts, system_params); 
x_pred(1:4) = x_pred(1:4)/norm(x_pred(1:4)); % Normalize quats
[Ad, Bd, c] = linearize_system(x, u_k, u_kp1, system_params);

% Add disturbance terms
%x_pred = [x_pred;d];
%Ae = [zeros(nd); eye(nd)];
%Ad_hat = [Ad_x, Ae; zeros(nd,nx), eye(nd)];
%Bd_hat = [Bd_x; zeros(nd,nu)];
%c = [c; zeros(nd,1)];

% Do posteriori calculations
P_pred = Ad*P_prev*Ad' + Q_kf;
z_pred = quat2euler(x_pred(1:4)); % We expect to measure the predicted angles
end