% Init
%init;
EKF_tuning;
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
x_prev_test = ones(7,1);
P_prev_test = eye(7);
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

%% Test new linearization
EKF_tuning;
q = euler2quat([1;1;1]);
x_prev_test = [q;0;0;0];
%u_k_test = [0;0;0;0;0;0;0];
u_k_test = u0_calc(quat2euler(x_prev_test(1:4)),system_params);
u_k_test_dot = zeros(size(u_k_test));
Ts_test = 0.01;
[Ad, Bd, c] = linearize_system(x_prev_test, u_k_test, u_k_test_dot, system_params);
system_model_quat_omega(x_prev_test, u_k_test, u_k_test_dot, system_params)

%% Test new prediction step
[x_pred, z_pred, P_pred, Ad_hat, Bd_hat, c] = EKF_pred_quaternions(x_prev_test,P0, u_k_test, u_k_test_dot, EKF_settings ,system_params);

x_pred

[x_pred, z_pred, P_pred, Ad_hat, Bd_hat, c] = EKF_pred_quaternions(x_pred,P_pred, u_k_test, u_k_test_dot, EKF_settings ,system_params);
x_pred
%% Test new update step
z_k = [0;0;0];
[x_post,P_post] = EKF_upd_quaternions(x_pred, P_pred, z_pred, z_k, EKF_settings);
x_post

%% Test sequence of prediction and update
q = euler2quat([0;0;0]);
x_t = [q;0;0;0];
u_t = u0_calc(quat2euler(x_t(1:4)),system_params);
u_tdot = zeros(size(u_t));
Pt = P0;
zt = [0;0;0];

[x_t, z_pred, Pt, Ad_hat, Bd_hat, c] = EKF_pred_quaternions(x_t,Pt, u_t, u_tdot, EKF_settings ,system_params);

[x_t,Pt] = EKF_upd_quaternions(x_t, Pt, z_pred, zt, EKF_settings);

[x_t, z_pred, Pt, Ad_hat, Bd_hat, c] = EKF_pred_quaternions(x_t,Pt, u_t, u_tdot, EKF_settings ,system_params);

[x_t,Pt] = EKF_upd_quaternions(x_t, Pt, z_pred, zt, EKF_settings);

[x_t, z_pred, Pt, Ad_hat, Bd_hat, c] = EKF_pred_quaternions(x_t,Pt, u_t, u_tdot, EKF_settings ,system_params);

[x_t,Pt] = EKF_upd_quaternions(x_t, Pt, z_pred, zt, EKF_settings);
