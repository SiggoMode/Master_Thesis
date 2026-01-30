function V_dot = dLdq(q, qdot, W, m, g, Lh)
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


    dV_dtheta = .5*Lh*m*g*sin(theta)*cos(phi);
    dV_dphi = .5*Lh*m*g*cos(theta)*sin(phi);
    dV_dpsi = 0;

    dTdq = [dTdtheta; dTdphi; dTdpsi];
    dVdq = [dV_dtheta; dV_dphi; dV_dpsi];

    V_dot = dTdq - dVdq;
end