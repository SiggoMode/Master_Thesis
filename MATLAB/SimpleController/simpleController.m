function [u] = simpleController(q,qs, slope, system_params)
q_diff = qs - q;
q_new = zeros(size(q));
for i = 1:length(q)

    if q_diff(i) == 0
        continue

    elseif abs(q_diff(i)) < slope
        q_new(i) = qs(i);

    elseif q(i) < qs(i)
        q_new(i) = q(i) + slope;

    elseif q(i) > qs(i)
        q_new(i) = q(i) - slope;

    end
end
u = u0_calc(q_new, system_params);
end