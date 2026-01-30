function [M, Mdot] = M_Mdot(q, qdot)
    theta = q(1);
    phi = q(2);
    theta_dot = qdot(1);
    phi_dot = qdot(2);

    M = [1, 0, -sin(phi);
         0, cos(theta), sin(theta)*cos(phi);
         0, -sin(theta), cos(theta)*cos(phi)];

    Mdot = [0, 0, -cos(phi)*phi_dot;
              0, -sin(theta)*theta_dot, cos(theta)*cos(phi)*theta_dot - sin(theta)*sin(phi)*phi_dot;
              0, -cos(theta)*theta_dot, -sin(theta)*cos(phi)*theta_dot - cos(theta)*sin(phi)*phi_dot];
end