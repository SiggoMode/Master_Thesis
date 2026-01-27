function u = MPC(Ai, Bi, xi, MPC_settings)
H = MPC_settings.H;
lb = MPC_settings.lb;
ub = MPC_settings.ub;
N = MPC_settings.N;
nx = MPC_settings.nx;
nu = MPC_settings.nu;
options = MPC_settings.options;

Aeq = gen_aeq(Ai, Bi, N);
beq = gen_beq(Ai, xi, N);

z0 = [xi;zeros((N-1)*nx + N*nu,1)];

z = quadprog(H, [], [], [], Aeq, beq, lb, ub, z0, options);
u = z(nx*N+1 : nx*N + nu);