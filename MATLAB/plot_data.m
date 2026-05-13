function plot_func(data, t, titleStr, y_label, x_label, legendNames)

    hfig = figure("Name", titleStr, "NumberTitle", "off");
    hold on;

    numSignals = size(data, 2);

    hasLegend = (nargin >= 6) && ~isempty(legendNames);

    for i = 1:numSignals
        if hasLegend
            plot(t, data(:,i), ...
                'DisplayName', legendNames{i}, ...
                'LineWidth', 2.5);
        else
            plot(t, data(:,i), 'LineWidth', 2.5);
        end
    end

    xlabel(x_label);
    ylabel(y_label);

    xlim([0, t(end)]);

    if hasLegend
        lgd = legend('Location','best');
        %lgd = legend('Location','ne');
        lgd.TextColor = 'k';
    end

    grid on;
    hold off;

    % Figure formatting
    picturewidth = 21;
    hw_ratio = 0.65;

    set(findall(hfig,'-property','FontSize'),'FontSize',17)
    set(findall(hfig,'-property','Box'),'Box','off')
    set(findall(hfig,'-property','Interpreter'),'Interpreter','latex')
    set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')

    set(hfig,'Units','centimeters',...
        'Position',[3 3 picturewidth hw_ratio*picturewidth])
    set(hfig, 'Color', 'w');
    set(gca,  'Color', 'none');   
    set(gca, 'XColor', 'k', 'YColor', 'k');
    set(findall(hfig,'Type','text'),'Color','k');

    fname = append('Gathered_Data/LinSysTest/', titleStr);
    %fname = append('Gathered_Data/PhysicalActuatorTest/ALR/', titleStr);

    pos = get(hfig, 'Position');
    set(hfig, 'PaperPositionMode', 'Auto', ...
        'PaperUnits', 'centimeters', ...
        'Papersize', [pos(3), pos(4)]);

    %print(hfig, fname, '-dpdf', '-vector', '-fillpage');
    
    exportgraphics(hfig, fname + ".pdf", ...
        'ContentType','vector', ...
        'BackgroundColor','white');
end

% Plot states
t_plot = out.tout(:);
%t_plot = out.TOF_meas.Time;
t1_s = 17; % seconds
t2_s = 22.7; % seconds
dt_plot = t_plot(3) - t_plot(2);

t1_n = round(t1_s/dt_plot);
t2_n = round(t2_s/dt_plot);

% StateData = squeeze(permute(out.States.Data, [3 1 2]));
% EulerAngles = StateData(:,1:3)*180/pi;
% TensionData = squeeze(permute(out.cable_tension.Data, [3 1 2]));
% 
% plot_func(EulerAngles, t_plot, 'DummyPath60DAbduction_a0.06', 'Angles in degrees', 'Time(s)', {'Extension','Abduction','Int. rotation'});
% 
% plot_func(TensionData, t_plot, 'TensionDummyPath60DAbduction_a0.06', 'Tension (N)', 'Time(s)', {'FD','LD','RD','PUR','PLR','AUR','ALR'});
% 
% TOF_measured = squeeze(permute(out.TOF_meas.data, [3 1 2]));
% t_plot = t_plot(1:t2_n-t1_n+1);
% TOF_measured = TOF_measured(t1_n:t2_n,:);
% plot_func(TOF_measured, t_plot, 'ActuatorLoop_60mm-90mm_3', 'Position (mm)', 'Time(s)', {'Unfiltered', 'Filtered'});

x = squeeze(permute(out.quaternion_all_states.Data, [3 1 2]));
linSys = squeeze(permute(out.Linearized_system_results.Data, [3 1 2]));
linSys = linSys(:,1:7);
rk4 = squeeze(permute(out.rk4_results.Data, [3 1 2]));


plot_func(x, t_plot, 'simulated_raw', '', 'Time(s)', {'$q_{0}$', '$q_{1}$', '$q_{2}$', '$q_{3}$', '$\omega_{1}$', '$\omega_{2}$', '$\omega_{3}$'});
plot_func(linSys, t_plot, 'simulated_raw', '', 'Time(s)', {'$q_{0}$', '$q_{1}$', '$q_{2}$', '$q_{3}$', '$\omega_{1}$', '$\omega_{2}$', '$\omega_{3}$'});
plot_func(rk4, t_plot, 'simulated_raw', '', 'Time(s)', {'$q_{0}$', '$q_{1}$', '$q_{2}$', '$q_{3}$', '$\omega_{1}$', '$\omega_{2}$', '$\omega_{3}$'});