clear;
% Add subfolders and initialize variables
addpath(genpath("Kalman")), addpath(genpath("MPC")), addpath(genpath("Shoulder_Model")), 
addpath(genpath("SimpleController")), addpath(genpath("Calibration")), addpath(genpath("Math"));

model_init; EKF_tuning; MPC_tuning; dummyPath; calibration_parameters;