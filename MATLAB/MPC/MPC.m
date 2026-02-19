function u = MPC(Ai, Bi, xi, x_sp, MPC_settings, options)
%function u = MPC(Ai, Bi, xi, x_sp, MPC_settings)
H = MPC_settings.H;
lb = MPC_settings.lb;
ub = MPC_settings.ub;
N = MPC_settings.N;
nx = MPC_settings.nx;
nu = MPC_settings.nu;

Aeq = gen_aeq(Ai, Bi, N);
beq = gen_beq(Ai, xi, N);

z0 = [xi;zeros((N-1)*nx + N*nu,1)];
 
% if nargin < 5
%     z = quadprog(H, [], [], [], Aeq, beq, lb, ub, z0);
% else
%     z = quadprog(H, [], [], [], Aeq, beq, lb, ub, z0, options);
% end
% u = z(nx*N+1 : nx*N + nu);

z_sp = repmat([x_sp;zeros(3,1);zeros(nu,1)], [N,1]);

fun = @(z) 0.5*(z_sp - z)'*H*(z_sp - z);

%if nargin < 5
    z = fmincon(fun,z0,[],[],Aeq,beq,lb,ub,[],options);
%else
%    z = fmincon(fun, z0, [], [], Aeq, beq, lb, ub, [], options);
%end
u = z(nx*N+1 : nx*N + nu);