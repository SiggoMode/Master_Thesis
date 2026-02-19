function [x_pred, z_pred, P_pred, A_d, B_d, c] = EKF_pred(x_prev,P_prev, u_k ,system_params, Ts, Q_kf)
%f = @(x,u) system_model_continous(x,u,system_params);
%x_pred = runge_kutta4(x_prev, u_k, Ts, f);
% Må endre runge_kutta4 visst det her ikkje e lov i simulink
x_pred = runge_kutta4(x_prev, u_k, Ts, system_params);
[A_d, B_d, c] = linearize(x_prev, u_k, Ts, system_params);
P_pred = A_d*P_prev*A_d' + Q_kf;
z_pred = x_pred(1:3); % We expect to measure the predicted angles
end