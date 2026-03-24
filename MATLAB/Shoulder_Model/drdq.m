% function drdq = drdq(r)
%     rx = r(1); ry = r(2); rz = r(3);
%     drdq = [0, rz, -ry;
%             -rz, 0, rx;
%             ry, -rz, 0];
% end

function drdq = drdq(q, r)
    %Rx = Rot_mat([q(1);0;0]);
    %Rxy = Rot_mat([q(1);q(2);0]);
    Rx = rotx(q(1));
    Ry = roty(q(2));
    Rz = rotz(q(3));

    ex = [1;0;0];
    ey = [0;1;0];
    ez = [0;0;1];

    %omega = [Rz*Ry*ex, Rz*ey, ez];
    omega = [ex, Rx*ey, Rx*Ry*ez];
    drdq = zeros(3,3);

    for i = 1:3
        drdq(:,i) = cross(omega(:,i), r);
    end
end


