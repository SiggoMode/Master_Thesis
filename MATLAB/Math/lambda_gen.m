function lambda = lambda_gen(q, qdot, v, M_inv, Mdot, system_params)
m = system_params.m;
g = system_params.g;
l = system_params.L_h;

%num = q'*M_inv*(Mdot*qdot + 2*m*g*l*v) - M_inv*Q - qdot'*q;
num = q'*M_inv*(Mdot*qdot + 2*m*g*l*v) - qdot'*qdot;
den = 2*q'*M_inv*q;

lambda = num/den;
end