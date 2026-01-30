function sl = sl_calc(connections)
    if vecnorm(connections.L) > vecnorm(connections.M)
        sl = 2*vecnorm(connections.M);
    else
        sl = 2*vecnorm(connections.L);
    end
end


% Estimated required stroke length of each muscle
FD.stroke = sl_calc(FD)  % Front deltoid
LD.stroke = sl_calc(LD)  % Lateral deltoid
RD.stroke = sl_calc(RD)  % Rear deltoid
PUR.stroke = sl_calc(PUR)  % posterior upper rotator cuff
PLR.stroke = sl_calc(PLR)  % posterior lower rotator cuff
AUR.stroke = sl_calc(AUR)  % anterior upper rotator cuff
ALR.stroke = sl_calc(ALR)  % anterior lower rotator cuff
