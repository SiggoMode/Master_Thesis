function R = Rot_xy(q)
    theta = q(1); phi = q(2);
    R = [cos(phi), sin(phi)*sin(theta), sin(phi)*cos(theta);
        0, cos(theta), -sin(theta);
        -sin(phi), cos(phi)*sin(theta), cos(phi)*cos(theta)];
end

