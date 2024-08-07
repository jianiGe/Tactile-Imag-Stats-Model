% July 29 2024
% Specify and estimate modulation models (B-matrix) for first-level DCM
% 6 alternative models with forward or backward (or both) connections as
% targets of modulation

% experimental variables
TR = 2;   % Repetition time (secs)
TE = 0.04;  % Echo time (secs)

nregions    = 3; 
nconditions = 2;

% condition index
STIM=1; IMAG=2;

% VOI index
ba2=1; ipl=2; ifg=3;

%% Specify DCM matrices

% A-matrix: endogenous connectivity--BA2 with twoway connection with IPL and IFG 
a = ones(nregions,nregions);
a(2,3) = 0;
a(3,2) = 0;

% C-matrix: driving input; mostly likely option from the previous BMS
c = zeros(nregions, nconditions);
c(ba2, STIM) = 1;
c(ba2, IMAG) = 1;
c(ifg, IMAG) = 1;

% B-matrix: modulatory input on connectivity
% two possible effects of STIM (forward or forward&backward)
stim_input = {};
stim_input{1,1} = [0 0 0; 
                   1 0 0;
                   1 0 0];
stim_input{2,1} = [0 1 1;
                   1 0 0;
                   1 0 0];
stim_input{1,2} = 'stim-f';
stim_input{2,2} = 'stim-fb';

% three possible effects of IMAG (forward, backward,
% forward&backward)
imag_input = {};
imag_input{1,1} = [0 0 0; 
                   1 0 0;
                   1 0 0];
imag_input{2,1} = [0 1 1;
                   0 0 0;
                   0 0 0];
imag_input{3,1} = [0 1 1;
                   1 0 0;
                   1 0 0];
imag_input{1,2} = 'imag-f';
imag_input{2,2} = 'imag-b';
imag_input{3,2} = 'imag-fb';

% D-matrix (disabled)
d = zeros(nregions,nregions,0);


%% Specify DCM struct

nsub = 10;
dcm_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\dcm-modulation';

for subject = 1:nsub %
    
    output_dir = strcat(dcm_dir, '\', sprintf('sub-%03d',subject));
    if exist(output_dir) == 0
        mkdir(output_dir);
    else
        disp('subject dcm-modulation folder alreasy exists');
    end
    
    % Load SPM
    glm_dir = strcat('C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-stim-imag\', sprintf('sub-%03d',subject));
    SPM = load(fullfile(glm_dir, 'SPM.mat'));
    SPM = SPM.SPM;
    
    % Load ROIs
    f = {strcat(glm_dir, '\VOI_BA2_1.mat');
        strcat(glm_dir, '\VOI_IPL_1.mat');
        strcat(glm_dir, '\VOI_IFG_1.mat')};
          
    for r = 1:length(f)
        XY = load(f{r});
        xY(r) = XY.xY;
    end
    
    % Move to output directory
    cd(output_dir);
    
    % conditions from the GLM to be included
    include = [1 1 0 0 0 0 0]';
        
    % specify 2 x 3 models
    for i = 1: length(stim_input)

        for j = 1 : length(imag_input)
                
            %compile b matrix
            b = zeros(nregions, nregions, nconditions);
            b(:, :, STIM) = stim_input{i, 1};
            b(:, :, IMAG) = imag_input{j, 1};
            
            %compile dcm structure
            s = struct();
            s.name = strcat(stim_input{i,2}, '_', imag_input{j,2}); %e.g. stim-f_imag-fb
            s.u  = include;                
            s.delays = repmat(TR/2,1,nregions); 
            s.TE = TE;
            s.nonlinear = false;
            s.two_state = false;
            s.stochastic = false;
            s.centre = false;
            s.induced = 0;
            s.a = a;
            s.b = b;
            s.c = c;
            s.d = d;
            DCM = spm_dcm_specify(SPM,xY,s);
        end
    end

end

%% Estimate DCMs

dcm_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\dcm-modulation';

for i = 6:10
    
    sub_dir = strcat(dcm_dir, '\', sprintf('sub-%03d',i));
    
    cd(sub_dir);
    
    files = dir(sub_dir);
    for j = 1:length(files)
        if contains(files(j).name, 'DCM')
            spm_dcm_estimate(files(j).name);
        end
    end
    
end
