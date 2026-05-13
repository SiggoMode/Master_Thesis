function [x_pred, z_pred, P_pred, Ad_hat, Bd_hat, c] = EKF_pred_euler(x_prev,P_prev, u_k, u_kp1, EKF_settings ,system_params)
nx = EKF_settings.nx_euler;
nd = EKF_settings.nd;
nu = EKF_settings.nu;
x = x_prev(1:nx);
d = x_prev(nx+1:nx+nd);
Q_kf = EKF_settings.Q_euler;
Ts = system_params.dt;


% Predict and linearize
x_pred = runge_kutta4_euler(x, u_k, u_kp1, Ts, system_params); 
[Ad_x, Bd_x, c] = linearize_system_euler(x, u_k, u_kp1, system_params);

% Add disturbance terms
x_pred = [x_pred;d];
Ae = [zeros(nd); eye(nd)];
Ad_hat = [Ad_x, Ae; zeros(nd,nx), eye(nd)];
Bd_hat = [Bd_x; zeros(nd,nu)];
c = [c; zeros(nd,1)];

% Do posteriori calculations
P_pred = Ad_hat*P_prev*Ad_hat' + Q_kf;
z_pred = x_pred(1:3); % We expect to measure the predicted angles
end