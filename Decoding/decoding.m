% August 2024
% Script for decoding analysis with the decoding toolbox

%% Decoding 3 stimulation contents
for sbj = 1:10
    if sbj == 10
        output_dir = strcat('C:\Users\asusx\Desktop\STATS\sub-0',num2str(sbj),'\decoding_Stim1');
        beta_loc = strcat('C:\Users\asusx\Desktop\STATS\sub-0',num2str(sbj),'\1st_level_good_bad_Imag');
    else
        output_dir = strcat('C:\Users\asusx\Desktop\STATS\sub-00',num2str(sbj),'\decoding_Stim1');
        beta_loc = strcat('C:\Users\asusx\Desktop\STATS\sub-00',num2str(sbj),'\1st_level_good_bad_Imag');
    end
    % Set defaults

    clear cfg
    cfg = decoding_defaults;

    % Set the analysis that should be performed

    cfg.analysis = 'searchlight'; 
    cfg.searchlight.radius = 6;

    % Set the output directory where data will be saved

    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    cfg.results.dir = output_dir;

    % Set the filename of brain mask

    cfg.files.mask = fullfile(beta_loc, 'mask.nii');

    % Set the label names to the regressor names
    labelname1  = 'StimPress';
    labelname2  = 'StimFlutt';
    labelname3  = 'StimVibro';

    labelvalue1 = 1; 
    labelvalue2 = 2; 
    labelvalue3 = 3;

    % Set additional parameters

    cfg.decoding.method = 'classification';
    cfg.decoding.train.classification.model_parameters = '-s 0 -t 0 -c 1 -b 0 -q';

    % Enable scaling min0max1

    cfg.scale.method = 'min0max1';
    cfg.scale.estimation = 'all';

    % Hide searchlight and design

    cfg.plot_selected_voxels = 0; % 0: no plotting, 1: every step, 2: every second step, 100: every hundredth step...
    cfg.plot_design          = 0;

    % The following function extracts all beta names and corresponding run
    % numbers from the SPM.mat
    regressor_names = design_from_spm(beta_loc);

    % Extract all information for the cfg.files structure 
    cfg = decoding_describe_data(cfg,{labelname1 labelname2 labelname3},[labelvalue1 labelvalue2 labelvalue3],regressor_names,beta_loc);

    % This creates the leave-one-run-out cross validation design:
    cfg.design = make_design_cv(cfg);

    % Run decoding
    results = decoding(cfg);
end

%% Decoding 3 imagery contents
for sbjs = 1:10
    if sbjs == 10
        output_dir = strcat('C:\Users\asusx\Desktop\STATS\sub-0',num2str(sbjs),'\decoding_Imag1');
        beta_loc = strcat('C:\Users\asusx\Desktop\STATS\sub-0',num2str(sbjs),'\1st_level_good_bad_Imag');
    else
        output_dir = strcat('C:\Users\asusx\Desktop\STATS\sub-00',num2str(sbjs),'\decoding_Imag1');
        beta_loc = strcat('C:\Users\asusx\Desktop\STATS\sub-00',num2str(sbjs),'\1st_level_good_bad_Imag');
    end
    % Set defaults

    clear cfg
    cfg = decoding_defaults;

    % Set the analysis that should be performed
    
    cfg.analysis = 'searchlight'; 
    cfg.searchlight.radius = 6; 

    % Set the output directory where data will be saved

    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    cfg.results.dir = output_dir;

    % Set the filename of brain mask

    cfg.files.mask = fullfile(beta_loc, 'mask.nii');

    % Set the label names to the regressor names 

    labelname1  = 'ImagPress';
    labelname2  = 'ImagFlutt';
    labelname3  = 'ImagVibro';

    labelvalue1 = 1; 
    labelvalue2 = 2; 
    labelvalue3 = 3;

    % Set additional parameters
   
    cfg.decoding.method = 'classification';
    cfg.decoding.train.classification.model_parameters = '-s 0 -t 0 -c 1 -b 0 -q';

    % Enable scaling min0max1 

    cfg.scale.method = 'min0max1';
    cfg.scale.estimation = 'all';   

    % Hide searchlight and design

    cfg.plot_selected_voxels = 0; % 0: no plotting, 1: every step, 2: every second step, 100: every hundredth step...
    cfg.plot_design          = 0;
   
    % The following function extracts all beta names and corresponding run
    % numbers from the SPM.mat
    regressor_names = design_from_spm(beta_loc);

    % Extract all information for the cfg.files structure 
    cfg = decoding_describe_data(cfg,{labelname1 labelname2 labelname3},[labelvalue1 labelvalue2 labelvalue3],regressor_names,beta_loc);

    % This creates the leave-one-run-out cross validation design:
    cfg.design = make_design_cv(cfg);

    % Run decoding
    results = decoding(cfg);
end