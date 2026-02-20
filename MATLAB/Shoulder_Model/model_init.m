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
evalin('base', ['clear ' 'System_params_bus']);
Sys_params_bus_info = Simulink.Bus.createObject(system_params);
oldName = Sys_params_bus_info.busName;
busObj = evalin('base', oldName);
assignin('base', 'System_params_bus', busObj);
% Remove the auto name
evalin('base', ['clear ' oldName]);


% Initial conditions
q0 = [0; 0; 0];
qdot0 = [0;0;0];

% Dummy controller inputs
angle = 60; % In degrees 
Tau = 10; % 1/f
dt = 0.01;
T_stop = 100; % seconds
t = 0:dt:T_stop;
x_s = zeros(length(t), 6); % N×nx matrix
set_point_zero = timeseries(x_s, t); % For easy debugging
x_s(:,2) = angle*pi/180 * ones(length(t), 1); % N×nx matrix
%x_s(:,3) = angle*pi/180 * sin((2*pi/Tau)*t);
set_point = timeseries(x_s, t);
