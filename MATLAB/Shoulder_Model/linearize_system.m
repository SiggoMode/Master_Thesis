function [Ad,Bd,c] = linearize_system(x0,u0,u0_dot,system_params)
n = length(x0);
m = length(u0);

eps_base = 1e-6;

A = zeros(n,n);
B = zeros(n,m);
Ts = system_params.dt;

% State jacobian
for i = 1:n
    eps_i = eps_base * max(abs(x0(i)),1);
    
    dx = zeros(n,1);
    dx(i) = eps_i;
    
    f_plus  = system_model_quat_omega(x0 + dx, u0, u0_dot, system_params);
    f_minus = system_model_quat_omega(x0 - dx, u0, u0_dot, system_params);
    
    A(:,i) = (f_plus - f_minus) / (2*eps_i);
end

% Input jacobian
for j = 1:m
    
    eps_j = eps_base * max(abs(u0(j)),1);
    
    du = zeros(m,1);
    du(j) = eps_j;
    
    f_plus  = system_model_quat_omega(x0, u0 + du, u0_dot, system_params);
    f_minus = system_model_quat_omega(x0, u0 - du, u0_dot, system_params);
    
    B(:,j) = (f_plus - f_minus) / (2*eps_j);
end

[Ad, Bd] = discretize_system(A, B, system_params);

% Add affine term
f0 = runge_kutta4(x0,u0, u0_dot, Ts,system_params);
c = f0 - Ad*x0 - Bd*u0;


