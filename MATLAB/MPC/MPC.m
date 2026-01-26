function u = MPC(Ai, Bi, N, xi, H, lb, ub)

Aeq = gen_aeq(Ai, Bi, N);
Beq = gen_beq(Ai, xi, N);

z = quadprog(H, )