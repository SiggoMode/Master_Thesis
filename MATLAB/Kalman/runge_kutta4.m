function x_pred = runge_kutta4(x_prev, u_k, u_kp1, Ts, system_params)

    k1 = system_model_continous(x_prev, u_k, u_kp1, system_params);
    k2 = system_model_continous(x_prev + (Ts/2)*k1, u_k + Ts/2, u_kp1, system_params);
    k3 = system_model_continous(x_prev + (Ts/2)*k2, u_k + Ts/2, u_kp1, system_params);
    k4 = system_model_continous(x_prev + Ts*k3,     u_k + Ts,   u_kp1, system_params);

    x_pred = x_prev + (Ts/6) * (k1 + 2*k2 + 2*k3 + k4);
end