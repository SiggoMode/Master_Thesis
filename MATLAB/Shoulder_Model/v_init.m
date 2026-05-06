fields = fieldnames(system_params.cables);

q_neutral = euler2quat([0;0;0]);
R_neutral = quat2rotm(q_neutral);

for i = 1:numel(fields)
    cable = system_params.cables.(fields{i});
    p_humerus = R_neutral * cable.L;
    p_scapula = cable.M;

    ri = p_humerus;
    di = p_scapula - ri;
        
    li = norm(di);
    di_hat = di/li;

    % Check for cable-humerus collision
    n = di'*p_humerus;
    d = di'*di;
    t_star = -n/d;
    p_closest = p_humerus + t_star * di;
    v = p_closest/norm(p_closest);
    system_params.cables.(fields{i}).v = v;
end

% Flip medial deltoid wrapping vector
system_params.cables.LD.v = -system_params.cables.LD.v;