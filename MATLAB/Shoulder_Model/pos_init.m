if matches(pos_param, 'GPT')
    % Position of insertion points, lateral and medial
    FD.L = [-0.030; 0.000; -0.120]; % Front deltoid lateral connection
    FD.M = [0.025; -0.035; 0.020]; % Front deltoid medial connection
    
    % Original set
    %LD.L = [-0.1; 0;-0.15]; % Lateral deltoid lateral connection
    %LD.M = [0;0;0.2]; % Lateral deltoid medial connection
    
    LD.L = [-0.03; 0; -0.12]; % Lateral deltoid lateral connection
    LD.M = [-0.03; 0.005; 0.035]; % Lateral deltoid medial connection
    
    RD.L = [-0.030; 0.000; -0.120]; % Rear deltoid lateral connection
    RD.M = [-0.015; 0.040; 0.025]; % Rear deltoid medial connection
    
    %PUR.L = [-0.024; 0.012; 0.002]; % posterior upper rotator cuff lateral connection
    PUR.L = [-0.002; 0.012; 0.002]; % posterior upper rotator cuff lateral connection
    PUR.M = [0.120; 0.045; 0.010]; % posterior upper rotator cuff medial connection
    
    PLR.L = [-0.023; 0.016; -0.003]; % posterior lower rotator cuff lateral connection
    PLR.M = [-0.030; 0.050; 0]; % posterior lower rotator cuff medial connection
    
    
    %AUR.L = [-0.018; -0.014; 0.003]; % anterior upper rotator cuff lateral connection
    AUR.L = [-0.002; -0.014; 0.003]; % anterior upper rotator cuff lateral connection
    AUR.M = [0.120; 0.015; 0.015]; % anterior upper rotator cuff medial connection
    
    ALR.L = [-0.019; -0.012; -0.004]; % anterior lower rotator cuff lateral connection
    ALR.M = [0.002; 0.018; 0.003]; % anterior lower rotator cuff medial connection

elseif matches(pos_param, 'Fusion')
    
    % Position of insertion points, lateral and medial
    FD.L = [-0.0172; -0.0171; -0.119]; % Front deltoid lateral connection
    FD.M = [0.0288; -0.0631; 0.0172]; % Front deltoid medial connection
        
    LD.L = [-0.0172; -0.0171; -0.119]; % Lateral deltoid lateral connection
    %LD.M = [-0.0038; 0.0049; 0.0632]; % Lateral deltoid medial connection
    LD.M = [-0.038; 0.0049; 0.0632];
    
    RD.L = [-0.0172; -0.0171; -0.119]; % Rear deltoid lateral connection
    RD.M = [0.0188; 0.065; 0.0201]; % Rear deltoid medial connection
    
    %PUR.L = [-0.0083; 0.0182; -0.0015]; % posterior upper rotator cuff lateral connection
    PUR.L = [-0.002; 0.0268; 0.001];
    PUR.M = [0.1288; 0.0501; -0.0243]; % posterior upper rotator cuff medial connection
    
    PLR.L = [-0.0083; 0.0182; -0.0015]; % posterior lower rotator cuff lateral connection
    PLR.M = [0.1288; 0.0501; -0.117]; % posterior lower rotator cuff medial connection
    
    AUR.L = [-0.002; -0.0268; 0.001]; % anterior upper rotator cuff lateral connection
    AUR.M = [0.1288; -0.033; -0.0271]; % anterior upper rotator cuff medial connection
    
    ALR.L = [-0.002; -0.0268; 0.001]; % anterior lower rotator cuff lateral connection
    ALR.M = [0.1288; -0.033; -0.117]; % anterior lower rotator cuff medial connection
end
