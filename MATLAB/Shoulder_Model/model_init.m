% Parameters
system_params.m = 5;   % Arm mass in kg
system_params.L_h = 1; % Arm length in meters
system_params.R = 0.1; % Cylinder radius in meters (Arm model)
system_params.Rhum = 24.285/1000;
system_params.g = 9.81; % m/s^2
system_params.dt = 0.01;
d1 = 1; d2 = 1; d3 = 1;
system_params.D = diag([d1, d2, d3]*0); % Friction removed
%system_params.D = diag([d1, d2, d3]*2);
%system_params.cable_spring_coefficient = 10;
%system_params.cable_damping_coefficient = 0.1;
% Good for one angle at the time: 50k, 0.1
%system_params.cable_spring_coefficient = 500000;
%system_params.cable_spring_coefficient = 50000; % Bra med b MPC
system_params.cable_spring_coefficient = 500000;
system_params.cable_damping_coefficient = 10;
%system_params.cable_spring_coefficient = 300000; % Bra med a dc
%system_params.cable_damping_coefficient = 5100;

system_params.cable_spring_coefficient = 50000; % Bra med begge vinkla (quaternions)
system_params.cable_damping_coefficient = 10000;

system_params.cable_spring_coefficient = 50000; % Okei med wrapping (a)
system_params.cable_damping_coefficient = 10000;

system_params.cable_spring_coefficient = 50000; % Okei med wrapping
system_params.cable_damping_coefficient = 1000;

%system_params.cable_spring_coefficient = 50000; % Okei med wrapping + Fusion modell
%system_params.cable_damping_coefficient = 1000;

system_params.cable_spring_coefficient = 0; % Turn off system
system_params.cable_damping_coefficient = 0;


% Save space
m = system_params.m;
L_h = system_params.L_h; % Extract arm length from parameters
R_h = system_params.R;
dt = system_params.dt;

system_params.W = diag([m*L_h^2 / 3;m*L_h^2 / 3; m*R_h^2 / 2]);
system_params.I = diag([m*L_h^2 / 3;m*L_h^2 / 3; m*R_h^2 / 2]);
W_inv = inv(system_params.W);

% Scale u to optimize controller
system_params.K1 = 1;

% Get position parameters
%pos_param = 'GPT';
%pos_param = 'Fusion';
pos_param = 'Fusion';
pos_init;

% Get alphas for lower/upper rotator cuff ratio control
alphas_init;

% Initial conditions
q_neutral = [0;0;0];
q0 = [0; 0; 0];
qdot0 = [0;0;0];
u0 = u0_calc(q0, system_params);
u_offset = zeros(size(u0));
system_params.u0 = u0;

% Quaternions init:
q0_quat = euler2quat(q0);
qdot0_quat = zeros(4,1);
omega0 = qdot0;

% Offset term to Arduino
u_offset = [106; 80; 79; 75; 67; 72; 80]/1000 - u0_calc(q_neutral, system_params);

% Wrapping plane init:
v_init;

% Create bus object for Simulink
evalin('base', ['clear ' 'System_params_bus']);
Sys_params_bus_info = Simulink.Bus.createObject(system_params);
oldName = Sys_params_bus_info.busName;
busObj = evalin('base', oldName);
assignin('base', 'System_params_bus', busObj);
% Remove the auto name
evalin('base', ['clear ' oldName]);


% Dummy controller inputs
angle = 10; % In degrees 
angle = angle*pi/180;
set_points = [angle;0;0];
set_points_q = euler2quat(set_points);

Tau = 10; % 1/f
T_stop = 100; % seconds
t = 0:dt:T_stop;
x_s = zeros(length(t), 7); % N×nx matrix
set_point_zero = timeseries(x_s, t); % For easy debugging
x_s(1:end,1:4) = repmat(set_points_q',length(t),1);
%x_s(:,1) = angle*pi/180 * ones(length(t), 1); % N×nx matrix
%x_s(600:end,2) = (angle+10)*pi/180 * ones(length(600:size(t,2)), 1); % N×nx matrix
%x_s(900:end,2) = (angle+20)*pi/180 * ones(length(900:size(t,2)), 1); % N×nx matrix
%x_s(800:end,2) = (angle+15)*pi/180 * ones(length(800:size(t,2)), 1); % N×nx matrix
%x_s(1200:end,2) = (angle+20)*pi/180 * ones(length(1200:size(t,2)), 1); % N×nx matrix
%x_s(:,3) = angle*pi/180 * sin((2*pi/Tau)*t);
set_point = timeseries(x_s, t);
