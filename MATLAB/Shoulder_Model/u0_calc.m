function u0 = u0_calc(q0, system_params)
    fields = fieldnames(system_params.cables);
    R_humerus = system_params.Rhum;
    R = Rot_mat(q0);
    R_h = Rot_mat(q0);
    R_hxy = Rot_xy(q0);
    u0 = zeros(size(fields));

    for i = 1:numel(fields)
        cable = system_params.cables.(fields{i});
        p_humerus = R * cable.L;
        p_scapula = cable.M;
    
        ri = p_humerus;
        di = p_scapula - ri;

        % Check for cable-humerus collision
        n = di'*p_humerus;
        d = di'*di;
        t_star = -n/d;
        p_closest = p_humerus + t_star * di;
        p_norm = norm(p_closest);
    
        if p_norm < R_humerus
            p_wrap = p_closest/p_norm * R_humerus;

            u0(i) = (norm(p_humerus - p_wrap) + norm(p_scapula - p_wrap)) * system_params.K1;

        else
            u0(i) = sqrt(di'*di) * system_params.K1;
        end
    end
end