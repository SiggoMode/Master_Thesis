function H = H_calc(x)
q = x(1:4);
n = length(x);
m = 3; % [A, B, C] Euler angles

H = zeros(m,n);

eps_base = 1e-6;

for i = 1:4
    
    eps_i = eps_base * max(abs(q(i)),1);
    
    dq = zeros(4,1);
    dq(i) = eps_i;
    
    q_plus  = q + dq;
    q_minus = q - dq;
    
    %normalize
    q_plus  = q_plus  / norm(q_plus);
    q_minus = q_minus / norm(q_minus);
    
    % evaluate measurement
    h_plus  = quat2euler(q_plus);
    h_minus = quat2euler(q_minus);
    
    % central difference
    H(:,i) = (h_plus - h_minus) / (2*eps_i);
end
end