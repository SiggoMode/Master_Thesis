function [upper, lower] = ul_ratio(q, alpha1, alpha2)
    theta = q(1); phi = q(2);
    gamma = acos(cos(theta)*cos(phi));
    rat = (gamma-alpha1)/(alpha2-alpha1); % Two-point formula

    if rat > 1   % Constrain between 0 and 1
        rat = 1;
    elseif rat < 0
        rat = 0;
    end

    upper = (1-rat);
    lower = rat;
end

