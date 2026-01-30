function plot_func(data, t, title, legendNames)
    hfig = figure("Name", title, "NumberTitle", "off");

    hold on;
    numSignals = width(data);

    % Correct data for first six timesteps
    data(1:6,:)=0;

    hasLegend = (nargin >= 4) && ~isempty(legendNames);

    for i = 1:numSignals
        if hasLegend
            plot(t,data(:,i), 'DisplayName', legendNames(i), 'LineWidth', 2.5);
        else
            plot(t,data(:,i), 'LineWidth', 2.5);
        end
    end

    % Custom ylim
    %ylim([-70, 110]);

    % Configure figure setup
    xlabel('time $t$ (s)')
    if hasLegend
        legend('Location','best')
        ylabel('Angles in degrees')
    else
        ylabel('Force (N)')
    end
    grid on;
    hold off;
    picturewidth = 20;
    hw_ratio = 0.65; % Adjustable
    set(findall(hfig,'-property','FontSize'),'FontSize',17) % Fontsize
    set(findall(hfig,'-property','Box'),'Box','off') % optional
    set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') 
    set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
    set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
    fname  = append('experiments/theta60degrees/', title); % file name and save location
    %fname  = append('experiments/phi60degrees/', title); % file name and save location
    %fname  = append('experiments/psisin0_1hz/', title); % file name and save location
    pos = get(hfig, 'Position');
    set(hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'Papersize', [pos(3), pos(4)]);
    print(hfig, fname, '-dpdf', '-vector', '-fillpage');
end

% Front deltoid
plot_func(out.force_FD.Data, out.tout, 'Force front deltoid');

% Lateral deltoid
plot_func(out.force_LD.Data, out.tout, 'Force lateral deltoid');

% Rear deltoid
plot_func(out.force_RD.Data, out.tout, 'Force rear deltoid');

% Posterior upper rotator
plot_func(out.force_PUR.Data, out.tout, 'Force posterior upper rotator');

% Posterior lower rotator
plot_func(out.force_PLR.Data, out.tout, 'Force posterior lower rotator');

% Anterior upper rotator
plot_func(out.force_AUR.Data, out.tout, 'Force anterior upper rotator');

% Anterior lower rotator
plot_func(out.force_ALR.Data, out.tout, 'Force anterior lower rotator');

% Plot states
plot_func(out.States.Data(:,:)'*180/pi, out.tout, 'Angles', ['A', 'B', 'C']);
