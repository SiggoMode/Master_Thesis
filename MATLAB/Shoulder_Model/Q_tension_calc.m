function Q = Q_tension_calc(u, udot, q, qdot, system_params)
R_h = Rot_mat(q);
R_hxy = Rot_xy(q);
Q = zeros(3,1);
fields = fieldnames(system_params.cables);


for i = 1:numel(fields)
    cable = system_params.cables.(fields{i});
    p_humerus = cable.L;
    p_scapula = cable.M;
    %if i < 4
        ri = - R_h*p_humerus + p_scapula;
        %ri = R_h*cable.L - cable.M;
        rpli = R_h * p_humerus;
        % Calc drdq
        drdq_ = drdq(q, rpli);
        
    % else
    %     ri = - R_hxy*cable.L + cable.M;
    %     ri = R_hxy*cable.L - cable.M;
    %     rpli = R_hxy * cable.L;
    %     % Calc drdq
    %     drdq_ = drdq(q, rpli);
    % 
    % end
    li = norm(ri);
    di = ri/li;
    dldq = zeros(3,1);
    for j = 1:3
        dldq(j) = di'*drdq_(:,j);
    end
    drdq_;
    lidot = -dldq'*qdot;
    
    u0 = system_params.u0(i);
    T = Tension(u(i), u0, li, udot(i), lidot, system_params);
   
    
    % Calc Q
    Q = Q + T*dldq;
end
end