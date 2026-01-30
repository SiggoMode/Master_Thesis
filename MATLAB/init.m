% Add subfolders and initialize variables
addpath(genpath("Kalman")); addpath(genpath("MPC")), addpath(genpath("Shoulder_Model"));
EKF_tuning; MPC_tuning; model_init;