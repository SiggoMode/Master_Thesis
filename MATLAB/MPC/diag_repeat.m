function A = diag_repeat(mat, N)
dim1 = size(mat,1);
dim2 = size(mat,2);

A = zeros(dim1*N,dim2*N);

for i = 1:N
    %index1 = 1 + (i-1)*dim;
    %index2 = i*dim;

    row_i1 = 1 + (i-1)*dim1;
    col_i1 = 1 + (i-1)*dim2;

    row_i2 = i*dim1;
    col_i2 = i*dim2;

    A(row_i1:row_i2, col_i1:col_i2) = mat;
end