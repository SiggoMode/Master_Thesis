nx=6;
nu=7;
N = 10;                 % Time steps
x0 = zeros(nx,1);       % Initial states
z = zeros();
options = optimoptions('quadprog', 'Algorithm', 'active-set');

% Lower bounds
lbx = zeros(nx*N,1);
lbu = zeros(nu*N,1);
lb = [lbx; lbu];

% Upper bounds
ubx = ones(nx*N,1);
ubu = ones(nu*N,1);
ub = [ubx; ubu];

% Tune cost function
Q = eye(nx)*1.5;
R = eye(nu)*3;
H = blkdiag(diag_repeat(Q,N),diag_repeat(R,N));

f = zeros(size(H,1),1);

% Create object
MPC_settings.N = N;
MPC_settings.nx = nx;
MPC_settings.nu = nu;
MPC_settings.lb = lb;
MPC_settings.ub = ub;
MPC_settings.H = H;
MPC_settings.f = f;
MPC_settings.options = options;







