function qddot = system_model_quarternions(q, qdot, system_params)
q1 = q(2); q2 = q(3);
v = [0;q1;q2;0];

m = system_params.m;
g = system_params.g;
l = system_params.L_h;

M = M_gen(q, system_params);
M_inv = M \ eye(4);
Mdot = Mdot_gen(q, qdot, system_params);
lambda = lambda_gen(q, qdot, v, M_inv, Mdot, system_params);


%qddot = -M_inv*Mdot*qdot -2*m*g*l*M_inv * [0;q1;q2;0] + 2*M_inv*lambda*q +
%M_inv * Q_i; Not yet Q_i

qddot = -M_inv*Mdot*qdot -2*m*g*l*M_inv * v + 2*M_inv*lambda*q;

end