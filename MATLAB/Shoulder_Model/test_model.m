%% Test continous system model
x_test = [0;0;0;0;0;0];
u_test = [0;0;0;0;0;0;0];

x_dot = system_model_continous(x_test, u_test, system_params)

%% Test Tension calc
cable_length = 3;
cable_sp = 3;
cable_rate = 0;
cable_sp_rate = 0;

T = Tension(cable_length, cable_sp, cable_rate, cable_sp_rate, system_params)

%% Test tension model
x_test = [1;1;0;0;0;0];
q0 = x_test(1:3);
u_test = u0_calc(q0,system_params);
%x_test(1) = x_test(1) +0.1;
%u_test(2) = u_test(2)+0.01;
udot = [0;0;0;0;0;0;0];
q = x_test(1:3);
qdot = x_test(4:6);

Q = Q_tension_calc(u_test, udot, q, qdot, system_params)

drdq_test = @(A,B,C) [0; cos(C)*sin(B)*cos(A) + sin(C)*sin(A) + sin(C)*sin(B)*cos(A) - cos(C)*sin(A) + cos(B)*cos(A);
    -cos(C)*sin(B)*sin(A) + sin(C)*cos(A) - sin(C)*sin(B)*sin(A) - cos(C)*cos(A) - cos(B)*sin(A)];
drdq_test(0,1,0);

drdq_A = Rot_mat(q0) * system_params.cables.FD.L;

%% Test quaternion model

q0_test = euler_to_quaternion([0,0,0]);
qdot0_test = zeros(4,1);

system_model_quarternions(q0_test, qdot0_test, system_params)

%% Test Tau_tension_calc
theta_test = [0;0.9;0];
q_test = euler_to_quaternion(theta_test);
theta_displacement = [0;1;0];
u0_test = u0_calc(theta_displacement, system_params);
udot_test = zeros(7,1);
omega = zeros(3,1);

Tau_tension_calc(u0_test, udot_test, q_test, omega, system_params)