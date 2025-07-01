%% OPTCLA2 MVPA

% PARAMETERS TO CHANGE
ParticipantsAnalyzed = [5:20]; % Indices that tells the code which participants should be analyzed
params.AnalysisType = 'Wholebrain'; % Select Wholebrain or NOI1000 as your means of feature selection.
%params.AnalysisType = 'NOI1000';
params.MaxVoxelsperTask = 1000; % For feature selection: nr of voxels selected per task

% Analyses (select only 1)c
params.Analysis.StandardClassification = 1;         % Analysis: Standard within-participant classification
params.Analysis.MulticlassClassificaftion = 1;
params.Analysis.PerformPermutationTest = 1;

params.UseAllVoxels = 0; %Use all 120.000 voxels, and don't use a whole-brain mask (which is around 50.000 voxels)

% Folders (change these accordingly)
params.MainFolder = '/Users/danielle/Documents/Bureau/Neuroscience/Projects/01_OPTCLA2/Matlab Scripts/New pruned scripts 2022/';
cd(params.MainFolder);
% Note: if NeuroElf is not yet installed, type " NeuroElf_v10_5153 -i " to
% install, and when it asks for an installation path, save its contents in params.MainFolder.

params.DataFolder = [params.MainFolder,'Data/'];
params.SaveFolder = [params.MainFolder,'Results/'];
addpath(params.MainFolder) % Add the main folder to the Matlab search path, so that it can find all its functions.
addpath([params.MainFolder,'NeuroElf_v10_5153']);
% Add here path for where you installed NeuroElf.

% Initialize parameters and put into params structure
params.NrPairs = 21;       % Nr of mental taskpairs
params.NrTasks = 7;        % 7 tasks: Mental Drawing (MD), Mental Talking (MT), Mental calculation (MC), Mental Singing (MS), Mental Rotation (MR)
% Spatial Navigation (SN) and Tactile Imagery (TacI)
params.NrRepeats = 4;   % Is the number of repeats of a task trial within a run.
params.NrVoxels = 106720;
params.NrLocalizerRuns = 7;
params.RunsUsedforTraining = [1,2,3,4,5];
params.RunsUsedforTesting = [6,7];

load('MentalTasks.mat');
load('MentalTaskpairs.mat');
load('PairNames.mat');
load('TaskColours.mat');

% Mental task colours (for figures)
TaskColours.MD = [1 0 0];
TaskColours.MT = [146/255, 208/255, 80/255];
TaskColours.MC = [237/255, 107/255, 219/255];
TaskColours.MS = [1,192/255,0];
TaskColours.MR = [68/255, 114/255, 196/255];
TaskColours.SN = [173/255, 247/255, 245/255];
TaskColours.TacI = [204/255, 98/255, 18/255];
TaskColours.GeneralBargraph = [162, 194, 190]./255;

disp(' ');
disp(['=====Analyzing participants: ',num2str(ParticipantsAnalyzed),' - Number of localizer runs = ',num2str(params.NrLocalizerRuns),'.']);



%% Classification: leave-one-run-out cross-validation (wholebrain)
cd(params.MainFolder)

% Get data first
clear run;
run('GetData.m');

clear MainResultsCV;

% Do permutation tests?
PerformPermutationTest = 0;
nrOfPermutations = 1;
params.NrPermutations = nrOfPermutations;
params.Analysis.PerformPermutationTest = PerformPermutationTest;

% Run 2-class classification script
run('TwoClassClassification.m');



save(['MainResults_2classloro_vmr-vtc_masks_permutationtest_P5-20',datestr(now, '_dd-mm-yy')],'MainResultsCV');


%% Permutation tests 2-class
cd([params.DataFolder,'Permutation results two-class'])
perm_accuracies = zeros(20,1000,7,params.NrPairs);

load('MainResults_2classloro_vmr-vtc_masks_permutationtest_P05-20_09-08-23.mat')

% save(['MainResults_2classloro_vmr-vtc_masks_permutationtest_P05-20',datestr(now, '_dd-mm-yy')],'perm_accuracies');
cd(params.DataFolder)
load('MainResults_2classloro_vmr-vtc_masks_27-07-23.mat')
accuracies = squeeze(mean(MainResultsCV([5:20],:,:,:),3));

% Get the mean of the cross-validation results
perm_accuracies = squeeze(mean(perm_accuracies,3));

% Count how many permutation outcomes are equal or bigger than the actual
% observed classification accuracy. For 100 permutations, with p = 0.05,
% only 5 instances or less can be equal or larger than the observed value.

p_values = zeros(16,21);
below_threshold = zeros(16,21);

for participant = 1:16

test = squeeze(perm_accuracies(participant,:,:));
actual_accuracies = squeeze(accuracies(participant,:,:));

% Now check how often the permutation accuracies exceed the actual
% classification accuracies.
temp = zeros(params.NrPairs,1000);
for taskpair = 1:params.NrPairs
    temp(taskpair,:) = test(:,taskpair) >= actual_accuracies(taskpair);
end
p_value = sum(temp,2)/1000;
Thres_0_05 = p_value(:,1)<=0.05;

p_values(participant,:) = p_value;
below_threshold(participant,:) = Thres_0_05;

end

% Gives you the percentage of participants that has a p-value below 0.05 for the n=1000 permutation test for that taskpair
permutationValues_withoutmean = mean(below_threshold)';

% Add the mean and std
permutationValues = [permutationValues_withoutmean;mean(permutationValues_withoutmean)] % Note that these are the unsorted values!
%permutationValues = [permutationValues;std(permutationValues_withoutmean)]

%



%% Vizualize 2-class data
cd([params.MainFolder,'Results'])
% load current data

load('MainResults_2classloro_vmr-vtc_masks_27-07-23.mat')
clear run
cd(params.MainFolder)
run('CreateTableOfTwoClassAccuracies.m');
run('CreateBarGraphsOfTwoClassAccuracies.m'); % One unsorted and one of the sorted accuracies (from highest to lowest)

run('PlotAccuracyMatrix.m'); % Plot an accuracy matrix of mean 2-class accuracies



%% Multi-class
cd(params.MainFolder)

% Get data first
clear run
run('GetData.m');

% Do permutation tests?
params.NrPermutations = 1;
params.Analysis.PerformPermutationTest = 0;

% Perform multi-class classification
clear run
run('MultiClassClassification.m');

%% Run summary and plotting of multi-class data
cd([params.MainFolder,'Results']);
load('MultiClassResultsOneVariable_P05-P20_WithVMRandVTCmask_15-12-22.mat');
clear run
run('MultiClassSummarizeData.m');
run('MultiClassFigureMaking.m');
beep


%% Confusion matrices of 2- to 7-class data

cd([params.MainFolder,'Results']);
load('MultiClassResultsOneVariable_P05-P20_WithVMRandVTCmask_15-12-22.mat');


class = 7; % Change the class here 

% Sort the accuracies from highest to lowest.
accuracies_multiclass = mean(MulticlassData(:,:,class-1)); % Get the mean multi-class data
accuracies_multiclass = accuracies_multiclass(accuracies_multiclass ~= 0);

[sortedAcc, sortedIdx] = sort(accuracies_multiclass, 'descend')

%Figure layout depending on class (used for tile layout)
if class == 2 || class == 5
    a = 3; 
    b = 7;
elseif class == 3 || class == 4
    a = 7;
    b = 5;
elseif class == 6
    a = 3;
    b = 3;
elseif class == 7
    a = 3;
    b = 3;
end

figure('Units','normalized','Position',[.05 .05 .9 .9], 'Color','w');
t = tiledlayout(a, b, 'TileSpacing', 'compact', 'Padding', 'compact');
title(t, [num2str(class),'-Class Confusions (%)'], 'FontWeight','bold', 'FontSize', 18);

clear length

for i = 1:length(accuracies_multiclass) % For all the task combinations
    combi = sortedIdx(i);
    CurrentCombi = ClassCombinationsPerClass(class).ClassCombi(combi,:);

     % accumulate confusion across folds participants and task combinations
     C_acc = zeros(length(CurrentCombi),class);
    for p = ParticipantsAnalyzed % Do this for each participant
        preds = P(p).Results.Predictors{class,combi};
        trues = P(p).Results.Trues{class,combi};
        for fold = 1:7 % folds
            y_pred = preds(fold,:);
            y_true = trues(fold,:);
            %if numel(unique(y_true))<2
             %   continue; 
            %end
            reversePreds = CurrentCombi(y_pred); % Make sure the actual task label/nummering is used for the matrix (MD=1, MT=2, etc.)
            reverseTrues = CurrentCombi(y_true);
            C_acc = C_acc + confusionmat(reverseTrues, reversePreds, 'Order', CurrentCombi);
            
        end
    end

    % Display results
       % Normalize by row
    row_sums = sum(C_acc, 2);  % fix dimension to 2 (not 3 — this is a 2D matrix!)
    row_sums(row_sums == 0) = 1;  % prevent division by zero
    C_percent = round(C_acc ./ row_sums * 100);


    % Sum percentages per row
    row_percent_totals = sum(C_percent, 2);  % should be [100; 100]
    matrix_total = sum(row_percent_totals);  % should be 200

    % Create task-combo name
    tasknames = cell(1, class);
    task_str = '';
    for currenttask = 1:class
        tasknames{currenttask} = MentalTasks{CurrentCombi(currenttask)};
        if currenttask == 1
         task_str = [task_str, tasknames{currenttask}];
        else
            task_str = [task_str, '-' tasknames{currenttask}];
        end
    end


    % Display results
    fprintf('\nTask combi %02d: %s\n', combi, task_str);
    fprintf('Row sums (%%): %.1f%% and %.1f%%\n', row_percent_totals(1), row_percent_totals(2));
    fprintf('Total matrix sum: %.1f%%\n', matrix_total);


    % Create chart
    nexttile;
    % Create confusion chart
    h = confusionchart(C_percent, tasknames, ...
    'Title', [task_str ' (%)']);
   

    % Improve font & visual clarity
    h.FontSize = 12;
   % h.XLabel = 'Predicted mental task';
   % h.YLabel = 'True mental task';
     h.XLabel = ' ';
    h.YLabel = ' ';
    if class == 7
        h.RowSummary = 'row-normalized';
        h.ColumnSummary = 'column-normalized';
    end

end



%% Save results
P = rmfield(P,'Data');
cd(params.SaveFolder);
filename = ['OPTCLA2_Results_',params.AnalysisType,datestr(now, '_dd-mm-yy')];
save(['ResultsWithParameters',datestr(now, '_dd-mm-yy')],'P'); % Save summarized accuracies for all participants (for later analyses)
disp(['=====Results saved in ',params.SaveFolder,'.']);

%% Extra

run('CommunicationRunsFigures.m')

run('BestMulticlassCombos.m')