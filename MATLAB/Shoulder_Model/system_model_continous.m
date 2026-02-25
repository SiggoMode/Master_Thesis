function [x_dot] = system_model_continous(x, u, system_params)
x_dot = zeros(size(x));
q = x(1:3); 
qdot = x(4:6);

[W_inv, W_dot] = W_Wdot(q, qdot, system_params.W);
dLdq_ = dLdq(q, qdot, system_params);

%R_h = Rot_mat(q);
Q_force = Q_force_calc(u,q,system_params);

K1 = system_params.K1; % Scaling parameter

x_dot(1:3) = x(4:6);
x_dot(4:6) = -W_inv*W_dot*qdot + W_inv*dLdq_ + K1*W_inv*Q_force;
end