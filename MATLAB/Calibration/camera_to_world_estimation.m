% Calculate average of Tcw for both cameras
ids = fieldnames(top_cam);

% Calculate inverse of T_cm to get T_mc
T_topwc1 = calibration_markers.id31.Twm * inv(top_cam.id31.Tcm);
T_topwc2 = calibration_markers.id34.Twm * inv(top_cam.id34.Tcm);

T_sidewc1 = calibration_markers.id24.Twm * inv(side_cam.id24.Tcm);
T_sidewc2 = calibration_markers.id20.Twm * inv(side_cam.id20.Tcm);


% Calculate average
R_topwc1 = T_topwc1(1:3,1:3);
R_topwc2 = T_topwc2(1:3,1:3);
R_sidewc1 = T_sidewc1(1:3,1:3);
R_sidewc2 = T_sidewc2(1:3,1:3);

t_topcw1 = T_topwc1(1:3,4);
t_topcw2 = T_topwc2(1:3,4);
t_sidecw1 = T_sidewc1(1:3,4);
t_sidecw2 = T_sidewc2(1:3,4);

% Translation
t_topwc = (t_topcw1 + t_topcw2) / 2;
t_sidewc = (t_sidecw1 + t_sidecw2) / 2;

% Rotation
% Convert to quarternions
q_topwc1 = rotm2quat(R_topwc1);
q_topwc2 = rotm2quat(R_topwc2);
q_sidewc1 = rotm2quat(R_sidewc1);
q_sidewc2 = rotm2quat(R_sidewc2);

% Ensure same hemisphere
q_ref = q_topwc1;

if dot(q_topwc2,q_ref) < 0
    q_topwc2 = -q_topwc2; 
end
q_ref = q_sidewc1;

if dot(q_sidewc2,q_ref) < 0
    q_sidewc2 = -q_sidewc2; 
end

% Average and normalize quaternions
q_avg_topwc = (q_topwc1 + q_topwc2) / 2;
q_avg_topwc = q_avg_topwc / norm(q_avg_topwc);

q_avg_sidewc = (q_sidewc1 + q_sidewc2) / 2;
q_avg_sidewc = q_avg_sidewc / norm(q_avg_sidewc);

% Convert back to rotation matrices
R_topwc = quat2rotm(q_avg_topwc);
R_sidewc = quat2rotm(q_avg_sidewc);

% Create translation matrix
T_topwc = T_gen(R_topwc, t_topwc);
T_sidewc = T_gen(R_sidewc, t_sidewc);

