function [Ad, Bd] = discretize_system(A,B,system_params)
dt = system_params.dt;
n = size(A,1);
m = size(B,2);

M = [A, B; zeros(m, n+m)];

exponential = expm(M*dt);
Ad = exponential(1:n,1:n);
Bd = exponential(1:n,n+1:n+m);