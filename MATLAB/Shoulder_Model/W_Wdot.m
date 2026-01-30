function [W_inv_rot, Wdot] = W_Wdot(q, qdot, W)
    [M, Mdot] = M_Mdot(q, qdot);
    Wdot = Mdot'*W*M + M'*W*Mdot;

    W_inv_rot = inv(M'*W*M);
end