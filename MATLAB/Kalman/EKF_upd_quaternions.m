function [x_post,P_post] = EKF_upd_quaternions(x_pred, P_pred, z_pred, z_k, EKF_settings)
H = H_calc(x_pred);
R_kf = EKF_settings.R;
v_k = wrapToPi(z_k - z_pred); % Wrap if angles cross pi
S_k = H*P_pred*H' + R_kf;
W_k = P_pred*H'/S_k;
x_post = x_pred + W_k*v_k;
P_post = (eye(size(P_pred))-W_k*H)*P_pred;

x_post(1:4) = x_post(1:4) / norm(x_post(1:4));
end