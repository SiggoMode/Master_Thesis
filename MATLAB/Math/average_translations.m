function T = average_translations(Ts)
    n = size(Ts, 2) / 4;

    R = Ts(1:3, 1:3);
    q_ref = rotm2quat(R);
    t_avg = Ts(1:3,4);
    q_avg = q_ref;

    for i = 2:n
        R = Ts(1:3, 4*i-3:4*i-1);
        t = Ts(1:3, 4*i);

        % Convert to quarternions
        q = rotm2quat(R);
        if dot(q,q_ref) < 0 % Ensure same hemisphere
            q = -q; 
        end
        t_avg = t_avg + t;
        q_avg = q_avg + q;
    end
    t_avg = t_avg / n;
    q_avg = q_avg / norm(q_avg);
    R_avg = quat2rotm(q_avg);

    T = T_gen(R_avg, t_avg);
end