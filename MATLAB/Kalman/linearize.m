function [Ad,Bd,c] = linearize(x0,u0,u0_dot,system_params)

n = length(x0);
m = length(u0);

eps_base = 1e-6;

Ad = zeros(n,n);
Bd = zeros(n,m);
Ts = system_params.dt;

% Nominal next state
f0 = runge_kutta4(x0,u0, u0_dot, Ts,system_params);

%% ---- State Jacobian (central difference) ----
for i = 1:n
    
    eps_i = eps_base * max(abs(x0(i)),1);
    
    dx = zeros(n,1);
    dx(i) = eps_i;
    
    f_plus  = runge_kutta4(x0 + dx, u0, u0_dot, Ts, system_params);
    f_minus = runge_kutta4(x0 - dx, u0, u0_dot, Ts, system_params);
    
    Ad(:,i) = (f_plus - f_minus) / (2*eps_i);
end

%% ---- Input Jacobian ----
for j = 1:m
    
    eps_j = eps_base * max(abs(u0(j)),1);
    
    du = zeros(m,1);
    du(j) = eps_j;
    
    f_plus  = runge_kutta4(x0, u0 + du, u0_dot, Ts, system_params);
    f_minus = runge_kutta4(x0, u0 - du, u0_dot, Ts, system_params);
    
    Bd(:,j) = (f_plus - f_minus) / (2*eps_j);
end

%% ---- Affine offset term ----
c = f0 - Ad*x0 - Bd*u0;

end
