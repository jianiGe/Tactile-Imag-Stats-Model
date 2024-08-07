% 28 July 2024
% Script for concatenating / combining condition onsets based on the
% original onset file 

%% Contatenantion without combining conditions
% load one onset file at a time
load("C:\Users\jiani\Documents\MATLAB\stats-dcm\data\sub-010\all_onsets_goodImag_sub016.mat");

nscans = 242;
TR = 2;
run_t = nscans * TR;

onsets_new = {};
onsets_row = cell(1,11);

% compile cell array with updated onsets
for i = 1:size(onsets,1) %6
    for j = 1:length(onsets)
         onsets_new{i,j} = onsets{i,j} + run_t*(i-1);
    end
end

% compile cell array with concatenated onsets
for i = 1:length(onsets) %11
    for j = 1:size(onsets,1) %6
        onsets_row{i} = [onsets_row{i} onsets_new{j,i}];
    end
end

% Compile condition .mat
condition_names = condnames;
condition_onsets = onsets_row;

con_dur = {3 3 3 3 3 3 3 3 1 0 3}; % seconds
condition_durations = {};
for i = 1:11
    ntrial = length(condition_onsets{i});
    condition_durations{i} = repmat(con_dur{i}, 1, ntrial);
end

conditions = struct();
conditions.names = condition_names;
conditions.onsets = condition_onsets;
conditions.durations = condition_durations;

output_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-concat\new_onsets';
save(fullfile(output_dir,'sub-016-onset-concat.mat'), 'conditions');

%% Combine Stim and Imag conditions based on the concatenated files

old_cond_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-concat\new_onsets';
output_dir = 'C:\Users\jiani\Documents\MATLAB\stats-dcm\glm-stim-imag\condition_onsets';

% new conditions
new_names = {'Stim', 'Imag', 'Null_1', 'Null_2', 'preCue', 'Motion', 'badImag'};

subj = [1:10];

for i = subj;
    % load old condtions .mat file
    clear conditions
    load(strcat(old_cond_dir, '\sub-', sprintf('%03d',i), '-onset-concat.mat'));
    
    % names
    conditions.names = new_names;

    % onsets
    stim_onset = sort([conditions.onsets{1} conditions.onsets{2} conditions.onsets{3}]);
    imag_onset = sort([conditions.onsets{4} conditions.onsets{5} conditions.onsets{6}]);
    new_onsets = {stim_onset, imag_onset, conditions.onsets{7} conditions.onsets{8} ...
        conditions.onsets{9} conditions.onsets{10} conditions.onsets{11}};
    conditions.onsets = new_onsets;
    
    % durations
    stim_dur = [conditions.durations{1} conditions.durations{2} conditions.durations{3}];
    imag_dur = [conditions.durations{4} conditions.durations{5} conditions.durations{6}];
    new_durations = {stim_dur, imag_dur, conditions.durations{7} conditions.durations{8} ...
        conditions.durations{9} conditions.durations{10} conditions.durations{11}};
    conditions.durations = new_durations;
    
    % save new condition/conset file
    save(strcat(output_dir,'\sub-', sprintf('%03d',i), '-onset-v3.mat'), 'conditions');

end
