%% Test continous system model
x_test = [0;0;0;0;0;0];
u_test = [0;0;0;0;0;0;0];

x_dot = system_model_continous(x_test, u_test, system_params)