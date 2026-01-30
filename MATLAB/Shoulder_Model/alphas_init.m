function alpha = alpha_calc(muscle)
    r = - muscle.L + muscle.M;
    r = r/vecnorm(r);
    alpha = asin(-r(3));
end

AUR.alpha = alpha_calc(AUR);
ALR.alpha = alpha_calc(ALR);
PUR.alpha = alpha_calc(PUR);
PLR.alpha = alpha_calc(PLR);