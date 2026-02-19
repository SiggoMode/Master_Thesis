% Init
init;
x_prev_test = [0;0;0;0;0;0];
u_k_test = [0;0;0;0;0;0;0];
Ts_test = 0.01;

%% Test runge_kutta4
output1 = runge_kutta4(x_prev_test, u_k_test, Ts_test, system_params)

%% Test linearization
[output2, output3] = dlfeval(@linearize, x_prev_test, u_k_test, Ts_test, system_params)


%% Test prediction step



%% Test update step