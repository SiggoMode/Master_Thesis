function A_EQ = gen_aeq(A, B, N)
a = diag_repeat(eye(ndims(A)),N);
b = diag_repeat(-B,N);
dim = ndims(A);

for i = 1:N-1
    col1 = 1 + (i-1)*dim;
    col2 = i*dim;
    row1 = 1 + i*dim;
    row2 = (1+i)*dim;
    a(row1:row2, col1:col2) = -A;
end

A_EQ = [a b];