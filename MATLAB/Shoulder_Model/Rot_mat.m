function R = Rot_mat(q)
    theta = q(1); phi = q(2); psi = q(3);
    R = [cos(psi)*cos(phi), cos(psi)*sin(phi)*sin(theta)-sin(psi)*cos(theta), cos(psi)*sin(phi)*cos(theta)+sin(psi)*sin(theta);
        sin(psi)*cos(phi), sin(psi)*sin(phi)*sin(theta)+cos(psi)*cos(theta), sin(psi)*sin(phi)*cos(theta)-cos(psi)*sin(theta);
        -sin(phi), cos(phi)*sin(theta), cos(phi)*cos(theta)];
end

