function Q = Q_force_calc(u, q, system_params)
R_h = Rot_mat(q);
R_hxy = Rot_xy(q);
Q = zeros(3,1);
fields = fieldnames(system_params.cables);


for i = 1:numel(fields)
    cable = system_params.cables.(fields{i});
    if i < 4
        % Calc drdq
        drdq_ = drdq(R_h*cable.L, q);
        
        % Calc F
        rpli_pmi = - R_h*cable.L + cable.M;
    else
        % Calc drdq
        drdq_ = drdq(R_hxy*cable.L, q);
        
        % Calc F
        rpli_pmi = - R_hxy*cable.L + cable.M;
    end
    F = Force(u(i), rpli_pmi);
    
    % Calc Q
    Q = Q + drdq_.' * F;
end
end