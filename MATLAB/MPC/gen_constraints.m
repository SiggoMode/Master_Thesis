function [lb,ub] = gen_constraints(lb_pre, ub_pre, nx, nu, N)
lbx = lb_pre(1:nx-1); % have to add affine term manually
lbu = lb_pre(nx:nx + nu);
end