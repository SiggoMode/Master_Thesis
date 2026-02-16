function dLdq_ = dLdq(q, qdot, system_params)
    W = system_params.W;
    m = system_params.m;
    g = system_params.g;
    L_h = system_params.L_h;

    theta = q(1);
    phi = q(2);
    %psi = q(3); % Never used
    [M, ~] = M_Mdot(q, qdot);
    dMdtheta = [0, 0, 0;
                0, -sin(theta), cos(theta)*cos(phi);
                0, -cos(theta), -sin(theta)*cos(phi)];

    dMdphi = [0, 0, -cos(phi);
              0, 0, -sin(theta)*sin(phi);
              0, 0, -cos(theta)*sin(phi)];

    dTdtheta = 0.5*qdot'*(dMdtheta'*W*M + M'*W*dMdtheta)*qdot;
    dTdphi = 0.5*qdot'*(dMdphi'*W*M + M'*W*dMdphi)*qdot;
    dTdpsi = 0;


    dV_dtheta = .5*L_h*m*g*sin(theta)*cos(phi);
    dV_dphi = .5*L_h*m*g*cos(theta)*sin(phi);
    dV_dpsi = 0;

    dTdq = [dTdtheta; dTdphi; dTdpsi];
    dVdq = [dV_dtheta; dV_dphi; dV_dpsi];

    dLdq_ = dTdq - dVdq;
end