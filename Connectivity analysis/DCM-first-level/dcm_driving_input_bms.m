% 29 July 2024
% Script for Bayesian model selection for driving input models

nsub = 10;
output_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\dcm-driving-input';

% compile matlabbatch
matlabbatch = {};
matlabbatch{1}.spm.dcm.bms.inference.dir = {output_dir};
% load 4 models from 10 subjects
for i = 1:nsub
    dcms = {fullfile(output_dir, sprintf('sub-%03d',i), 'DCM_input_m1.mat'), ...
            fullfile(output_dir, sprintf('sub-%03d',i), 'DCM_input_m2.mat'), ...
            fullfile(output_dir, sprintf('sub-%03d',i), 'DCM_input_m3.mat'), ...
            fullfile(output_dir, sprintf('sub-%03d',i), 'DCM_input_m4.mat')};
    matlabbatch{1}.spm.dcm.bms.inference.sess_dcm{i}(1).dcmmat = dcms';
end
matlabbatch{1}.spm.dcm.bms.inference.model_sp = {''};
matlabbatch{1}.spm.dcm.bms.inference.load_f = {''};
matlabbatch{1}.spm.dcm.bms.inference.method = 'FFX';
matlabbatch{1}.spm.dcm.bms.inference.family_level.family_file = {''};
matlabbatch{1}.spm.dcm.bms.inference.bma.bma_no = 0;
matlabbatch{1}.spm.dcm.bms.inference.verify_id = 1;

spm_jobman('run', matlabbatch);
