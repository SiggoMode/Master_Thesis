if matches(pos_param, 'GPT')
    % Position of insertion points, lateral and medial
    system_params.cables.FD.L = [-0.030; 0.000; -0.120]; % Front deltoid lateral connection
    system_params.cables.FD.M = [0.025; -0.035; 0.020]; % Front deltoid medial connection
    
    % Original set
    %LD.L = [-0.1; 0;-0.15]; % Lateral deltoid lateral connection
    %LD.M = [0;0;0.2]; % Lateral deltoid medial connection
    
    system_params.cables.LD.L = [-0.03; 0; -0.12]; % Lateral deltoid lateral connection
    system_params.cables.LD.M = [-0.03; 0.005; 0.035]; % Lateral deltoid medial connection
    
    system_params.cables.RD.L = [-0.030; 0.000; -0.120]; % Rear deltoid lateral connection
    system_params.cables.RD.M = [-0.015; 0.040; 0.025]; % Rear deltoid medial connection
    
    %PUR.L = [-0.024; 0.012; 0.002]; % posterior upper rotator cuff lateral connection
    system_params.cables.PUR.L = [-0.002; 0.012; 0.002]; % posterior upper rotator cuff lateral connection
    system_params.cables.PUR.M = [0.120; 0.045; 0.010]; % posterior upper rotator cuff medial connection
    
    system_params.cables.PLR.L = [-0.023; 0.016; -0.003]; % posterior lower rotator cuff lateral connection
    system_params.cables.PLR.M = [-0.030; 0.050; 0]; % posterior lower rotator cuff medial connection
    
    
    %AUR.L = [-0.018; -0.014; 0.003]; % anterior upper rotator cuff lateral connection
    system_params.cables.AUR.L = [-0.002; -0.014; 0.003]; % anterior upper rotator cuff lateral connection
    system_params.cables.AUR.M = [0.120; 0.015; 0.015]; % anterior upper rotator cuff medial connection
    
    system_params.cables.ALR.L = [-0.019; -0.012; -0.004]; % anterior lower rotator cuff lateral connection
    system_params.cables.ALR.M = [0.002; 0.018; 0.003]; % anterior lower rotator cuff medial connection

elseif matches(pos_param, 'Fusion')
    
    % Position of insertion points, lateral and medial
    system_params.cables.FD.L = [-0.0172; -0.0171; -0.119]; % Front deltoid lateral connection
    system_params.cables.FD.M = [0.0288; -0.0631; 0.0172]; % Front deltoid medial connection
        
    system_params.cables.LD.L = [-0.0172; -0.0171; -0.119]; % Lateral deltoid lateral connection
    %LD.M = [-0.0038; 0.0049; 0.0632]; % Lateral deltoid medial connection
    system_params.cables.LD.M = [-0.038; 0.0049; 0.0632];
    
    system_params.cables.RD.L = [-0.0172; -0.0171; -0.119]; % Rear deltoid lateral connection
    system_params.cables.RD.M = [0.0188; 0.065; 0.0201]; % Rear deltoid medial connection
    
    %PUR.L = [-0.0083; 0.0182; -0.0015]; % posterior upper rotator cuff lateral connection
    system_params.cables.PUR.L = [-0.002; 0.0268; 0.001];
    system_params.cables.PUR.M = [0.1288; 0.0501; -0.0243]; % posterior upper rotator cuff medial connection
    
    system_params.cables.PLR.L = [-0.0083; 0.0182; -0.0015]; % posterior lower rotator cuff lateral connection
    system_params.cables.PLR.M = [0.1288; 0.0501; -0.117]; % posterior lower rotator cuff medial connection
    
    system_params.cables.AUR.L = [-0.002; -0.0268; 0.001]; % anterior upper rotator cuff lateral connection
    system_params.cables.AUR.M = [0.1288; -0.033; -0.0271]; % anterior upper rotator cuff medial connection
    
    system_params.cables.ALR.L = [-0.002; -0.0268; 0.001]; % anterior lower rotator cuff lateral connection
    system_params.cables.ALR.M = [0.1288; -0.033; -0.117]; % anterior lower rotator cuff medial connection

elseif matches(pos_param, 'Fusion2')

    % Position of insertion points, lateral and medial
    system_params.cables.FD.L = [-0.0172; -0.0171; -0.119]; % Front deltoid lateral connection
    system_params.cables.FD.M = [-7.052; -63.84; 32.91]/1000; % Front deltoid medial connection
        
    system_params.cables.LD.L = [-0.0172; -0.0171; -0.119]; % Lateral deltoid lateral connection
    %LD.M = [-0.0038; 0.0049; 0.0632]; % Lateral deltoid medial connection
    system_params.cables.LD.M = [-35.052; 6.204; 74.98]/1000;
    
    system_params.cables.RD.L = [-0.0172; -0.0171; -0.119]; % Rear deltoid lateral connection
    system_params.cables.RD.M = [-7.052; 68.364; 30.149]/1000; % Rear deltoid medial connection
    
    %PUR.L = [-0.0083; 0.0182; -0.0015]; % posterior upper rotator cuff lateral connection
    system_params.cables.PUR.L = [-0.002; 0.0268; 0.001];
    system_params.cables.PUR.M = [0.1288; 0.0501; -0.0243]; % posterior upper rotator cuff medial connection
    
    system_params.cables.PLR.L = [-0.0083; 0.0182; -0.0015]; % posterior lower rotator cuff lateral connection
    system_params.cables.PLR.M = [0.1288; 0.0501; -0.117]; % posterior lower rotator cuff medial connection
    
    system_params.cables.AUR.L = [-0.002; -0.0268; 0.001]; % anterior upper rotator cuff lateral connection
    system_params.cables.AUR.M = [0.1288; -0.033; -0.0271]; % anterior upper rotator cuff medial connection
    
    system_params.cables.ALR.L = [-0.002; -0.0268; 0.001]; % anterior lower rotator cuff lateral connection
    system_params.cables.ALR.M = [0.1288; -0.033; -0.117]; % anterior lower rotator cuff medial connection

elseif matches(pos_param, 'FinalBuild')
    %Position of insertion points, lateral and medial
    system_params.cables.FD.L = [-17.3; 0; -120.98]/1000; % Front deltoid lateral connection
    system_params.cables.FD.M = [24.2; -61.1; 54.7]/1000; % Front deltoid medial connection
        
    system_params.cables.LD.L = [-17.3; 0; -120.98]/1000; % Lateral deltoid lateral connection
    system_params.cables.LD.M = [24.2; 0; 93.07]/1000;% Lateral deltoid medial connection
    
    system_params.cables.RD.L = [-17.3; 0; -120.98]/1000; % Rear deltoid lateral connection
    system_params.cables.RD.M = [24.2; 59.14; 54.7]/1000; % Rear deltoid medial connection

    system_params.cables.PUR.L = [-31; 0; 0]/1000; % posterior upper rotator cuff lateral connection
    system_params.cables.PUR.M = [129.56; 78.8; -12]/1000; % posterior upper rotator cuff medial connection
    
    system_params.cables.PLR.L = [-31; 0; 0]/1000; % posterior lower rotator cuff lateral connection
    system_params.cables.PLR.M = [130.8; 78.8; -108.8]; % posterior lower rotator cuff medial connection
    
    system_params.cables.AUR.L = [-31; 0; 0]/1000; % anterior upper rotator cuff lateral connection
    system_params.cables.AUR.M = [129.56; -69.55; -12.89]/1000; % anterior upper rotator cuff medial connection
    
    system_params.cables.ALR.L = [-31; 0; 0]/1000; % anterior lower rotator cuff lateral connection
    system_params.cables.ALR.M = [129.56; -69.55; -109.69]/1000; % anterior lower rotator cuff medial connection

end

