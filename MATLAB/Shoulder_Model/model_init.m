% Parameters
m = 5; % Arm mass in kg
Lh = 1; % Arm length in meters
R = 0.1; % Cylinder radius in meters (Arm model)
%R = 5;
g = 9.81; % m/s^2

W = diag([m*Lh^2 / 3;m*Lh^2 / 3; m*R^2 / 2]);
W_inv = inv(W);

% Get position parameters
% pos_param = 'GPT';
pos_param = 'Fusion';
pos_init;

% Get alphas for lower/upper rotator cuff ratio control
alphas_init;

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
