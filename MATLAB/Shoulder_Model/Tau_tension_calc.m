function Tau = Tau_tension_calc(u, udot, q, omega, system_params)
R = quat2rotm(q);

fields = fieldnames(system_params.cables);

Tau_B = zeros(3,1);
for i = 1:numel(fields)
    cable = system_params.cables.(fields{i});
    p_humerus = cable.L;
    p_scapula = cable.M;

    rpli = R * p_humerus;
    di = p_scapula - rpli;
    
    li = norm(di);
    di_hat = di/li;

    lidot = -di_hat' * cross(omega, rpli);
    
    
    u0 = system_params.u0(i);

    Fwi = Tension(u(i), u0, li, udot(i), lidot, system_params);
    Tau_Wi = cross(rpli, Fwi*di_hat);
    Tau_B = Tau_B + R'*Tau_Wi;
end

Tau = Tau_B;

end