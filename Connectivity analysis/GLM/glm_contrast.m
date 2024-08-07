% 29 July 2024
% Script for estimating contrasts for all subjects (for VOI-extraction
% purposes)
% con1: Stim
% con2: Imag
% con3: Stim>Null_1
% con4: Imag>Null_2
% ess5: Effects of interest (for mean correction)

glm_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-stim-imag';

new_contrasts = {struct('name', 'Stim', 'weights', [1 0 0 0 0 0 0], 'type', 't');...
                 struct('name', 'Imag', 'weights', [0 1 0 0 0 0 0], 'type', 't');...
                 struct('name', 'Stim>Null_1', 'weights', [1 0 -1 0 0 0 0], 'type', 't');...
                 struct('name', 'Imag>Null_2', 'weights', [0 1 0 -1 0 0 0], 'type', 't');...
                 struct('name', 'Effects of interest', 'weights', eye(2), 'type', 'f');};

subj = [1:10];

% Specify matlabbatch
for i = subj
    spm_mat = strcat(glm_dir, '\sub-', sprintf('%03d',i), '\SPM.mat');
    matlabbatch = {};

    for j = 1:length(new_contrasts)

        matlabbatch{j}.spm.stats.con.spmmat = {spm_mat};

        if new_contrasts{j}.type == 't'
            matlabbatch{j}.spm.stats.con.consess{1}.tcon.name = new_contrasts{j}.name;
            matlabbatch{j}.spm.stats.con.consess{1}.tcon.weights = new_contrasts{j}.weights;
            matlabbatch{j}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        elseif new_contrasts{j}.type == 'f'
            matlabbatch{j}.spm.stats.con.consess{1}.fcon.name = new_contrasts{j}.name;
            matlabbatch{j}.spm.stats.con.consess{1}.fcon.weights = new_contrasts{j}.weights;
            matlabbatch{j}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
        end
    end
    
    spm_jobman('run', matlabbatch);
end

