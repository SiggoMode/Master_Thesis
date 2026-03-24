function [qslope] = dummySlopes(qs,q,slope,system_params)
dt = system_params.dt;
t = abs(qs - q)/slope;
t_max = ceil(max(t));
qslope = repmat(q,1,t_max+1);

for i = 1:length(q)
    for j = 1:t_max
        q_diff = qs(i) - qslope(i,j);

        if abs(q_diff) <= slope
            qslope(i,j+1) = qs(i);
        
        elseif q_diff < slope
            qslope(i,j+1) = qslope(i,j) - slope;

        elseif q_diff > slope
            qslope(i,j+1) = qslope(i,j) + slope;

        end
        
    end
end
end
