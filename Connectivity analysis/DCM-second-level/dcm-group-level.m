% List of open inputs
% Model Inference: Directory - cfg_files
% Model Inference: Inference method - cfg_menu
nrun = X; % enter the number of runs here
jobfile = {'/Users/cagdasertas/Desktop/script for dcm 2_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Model Inference: Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Model Inference: Inference method - cfg_menu
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
