nx=6;
nu=7;

% Lower bounds
lbx = zeros(nx,1);
lbu = zeros(nu,1);
lb = [lbx; lbu];

% Upper bounds
ubx = ones(nx,1);
ubu = ones(nu,1);
ub = [ubx; ubu];

% Tune cost function
Q = eye(nx);
R = eye(nu);
H = blkdiag(diag_repeat(Q,N),diag_repeat(R,N)); % Generate large H 

f = zeros(ndmis(H),1);




N = 10;                 % Time steps
x0 = zeros(nx,1);        % Initial states
z = zeros();