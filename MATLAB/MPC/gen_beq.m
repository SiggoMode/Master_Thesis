function beq = gen_beq(A, x0, N)
beq = [A*x0; zeros(ndims(A)*(N-1), 1)];