function omega_big = omega_big_gen(omega)
wx = omega(1); wy = omega(2); wz = omega(3);

omega_big = [0,    -wx,   -wy,   -wz;
             wx,   0,     wz,    -wy;
             wy,   -wz,   0,     wx;
             wz,   wy,    -wx,   0 ];
end