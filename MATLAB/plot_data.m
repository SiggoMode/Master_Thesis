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

    fname = append('Gathered_Data/post_actuator_model/FusionPositions/K=220k_c=5k/', titleStr);

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
t_plot = out.tout(:);  % ensure column

StateData = squeeze(permute(out.States.Data, [3 1 2]));
EulerAngles = StateData(:,1:3)*180/pi;
TensionData = squeeze(permute(out.cable_tension.Data, [3 1 2]));

plot_func(EulerAngles, t_plot, 'DummyPath60DAbduction_a0.06', 'Angles in degrees', 'Time(s)', {'Extension','Abduction','Int. rotation'});

%plot_func(TensionData, t_plot, 'TensionDummyPath60DAbduction_a0.06', 'Tension (N)', 'Time', {'FD','LD','RD','PUR','PLR','AUR','ALR'});
