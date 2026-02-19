clear;
% Add subfolders and initialize variables
addpath(genpath("Kalman")); addpath(genpath("MPC")), addpath(genpath("Shoulder_Model"));
model_init; EKF_tuning; MPC_tuning;