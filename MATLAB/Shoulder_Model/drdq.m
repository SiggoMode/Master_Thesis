function drdq = drdq(r, q)
    rx = r(1); ry = r(2); rz = r(3);
    drdq = [0, rz, -ry;
        -rz, 0, rx;
        ry, -rz, 0];
end

