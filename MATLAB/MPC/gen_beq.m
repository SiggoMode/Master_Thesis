function beq = gen_beq(A, x0, N)
beq = [A*x0; zeros(size(A,1)*(N-1), 1)];