nx_mpc = nx_EKF+1; % Add affine term 
nd_mpc = nd_EKF;
nx_tot = nx_mpc+nd_mpc;
nu_mpc=nu_EKF;
N = 64;                   % Time steps
M = 20;                    % Control horizon
x0_mpc = zeros(nx_mpc,1); % Initial states
z = zeros();
algorithm = 'active-set';
useAllEstimates = true;

% Lower bounds
lbA = -0.1;
lbB = -pi/2;
lbC = -pi/2;
lbAdot = -99999;
lbBdot = -99999;
lbCdot = -99999;
lbx = repmat([lbA;lbB;lbC;lbAdot;lbBdot;lbCdot], [N,1]);
lbu = zeros(nu_mpc*N,1);
lb = [lbx; lbu];

% Upper bounds
ubA = pi/2;
ubB = pi/2;
ubC = pi/2;
ubAdot = 99999;
ubBdot = 99999;
ubCdot = 99999;
ubx = repmat([ubA;ubB;ubC;ubAdot;ubBdot;ubCdot], [N,1]);
ubu = ones(nu_mpc*N,1)*2500;
ub = [ubx; ubu];

% Tune cost function
angleWeights = 100;
angelRateWeights = 100;

Q = eye(nx_mpc)*100;
R = eye(nu_mpc)*1;
H = blkdiag(diag_repeat(Q,N),diag_repeat(R,N));

f = zeros(size(H,1),1);

% Create object
MPC_settings.N = N;
MPC_settings.nx = nx_mpc;
MPC_settings.nu = nu_mpc;
MPC_settings.lb = lb;
MPC_settings.ub = ub;
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
    outputWeights = [ones(1,3)*angleWeights, ones(1,3)*angelRateWeights];
else
    Cd = [eye(3), zeros(3,size(Ad_init,1)-3)];
    outputWeights = ones(1,3)*100;
end
Dd = zeros(size(Cd,1), size(Bd_init,2));
model_init = ss(Ad_init, Bd_init, Cd, Dd, dt);

%model_init = generate_random_system(nx_mpc, nu_mpc, dt);

MPC_controller = mpc(model_init, dt, N, M);
MPC_controller.Weights.OutputVariables = outputWeights;
MPC_controller.Weights.ManipulatedVariables = [ones(1,nu_mpc)];
MPC_controller.Weights.ManipulatedVariablesRate = [ones(1,nu_mpc)];

for i = 1:nu_mpc
    MPC_controller.MV(i).Min = lbu(i);
    MPC_controller.MV(i).Max = ubu(i);
end

for i = 1:3
    MPC_controller.OV(i).Min = lbx(i);
    MPC_controller.OV(i).Max = ubx(i);
end
%setoutdist(MPC_controller,'integrators');
setEstimator(MPC_controller,'custom')
%MPC_controller.Model.Plant = minreal(MPC_controller.Model.Plant);
