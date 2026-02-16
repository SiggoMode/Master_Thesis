function alpha = alpha_calc(muscle)
    r = - muscle.L + muscle.M;
    r = r/vecnorm(r);
    alpha = asin(-r(3));
end

system_params.cables.AUR.alpha = alpha_calc(system_params.cables.AUR);
system_params.cables.ALR.alpha = alpha_calc(system_params.cables.ALR);
system_params.cables.PUR.alpha = alpha_calc(system_params.cables.PUR);
system_params.cables.PLR.alpha = alpha_calc(system_params.cables.PLR);