% Init
init;
x_prev_test = [0;0;0;0;0;0];
u_k_test = [0;0;0;0;0;0;0];
Ts_test = 0.01;

%% Test runge_kutta4
output1 = runge_kutta4(x_prev_test, u_k_test, Ts_test, system_params)

%% Test linearization
x0 = output1;
u0 = u_k_test; 
[Ad,Bd,c] = linearize(x0,u0,system_params)


%% Test prediction step
x_prev_test = ones(9,1);
P_prev_test = eye(9);
[x_pred, z_pred, P_pred, Ad_hat, Bd_hat, c] = EKF_pred(x_prev_test,P_prev_test, u_k_test, EKF_settings ,system_params);
x_pred
[x_pred, z_pred, P_pred, Ad_hat, Bd_hat, c] = EKF_pred(x_pred,P_pred, u_k_test, EKF_settings ,system_params);
x_pred

%% Test update step
x_prev_test = ones(9,1);
P_prev_test = eye(9);
[x_pred, z_pred, P_pred, Ad_hat, Bd_hat, c] = EKF_pred(x_prev_test,P_prev_test, u_k_test, EKF_settings ,system_params);
x_pred
[x_pred, z_pred, P_pred, Ad_hat, Bd_hat, c] = EKF_pred(x_pred,P_pred, u_k_test, EKF_settings ,system_params);
x_pred