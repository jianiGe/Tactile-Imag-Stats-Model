% 29 July 2024
% Script for extracting VOI for one participant based on
% 1. SPM contrast
% 2. Group mean peak coordinates (from the original paper)
% 3. Adjustment to participant-specific peak coordinate

% subject spm.mat
spm_mat = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-stim-imag\sub-010\SPM.mat';

% compile matlabbatch
clear matlabbatch

% right BA2
matlabbatch{1}.spm.util.voi.spmmat = {spm_mat};
matlabbatch{1}.spm.util.voi.adjust = 5; % adjust to effects of interest
matlabbatch{1}.spm.util.voi.session = 1;
matlabbatch{1}.spm.util.voi.name = 'BA2';
matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 1;
matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1;
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.001;
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = [44 -44 60];
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 15;
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{1}.spm.util.voi.roi{3}.sphere.centre = [0 0 0];
matlabbatch{1}.spm.util.voi.roi{3}.sphere.radius = 8;
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.spm = 1;
matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
matlabbatch{1}.spm.util.voi.expression = 'i1 & i3';
% left IPL
matlabbatch{2}.spm.util.voi.spmmat = {spm_mat};
matlabbatch{2}.spm.util.voi.adjust = 5; % adjust to effects of interest
matlabbatch{2}.spm.util.voi.session = 1;
matlabbatch{2}.spm.util.voi.name = 'IPL';
matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 1;
matlabbatch{2}.spm.util.voi.roi{1}.spm.conjunction = 1;
matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.001;
matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{2}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
matlabbatch{2}.spm.util.voi.roi{2}.sphere.centre = [-44 -46 56];
matlabbatch{2}.spm.util.voi.roi{2}.sphere.radius = 15;
matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{2}.spm.util.voi.roi{3}.sphere.centre = [0 0 0];
matlabbatch{2}.spm.util.voi.roi{3}.sphere.radius = 8;
matlabbatch{2}.spm.util.voi.roi{3}.sphere.move.global.spm = 1;
matlabbatch{2}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
matlabbatch{2}.spm.util.voi.expression = 'i1 & i3';
% right IFG
matlabbatch{3}.spm.util.voi.spmmat = {spm_mat};
matlabbatch{3}.spm.util.voi.adjust = 5; % adjust to effects of interest
matlabbatch{3}.spm.util.voi.session = 1;
matlabbatch{3}.spm.util.voi.name = 'IFG';
matlabbatch{3}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{3}.spm.util.voi.roi{1}.spm.contrast = 2;
matlabbatch{3}.spm.util.voi.roi{1}.spm.conjunction = 1;
matlabbatch{3}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
matlabbatch{3}.spm.util.voi.roi{1}.spm.thresh = 0.001;
matlabbatch{3}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{3}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
matlabbatch{3}.spm.util.voi.roi{2}.sphere.centre = [54 12 0];
matlabbatch{3}.spm.util.voi.roi{2}.sphere.radius = 15;
matlabbatch{3}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{3}.spm.util.voi.roi{3}.sphere.centre = [0 0 0];
matlabbatch{3}.spm.util.voi.roi{3}.sphere.radius = 8;
matlabbatch{3}.spm.util.voi.roi{3}.sphere.move.global.spm = 1;
matlabbatch{3}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
matlabbatch{3}.spm.util.voi.expression = 'i1 & i3';

nrun = 1;
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch, inputs{:});