function x_pred = runge_kutta4(x_prev, u_k, Ts, system_params)

    k1 = system_model_continous(x_prev, u_k, system_model_continous);
    k2 = system_model_continous(x_prev + Ts/2, u_k + (Ts/2)*k1, system_params);
    k3 = system_model_continous(x_prev + Ts/2, u_k + (Ts/2)*k2, system_params);
    k4 = system_model_continous(x_prev + Ts,   u_k + Ts * k3,   system_params);

    x_pred = x_prev + (Ts/6) * (k1 + 2*k2 + 2*k3 + k4);
end