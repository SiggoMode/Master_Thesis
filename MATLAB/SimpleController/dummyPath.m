% Set in degrees
angleA_old = 0;
angleB_old = 0;
angleC_old = 0;

angleA_new = 60;
angleB_new = 0;
angleC_new = 0;

a = 1/2; % 1 degree per 2 timesteps

q = [angleA_old; angleB_old; angleC_old];
qs = [angleA_new; angleB_new; angleC_new];

qs_path = dummySlopes(qs, q, a, system_params);

% add padding
pad = length(t) - length(qs_path);
qs_path = [qs_path, repmat(qs,1,pad)];

% Convert to radians and calculate u:
qs_path = qs_path * pi/180;
u_dp = zeros(length(qs_path),7);
for i = 1:length(qs_path)
    u_dp(i,:) = u0_calc(qs_path(:,i), system_params);
end

% make timeseries
u_dp_ts = timeseries(u_dp, t);



%x_s(:,1) = angle*pi/180 * ones(length(t), 1); % N×nx matrix
%x_s(600:end,2) = (angle+10)*pi/180 * ones(length(600:size(t,2)), 1); % N×nx matrix
%x_s(900:end,2) = (angle+20)*pi/180 * ones(length(900:size(t,2)), 1); % N×nx matrix
%x_s(800:end,2) = (angle+15)*pi/180 * ones(length(800:size(t,2)), 1); % N×nx matrix
%x_s(1200:end,2) = (angle+20)*pi/180 * ones(length(1200:size(t,2)), 1); % N×nx matrix
%x_s(:,3) = angle*pi/180 * sin((2*pi/Tau)*t);
%