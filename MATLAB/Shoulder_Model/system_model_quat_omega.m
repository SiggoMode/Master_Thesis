function xdot = system_model_quat_omega(x, u, udot, system_params)
q = x(1:4);
omega = x(5:7);
I = system_params.I;
m = system_params.m;
g = system_params.g;
l = system_params.L_h;

q = q/norm(q);

F_W = [0;0;-m*g];
R = quat2rotm(q);
r_B = [0;0;-l/2];
r_W = R*r_B;
tau_W = cross(r_W, F_W);
tau_B = R' * tau_W;

tau_cables = Tau_tension_calc(u, udot, q, omega, system_params);

Omega = omega_big_gen(omega);
omega_dot = I \ (tau_B + tau_cables - cross(omega, I*omega));
qdot = 0.5*Omega * q;

xdot = [qdot; omega_dot];
end