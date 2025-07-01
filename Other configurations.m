% PARAMETERS TO CHANGE
ParticipantsAnalyzed = [14]; % Indices that tells the code which participants should be analyzed
params.AnalysisType = 'Wholebrain'; % Select Wholebrain or NOI1000 as your means of feature selection.
%params.AnalysisType = 'NOI1000';
params.MaxVoxelsperTask = 1000; % For feature selection: nr of voxels selected per task

% Analyses (select only 1)c
params.Analysis.StandardClassification = 1;         % Analysis: Standard within-participant classification
params.Analysis.AcrossParticipantClassification = 0;% Analysis:Trains and test a classifier on multiple participants.
params.Analysis.MulticlassClassificaftion = 1;
params.Analysis.PerformPermutationTest = 1;


% Feature selection (select one or both) - NOTE: you can't use feature
% selection when performing cross-validation.
params.Analysis.UnivariateContrasts = 0;            % Feature selection: uses a univariate contrast mask of 2 merged task vs. rest to select features for each task pair
params.Analysis.HighestTvalues = 0;                 % Feature selection: Selects the highest n absolute T-values as features based on the initial univariate contrast
params.Analysis.RemoveAllDuplicates = 1;
params.Analysis.HighestTvaluesGLM = 1;
params.Analysis.NrofFeaturesAnalysis = 0;           % Analysis: Performs 5-2 holdout classification with different numbers of features.
params.NrSelectedVoxels = 2000;                     % Indicate how many T-Values you want to use.

% Classification method (select only 1)
params.Analysis.Holdout = 0;                        % Classificaftion method: Performs 5-2 holdout classification for whole brain or with feature selection (Univariate contrast masks)
params.Analysis.CrossValidation = 1;                % Classificaftion method: Performs k-fold cross-validation on whole-brain data.

% Other
params.Analysis.PerformPermutationTest = 0;         % Statistical test: Performs permutation test
params.Analysis.CreateFigures = 0;                  % If you want to create figures disping the accuracies for each participant (warning: will create a lot of figures)
