nx_mpc = nx_EKF+1; % Add affine term 
nd_mpc = nd_EKF;
nx_tot = nx_mpc+nd_mpc;
nu_mpc=nu_EKF;
N = 128;                   % Time steps
M = 10;                   % Control horizon
x0_mpc = zeros(nx_mpc,1); % Initial states
z = zeros();
algorithm = 'active-set';
useAllEstimates = true;
u0_mpc = zeros(nu_mpc,1);

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
lbu = -ones(nu_mpc*N,1)*2500;
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
ubu = ones(nu_mpc*N,1)*2500;
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

angleWeights = 17; 
AWeight = angleWeights;
BWeight = angleWeights;
CWeight = angleWeights;
%CWeight = 20;
angelRateWeights = 8;
ARateWeight = angelRateWeights;
BRateWeight = angelRateWeights;
CRateWeight = angelRateWeights;
%CRateWeight = 20;
inputWeights = 1;
inputRateWeights = 10;

Q = eye(nx_mpc)*100;
R = eye(nu_mpc)*1;
H = blkdiag(diag_repeat(Q,N),diag_repeat(R,N));

f = zeros(size(H,1),1);

%[custom_lb, custom_ub] = gen_constraints(lb, ub, nx, nu, N);

% Create object
MPC_settings.N = N;
MPC_settings.nx = nx_mpc;
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
Ad_init = eye(nx_tot) - 0.1*eye(nx_tot);
Bd_init = eye(nx_tot, nu_mpc);
if useAllEstimates 
    Cd = [eye(nx_mpc-1), zeros(nx_mpc-1,size(Ad_init,1)-nx_mpc+1)];
    outputWeights = [AWeight, BWeight, CWeight, ARateWeight, BRateWeight, CRateWeight];
else
    Cd = [eye(3), zeros(3,size(Ad_init,1)-3)];
    outputWeights = ones(1,3)*100;
end
Dd = zeros(size(Cd,1), size(Bd_init,2));
model_initial = ss(Ad_init, Bd_init, Cd, Dd, dt);

%model_init = generate_random_system(nx_mpc, nu_mpc, dt);

MPC_controller = mpc(model_initial, dt, N, M);
MPC_controller.Weights.OutputVariables = outputWeights;
MPC_controller.Weights.ManipulatedVariables = ones(1,nu_mpc)*inputWeights;
MPC_controller.Weights.ManipulatedVariablesRate = ones(1,nu_mpc)*inputRateWeights;


for i = 1:nu_mpc
    MPC_controller.MV(i).Min = lbu(i);
    MPC_controller.MV(i).Max = ubu(i);
end

for i = 1:3
    MPC_controller.OV(i).Min = lbx(i);
    MPC_controller.OV(i).Max = ubx(i);
end
setEstimator(MPC_controller,'custom')
%distMod = getoutdist(MPC_controller);
%distMod = sminreal([distMod(1,1) distMod(1,6); 0 0; distMod(3,1) distMod(3,6); distMod(4,1) distMod(4,6);distMod(5,1) distMod(5,6);distMod(6,1) distMod(6,6)]);
%setoutdist(MPC_controller,'model',distMod)
% Assuming your MPC object is named 'mpcobj'
% Sets disturbance to zero for all output channels
setoutdist(MPC_controller, 'model', tf(zeros(6,1))); 

% Non linear MPC:
NL_mpc = nlmpc(nx_mpc, 6, nu_mpc);
NL_mpc.Model.StateFcn = @(x,u) system_model_continous(x,u,system_params);
NL_mpc.Jacobian.StateFcn = @(x,u) linearize(x,u,system_params);
NL_mpc.Model.OutputFcn = @(x) Cd*x;
NL_mpc.Weights.OutputVariables = outputWeights;
NL_mpc.Weights.ManipulatedVariables = ones(1,nu_mpc)*inputWeights;
NL_mpc.Weights.ManipulatedVariablesRate = ones(1,nu_mpc)*inputRateWeights;