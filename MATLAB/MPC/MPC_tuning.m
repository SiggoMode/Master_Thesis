nx_mpc = nx_EKF+1; % Add affine term 
nx_mpc_euler = nx_EKF_euler+1;
nd_mpc = nd_EKF;
nx_tot = nx_mpc+nd_mpc;
nx_tot_euler = nx_mpc_euler+nd_mpc;
nu_mpc=nu_EKF;
%N = 128;                   % Time steps
N = 64;
M = 10;                   % Control horizon
q0_mpc_euler = zeros(3,1);
q0_mpc = euler2quat(q0_mpc_euler);
x0_mpc = [q0_mpc; zeros(3,1); 1]; % Initial states
z = zeros();
algorithm = 'active-set';
useAllEstimates = true;
%u0_mpc = zeros(nu_mpc,1);
u0_mpc = u0;

% Lower bounds
lbA = -pi/2;
lbB = -pi/2;
lbC = -pi/2;
lbAdot = -99999;
lbBdot = -99999;
lbCdot = -99999;
lbx_affine = -99999;
lbx = repmat([lbA;lbB;lbC;lbAdot;lbBdot;lbCdot], [N,1]);
lbx_affine = repmat([lbA;lbB;lbC;lbAdot;lbBdot;lbCdot;lbx_affine], [N,1]);
%lbu = zeros(nu_mpc*N,1);
%lbu = -ones(nu_mpc*N,1)*2500;
lbu = zeros(nu_mpc*N,1);
lb = [lbx; lbu];
lbAffine = [lbx_affine; lbu];

% Upper bounds
ubA = pi/2;
ubB = pi/2;
ubC = pi/2;
ubAdot = 99999;
ubBdot = 99999;
ubCdot = 99999;
ubxAffine = 99999;
ubx = repmat([ubA;ubB;ubC;ubAdot;ubBdot;ubCdot], [N,1]);
ubx_affine = repmat([ubA;ubB;ubC;ubAdot;ubBdot;ubCdot;ubxAffine], [N,1]);
ubu = ones(nu_mpc*N,1);
ub = [ubx; ubu];
ubAffine = [ubx_affine; ubu];

% Tune cost function
% 64 N uten demping:
% Bra for B og C: AW(20), ARW(1), IW(1), IRW(10)
% Bra for B med "hopping" ARW(4)
% Bra for A: AW(100), ARW(32), IW(1), IRW(10)

% 64N med demping:
% Bra for C: AW(20), ARW(1), IW(1), IRW(10)
% Bra for B: AW(27), ARW(6), IW(1), IRW(10)

% Bra med tension model (N = 128): 
% AW(17), ARW(8), IW(1), IRW(10)

angleWeights = 1; 
AWeight = angleWeights;
BWeight = angleWeights;
CWeight = angleWeights;
q_weight = ones(4,1)*angleWeights;
%CWeight = 20;
angelRateWeights = 1;
ARateWeight = angelRateWeights;
BRateWeight = angelRateWeights;
CRateWeight = angelRateWeights;
omega_weight = ones(3,1)*angelRateWeights;
%CRateWeight = 20;
inputWeights = 0.1;
inputRateWeights = 1;

Q = eye(nx_mpc)*100;
R = eye(nu_mpc)*1;
H = blkdiag(diag_repeat(Q,N),diag_repeat(R,N));

f = zeros(size(H,1),1);

%[custom_lb, custom_ub] = gen_constraints(lb, ub, nx, nu, N);

% Create object
MPC_settings.N = N;
MPC_settings.nx = nx_mpc;
MPC_settings.nx_euler = nx_mpc_euler;
MPC_settings.nu = nu_mpc;
MPC_settings.lb = lb;
MPC_settings.ub = ub;
MPC_settings.lb_affine = lbAffine;
MPC_settings.ub_affine = ubAffine;
MPC_settings.H = H;
MPC_settings.f = f;

% Create bus object for simulink
evalin('base', ['clear ' 'MPCBus']);
MPC_bus_info = Simulink.Bus.createObject(MPC_settings);
oldName = MPC_bus_info.busName;
busObj = evalin('base', oldName);
assignin('base', 'MPCBus', busObj);

% Remove the auto name
evalin('base', ['clear ' oldName]);

% MPC Controller object init
%MV = Manipulated variable (u), OV = OutputVariable (y) frå Cx + Du
[Ad_init,Bd_init,c] = linearize_system(x0_mpc(1:7),u0_mpc,zeros(7,1),system_params);
[Ad_init_euler,Bd_init_euler,c_euler] = linearize_system_euler(x0_mpc(1:6),u0_mpc,zeros(7,1),system_params);
Ad_init = [Ad_init c; zeros(1,size(Ad_init,1)) 0];
Bd_init = [Bd_init; zeros(1,size(Bd_init,2))];
Ad_init_euler = [Ad_init_euler c_euler; zeros(1,size(Ad_init_euler,1)) 0];
Bd_init_euler = [Bd_init_euler; zeros(1,size(Bd_init_euler,2))];

%Ad_init = eye(nx_tot) - 0.1*eye(nx_tot);
%Bd_init = eye(nx_tot, nu_mpc);
if useAllEstimates 
    Cd = [eye(nx_mpc-1), zeros(nx_mpc-1,size(Ad_init,1)-nx_mpc+1)];
    Cd_euler = [eye(nx_mpc_euler-1), zeros(nx_mpc_euler-1,size(Ad_init_euler,1)-nx_mpc_euler+1)];
    %outputWeights = [AWeight, BWeight, CWeight, ARateWeight, BRateWeight, CRateWeight];
    outputWeights = [q_weight', omega_weight'];
    outputWeights_euler = [AWeight, BWeight, CWeight, ARateWeight, BRateWeight, CRateWeight];
else
    Cd = [eye(3), zeros(3,size(Ad_init,1)-3)];
    outputWeights = ones(1,3)*100;
end
Dd = zeros(size(Cd,1), size(Bd_init,2));
Dd_euler = zeros(size(Cd_euler,1), size(Bd_init_euler,2));
model_initial = ss(Ad_init, Bd_init, Cd, Dd, dt);
model_initial_euler = ss(Ad_init_euler, Bd_init_euler, Cd_euler, Dd_euler, dt);

%model_init = generate_random_system(nx_mpc, nu_mpc, dt);

MPC_controller = mpc(model_initial, dt, N, M);
MPC_controller.Weights.OutputVariables = outputWeights;
MPC_controller.Weights.ManipulatedVariables = ones(1,nu_mpc)*inputWeights;
MPC_controller.Weights.ManipulatedVariablesRate = ones(1,nu_mpc)*inputRateWeights;

MPC_controller_euler = mpc(model_initial_euler, dt, N, M);
MPC_controller_euler.Weights.OutputVariables = outputWeights_euler;
MPC_controller_euler.Weights.ManipulatedVariables = ones(1,nu_mpc)*inputWeights;
MPC_controller_euler.Weights.ManipulatedVariablesRate = ones(1,nu_mpc)*inputRateWeights;


for i = 1:nu_mpc
    MPC_controller.MV(i).Min = lbu(i);
    MPC_controller.MV(i).Max = ubu(i);
    MPC_controller_euler.MV(i).Min = lbu(i);
    MPC_controller_euler.MV(i).Max = ubu(i);
end

for i = 1:3
    MPC_controller.OV(i).Min = lbx(i);
    MPC_controller.OV(i).Max = ubx(i);
    MPC_controller_euler.OV(i).Min = lbx(i);
    MPC_controller_euler.OV(i).Max = ubx(i);
end
setEstimator(MPC_controller,'custom')
setEstimator(MPC_controller_euler,'custom')
setoutdist(MPC_controller, 'model', tf(zeros(7,1))); 
setoutdist(MPC_controller_euler, 'model', tf(zeros(6,1))); 
MPC_controller.Model.Nominal.U = u0_mpc;
MPC_controller_euler.Model.Nominal.U = u0_mpc;

% Non linear MPC:
% NL_mpc = nlmpc(nx_mpc, 6, nu_mpc);
% NL_mpc.Model.StateFcn = @(x,u) system_model_continous(x,u,system_params);
% NL_mpc.Jacobian.StateFcn = @(x,u) linearize(x,u,system_params);
% NL_mpc.Model.OutputFcn = @(x) Cd*x;
% NL_mpc.Weights.OutputVariables = outputWeights;
% NL_mpc.Weights.ManipulatedVariables = ones(1,nu_mpc)*inputWeights;
% NL_mpc.Weights.ManipulatedVariablesRate = ones(1,nu_mpc)*inputRateWeights;