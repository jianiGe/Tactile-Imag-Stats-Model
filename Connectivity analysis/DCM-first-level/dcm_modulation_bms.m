% 30 July 2024
% Script for Bayesian model selection for modulatory effect models
% at subject-level

nsub = [5:5]; %single subject
dcm_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\dcm-modulation';
output_dir = fullfile(dcm_dir,sprintf('BMS-sub-%03d',nsub));
if exist(output_dir) == 0
        mkdir(output_dir);
end
input_model_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\dcm-driving-input';

% compile matlabbatch
matlabbatch = {};
matlabbatch{1}.spm.dcm.bms.inference.dir = {output_dir};
% load 4 models from 10 subjects
for i = nsub
    dcms = {fullfile(dcm_dir, sprintf('sub-%03d',i), 'DCM_stim-f_imag-b.mat'), ...
            fullfile(dcm_dir, sprintf('sub-%03d',i), 'DCM_stim-f_imag-f.mat'), ...
            fullfile(dcm_dir, sprintf('sub-%03d',i), 'DCM_stim-f_imag-fb.mat'), ...
            fullfile(dcm_dir, sprintf('sub-%03d',i), 'DCM_stim-fb_imag-b.mat'), ...
            fullfile(dcm_dir, sprintf('sub-%03d',i), 'DCM_stim-fb_imag-f.mat'), ...
            fullfile(dcm_dir, sprintf('sub-%03d',i), 'DCM_stim-fb_imag-fb.mat'), ...
            fullfile(input_model_dir, sprintf('sub-%03d',i), 'DCM_input_m4.mat')};
    matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{1}(1).dcmmat = dcms';
end
matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

spm_jobman('run', matlabbatch);
