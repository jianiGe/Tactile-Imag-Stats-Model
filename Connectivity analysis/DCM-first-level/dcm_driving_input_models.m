% July 29 2024
% Specify and estimate driving inputs models (C-matrix) for first-level DCM
% 4 alternative models with fixed A-matrix and null B-matrix

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

% A-matrix: endogenous connectivity--BA2 with two-way connection with IPL and IFG 
a = ones(nregions,nregions);
a(2,3) = 0;
a(3,2) = 0;

% B-matrix: disabled; no modulatory effect on connectivity in the present model space
b = zeros(nregions,nregions,nconditions);

% C-matrix: driving input, 5 alternative models
c = zeros(nregions, nconditions, 4);

% Model 1: ST -> BA2; IM - None
c(ba2, STIM, 1) = 1;

% Model 2: ST -> BA2; IM -> BA2
c(ba2, STIM, 2) = 1;
c(ba2, IMAG, 2) = 1;

% Model 3: ST -> BA2; IM -> IFG
c(ba2, STIM, 3) = 1;
c(ifg, IMAG, 3) = 1;

% Model 4: ST -> BA2; IM -> BA2 & IFG
c(ba2, STIM, 4) = 1;
c(ba2, IMAG, 4) = 1;
c(ifg, IMAG, 4) = 1;

% D-matrix (disabled)
d = zeros(nregions,nregions,0);

%% Specify DCM (one set of models per subject)

nsub = 10;
nmodels = 4;
dcm_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\dcm-driving-input';

for subject = 1:nsub %
    
    output_dir = strcat(dcm_dir, '\', sprintf('sub-%03d',subject));
    if exist(output_dir) == 0
        mkdir(output_dir);
    else
        disp('subject dcm-input-model folder alreasy exists');
    end
    
    % Load SPM
    glm_dir = strcat('C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-stim-imag\', sprintf('sub-%03d',subject));
    SPM     = load(fullfile(glm_dir, 'SPM.mat'));
    SPM     = SPM.SPM;    
    
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
    
    % Conditions from the GLM to be included
    include = [1 1 0 0 0 0 0]';

    % Specify each model    
    for m = 1:nmodels 
        s = struct();
        s.name       = strcat('input_m',num2str(m));
        s.u          = include;                 % Conditions
        s.delays     = repmat(TR/2,1,nregions);   % Slice timing for each region
        s.TE         = TE;
        s.nonlinear  = false;
        s.two_state  = false;
        s.stochastic = false;
        s.centre     = false;
        s.induced    = 0;
        s.a          = a;
        s.b          = b;
        s.c          = c(:,:,m);
        s.d          = d;

        DCM = spm_dcm_specify(SPM,xY,s);
    end
end


%% Estimate DCMs

for i = 1:10
    
    sub_dir = strcat(dcm_dir, '\', sprintf('sub-%03d',i));
    
    cd(sub_dir);
    
    files = dir(sub_dir);
    for j = 1:length(files)
        if contains(files(j).name, 'DCM')
            spm_dcm_estimate(files(j).name);
        end
    end
    
end
