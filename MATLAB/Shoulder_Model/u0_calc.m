function u0 = u0_calc(q0, system_params)
    fields = fieldnames(system_params.cables);
    R_h = Rot_mat(q0);
    R_hxy = Rot_xy(q0);
    u0 = zeros(size(fields));

    for i = 1:numel(fields)
        cable = system_params.cables.(fields{i});
        %if i < 4
            ri = - R_h*cable.L + cable.M;
            
        % else
        %     ri = - R_hxy*cable.L + cable.M;
        % end
        u0(i) = sqrt(ri'*ri) * system_params.K1;
    end
end