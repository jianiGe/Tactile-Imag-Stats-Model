% 29 July 2024
% Script for re-running GLM for DCM / PPI

glm_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-stim-imag';
onset_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-stim-imag\condition_onsets';

% experiment variables
subj = [1:10];
run = [1:6];
scan_per_run =242;
nconditions = 7;

for i = subj

    % create output folder
    sub_dir = strcat(glm_dir, '\sub-', sprintf('%03d',i));
    if exist(sub_dir) == 0
        mkdir(sub_dir);
    end

    % load condition/onset file
    load(strcat(onset_dir,'\sub-', sprintf('%03d',i), '-onset-v3.mat'));

    % compile list of input scans
    func_dir = strcat('C:\Users\jiani\Documents\MATLAB\stats-dcm\data\sub-', sprintf('%03d',i));
    func_files = {};
    for j = run
        run_dir = strcat(func_dir, '\run-', sprintf('%02d',j));
        prefix = 'ds8wragf4d';
        func_files{end+1} = spm_select('FPList', run_dir, ['^' prefix '.*']);
    end
    % add scan numbers
    func_scans = {};
    for m = run
        for n = 1:scan_per_run
            func_scans{end+1} =  strcat(func_files{m}, ',', num2str(n));
        end
    end
    
    % compile batch
    %% specify SPM.mat
    clear matlabbatch;
    matlabbatch{1}.spm.stats.fmri_spec.dir = {sub_dir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    % input scans
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = func_scans';
    % specify conditions
    for c = 1:nconditions
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = conditions.names{c};
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = conditions.onsets{c};
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = conditions.durations{c};
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
    end

    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    nrun = 1;
    inputs = cell(0, nrun);
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch, inputs{:});

    %% adjust for concatenation / block effect
    scans = [242 242 242 242 242 242];
    spm_fmri_concatenate(fullfile(sub_dir, 'SPM.mat'), scans);

    %% estimate SPM.mat
    clear matlabbatch
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile(sub_dir,'SPM.mat')};
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

    spm_jobman('run', matlabbatch);

end
