function A = diag_repeat(mat, N)
dim = ndims(mat);
A = zeros(dim*N);

for i = 1:N
    index1 = 1 + (i-1)*dim;
    index2 = i*dim;
    
    A(index1:index2, index1:index2) = mat;
end