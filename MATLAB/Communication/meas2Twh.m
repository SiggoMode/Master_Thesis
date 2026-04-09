function [Twhs, no_valid_ids] = meas2Twh(IDs, rvecs, tvecs, camera, T_topwc, T_sidewc, aruco_markers)
    %Twhs = zeros(4, 4*length(IDs));
    Twhs = [];

    fields = fieldnames(aruco_markers);
    
    for i = 1:length(IDs)
        Tmh = [];
        target = "id"+IDs(i);
        %Tmh = zeros(4,4);

        %Tmh = aruco_markers.(id).Tmh; % Doesnt work in simulink
        % Have to make nested lookup 
        for j = 1:numel(fields)
            if matches(fields{j}, target)
                Tmh = aruco_markers.(fields{j}).Tmh;
            end
        end
        
        if isempty(Tmh)
            continue
        else
            if matches(camera, 'TopCam')
                Twc = T_topwc;
            elseif matches(camera, 'SideCam')
                Twc = T_sidewc;
            else
                Twc = zeros(4,4);
            end
    
            R = rodrigues(rvecs(:,i));
            t = tvecs(:,i);
            Tcm = T_gen(R,t);
    
            Twh = Twc * Tcm * Tmh;
            Twhs = [Twhs, Twh];
            %Twhs(1:4, 4*i-3:4*i) = Twh;
        end
    end
    no_valid_ids = isempty(Twhs);
end