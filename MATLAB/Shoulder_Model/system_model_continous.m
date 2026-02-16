function [x_dot] = system_model_continous(x, u, system_params)
x_dot = zeros(size(x));
q = x(1:3); q_dot = x(4:6);

[W_inv, W_dot] = W_Wdot(q, qdot, system_params.W);
dLdq_ = dLdq(q, q_dot, system_params);

%R_h = Rot_mat(q);
Q_force = Q_force_calc(u,q,system_params);

x_dot(1:3) = x(4:6);
x_dot(4:6) = -W_inv*W_dot*q_dot + W_inv*dLdq_ + W_inv*Q_force;
end