function Tau = Tau_tension_calc(u, udot, q, omega, system_params)
R = quat2rotm(q);
R_humerus = system_params.Rhum;

fields = fieldnames(system_params.cables);

Tau_B = zeros(3,1);
for i = 1:numel(fields)
    cable = system_params.cables.(fields{i});
    p_humerus = R * cable.L;
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
    p_norm = norm(p_closest);
    p_hat = p_closest/p_norm;

    if p_norm < R_humerus
    
   
        % Create wrapping point
        p_wrap = p_closest/p_norm * R_humerus;
        v = cable.v;

        % if dot(p_wrap, v) < -1e-6 % Flip wrapping point if on the wrong side of humerus
        %     p_wrap = - p_wrap;
        % end

        if dot(p_wrap, v) < -1e-6 % Mirror wrapping point about mirror plane if wrong side
            p_wrap = p_wrap - 2 * dot(p_wrap, v) * v;
        end

        li = norm(p_humerus - p_wrap) + norm(p_scapula - p_wrap);

        p_humerus_dot = cross(omega, p_humerus);
        di_dot = -p_humerus_dot;
        n_dot = di_dot'*p_humerus + di'*p_humerus_dot;
        d_dot = 2*di'*di_dot;
        t_star_dot = -n_dot/d + n/d^2 * d_dot;
        p_closest_dot = p_humerus_dot + t_star_dot*di + t_star*di_dot;
        p_wrap_dot = R_humerus/p_norm * (eye(3)-p_hat*p_hat')*p_closest_dot;
        term1 = (p_humerus-p_wrap)'/norm(p_humerus-p_wrap)*(p_humerus_dot-p_wrap_dot);
        term2 = (p_scapula-p_wrap)'/norm(p_scapula-p_wrap)*-p_wrap_dot;
        lidot = term1 + term2; 

        di = p_wrap - p_humerus;
        di_hat = di/norm(di);
    else
        % Calculate as normal
        lidot = -di_hat' * cross(omega, ri);
    end
        
    
    u0 = system_params.u0(i);

    Fwi = Tension(u(i), u0, li, udot(i), lidot, system_params);
    Tau_Wi = cross(ri, Fwi*di_hat);
    Tau_B = Tau_B + R'*Tau_Wi;
end

Tau = Tau_B;

end