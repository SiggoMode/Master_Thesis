%% Test diag_repeat
A = [1 0; 0 2];
N = 5;
diag_repeat(A,N)

%% Test gen_aeq
A = [1 .5; 0 20];
B = [3 0; 0 4];
N = 3;
gen_aeq(A,B,N)

%% Test gen_beq
A = [1 0; 0 1];
x0 = [1; 1];
N = 3;
gen_beq(A, x0, N)

%% Test MPC
A = eye(6);
B = [eye(6), ones(6,1)];
x0 = zeros(6,1);
MPC_tuning;
u = MPC(A, B, x0, MPC_settings);