function [x_post,P_post] = EKF_upd(x_pred, P_pred, z_pred, z_k, R_kf)
v_k = z_k - z_pred;
H = [eye(3), zeros(3,3)]; % Basic measurement matrix
S_k = H*P_pred*H' + R_kf;
W_k = P_pred*H'/S_k;
x_post = x_pred + W_k*v_k;
P_post = (eye(size(P_pred))-W_k*H)*P_pred;
end