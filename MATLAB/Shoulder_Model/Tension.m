function T = Tension(ui, u0, li, uidot, lidot, system_params)
    K1 = system_params.K1;
    k = system_params.cable_spring_coefficient;
    c = system_params.cable_damping_coefficient;
    T = k * (K1*li - ui) + c * (K1*lidot - uidot);
    T = max(0,T)/K1;
    %T
end

