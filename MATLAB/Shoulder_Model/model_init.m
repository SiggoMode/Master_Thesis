% Parameters
system_params.m = 5;   % Arm mass in kg
system_params.L_h = 1; % Arm length in meters
system_params.R = 0.1; % Cylinder radius in meters (Arm model)
%R = 5;
system_params.g = 9.81; % m/s^2

% Save space
m = system_params.m;
L_h = system_params.L_h; % Extract arm length from parameters
R_h = system_params.R;

system_params.W = diag([m*L_h^2 / 3;m*L_h^2 / 3; m*R_h^2 / 2]);
W_inv = inv(system_params.W);

% Get position parameters
% pos_param = 'GPT';
pos_param = 'Fusion';
pos_init;

% Get alphas for lower/upper rotator cuff ratio control
alphas_init;

% Create bus object for Simulink
busInfo = Simulink.Bus.createObject(system_params);
busName = busInfo.busName;

% Initial conditions
q0 = [0; 0; 0];
qdot0 = [0;0;0];

% Dummy controller inputs
angle = 60; % In degrees 
Tau = 10; % 1/f
dt = 0.01;
T_stop = 100; % seconds
t = 0:dt:T_stop;
q_s = zeros(length(t), 3); % N×3 matrix
set_point_zero = timeseries(q_s, t); % For easy debugging
q_s(:,1) = angle*pi/180 * ones(length(t), 1); % N×3 matrix
%q_s(:,3) = angle*pi/180 * sin((2*pi/Tau)*t);
set_point = timeseries(q_s, t);
