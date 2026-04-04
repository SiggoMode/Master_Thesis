function R = rodrigues(rvec)
    theta = norm(rvec);

    if theta < 1e-12
        R = eye(3);
        return;
    end

    k = rvec / theta;

    K = [   0   -k(3)  k(2);
          k(3)   0   -k(1);
         -k(2) k(1)    0 ];

    R = eye(3) + sin(theta)*K + (1 - cos(theta))*(K*K);
end