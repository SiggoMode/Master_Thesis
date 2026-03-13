% Created by ChatGPT
%% === Inputs (replace these with your Simulink outputs) ===
% If you exported as 'angles' (Nx3) and 'tout' from Simulink:
data = out.States;

t_sim = out.tout;                    % Nx1
theta = data.Data(1,1,:);         % radians (θ about x)
phi   = data.Data(2,1,:);         % radians (φ about y)
psi   = data.Data(3,1,:);         % radians (ψ about z)

% If your angles are in degrees, set this true:
angles_are_degrees = false;

% Choose rotation convention:
% 'intrinsicXYZ'  -> rotate about body x, then body y, then body z (most common for "x, y, z in that order")
% 'extrinsicXYZ'  -> rotate about world X, then world Y, then world Z
%order = 'intrinsicXYZ';
order = 'extrinsicXYZ';

% Axis length and playback speed
axis_len = 1.0;
realtime = true;  % true = attempt real-time playback using t spacing; false = max speed

%% === Prep ===
if angles_are_degrees
    theta = deg2rad(theta); phi = deg2rad(phi); psi = deg2rad(psi);
end

N = numel(t_sim);
assert(all([numel(theta), numel(phi), numel(psi)] == N), 'Mismatch sizes.');

% Basic figure setup
figure('Color','w'); axis equal vis3d
axis(axis_len*1.5*[-1 1 -1 1 -1 1]);
grid on; box on
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Body frame relative to world');

% Draw world frame (fixed)
hold on
plot3([0 axis_len],[0 0],[0 0],'k-','LineWidth',1); % Xw
plot3([0 0],[0 axis_len],[0 0],'k-','LineWidth',1); % Yw
plot3([0 0],[0 0],[0 axis_len],'k-','LineWidth',1); % Zw
text(axis_len,0,0,' X_w');
text(0,axis_len,0,' Y_w');
text(0,0,axis_len,' Z_w');

% Body axes (will update)
bx = plot3(NaN,NaN,NaN,'r-','LineWidth',3); % body +X
by = plot3(NaN,NaN,NaN,'g-','LineWidth',3); % body +Y
bz = plot3(NaN,NaN,NaN,'b-','LineWidth',3); % body +Z
% NEW: negative Z axis
bz_neg = plot3(NaN,NaN,NaN,'b--','LineWidth',2); % body -Z (dashed)

% Color
%set(bx,'Color',[0.7 0.7 0.7]);
%set(by,'Color',[0.7 0.7 0.7]);
%set(bz,'Color',[0.7 0.7 0.7]);

% Tip markers (optional)
bx_tip = plot3(NaN,NaN,NaN,'ro','MarkerFaceColor','r');
by_tip = plot3(NaN,NaN,NaN,'go','MarkerFaceColor','g');
bz_tip = plot3(NaN,NaN,NaN,'bo','MarkerFaceColor','b');
bz_neg_tip = plot3(NaN,NaN,NaN,'bo','MarkerFaceColor','none','MarkerEdgeColor','b');

% Rotation helpers
Rx = @(a) [1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a)];
Ry = @(a) [cos(a) 0 sin(a); 0 1 0; -sin(a) 0 cos(a)];
Rz = @(a) [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];

switch order
    case 'intrinsicXYZ'
        composeR = @(th,ph,ps) Rz(ps)*Ry(ph)*Rx(th);
    case 'extrinsicXYZ'
        composeR = @(th,ph,ps) Rx(th)*Ry(ph)*Rz(ps);
    otherwise
        error('Unknown order');
end

% Body unit vectors
ex = [1;0;0]; ey = [0;1;0]; ez = [0;0;1];

% === Add legend to identify the body axes ===
legend([bx, by, bz, bz_neg], ...
       {'Body +X', 'Body +Y', 'Body +Z', 'Body -Z'}, ...
       'Location', 'northeastoutside', ...
       'Box', 'on', ...
       'FontSize', 10);


% Playback
tic
for k = 1:N
    R = composeR(theta(k),phi(k),psi(k));
    Ex = R*ex; Ey = R*ey; Ez = R*ez; % body axes in world frame

    % Plot positive axes
    set(bx,'XData',[0 axis_len*Ex(1)],'YData',[0 axis_len*Ex(2)],'ZData',[0 axis_len*Ex(3)]);
    set(by,'XData',[0 axis_len*Ey(1)],'YData',[0 axis_len*Ey(2)],'ZData',[0 axis_len*Ey(3)]);
    set(bz,'XData',[0 axis_len*Ez(1)],'YData',[0 axis_len*Ez(2)],'ZData',[0 axis_len*Ez(3)]);
    % Plot negative Z axis (new)
    set(bz_neg,'XData',[0 -axis_len*Ez(1)],'YData',[0 -axis_len*Ez(2)],'ZData',[0 -axis_len*Ez(3)]);

    % Tip markers
    set(bx_tip,'XData',axis_len*Ex(1),'YData',axis_len*Ex(2),'ZData',axis_len*Ex(3));
    set(by_tip,'XData',axis_len*Ey(1),'YData',axis_len*Ey(2),'ZData',axis_len*Ey(3));
    set(bz_tip,'XData',axis_len*Ez(1),'YData',axis_len*Ez(2),'ZData',axis_len*Ez(3));
    set(bz_neg_tip,'XData',-axis_len*Ez(1),'YData',-axis_len*Ez(2),'ZData',-axis_len*Ez(3));

    title(sprintf('Body frame (t = %.3f s)', t(k)));
    drawnow limitrate

    if realtime && k < N
        pause(max(0, t_sim(k+1)-t_sim(k) - toc)); % sync to simulation time
        tic
    end
end