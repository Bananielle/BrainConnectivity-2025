%% CreateFolds
% Created by Danielle Evenblij, 20-11-18
% CreateFolds takes the input 'traindata' (a n*m matrix where n = the nr of
% trials and m = the nr of voxels) and creates training and
% testing folds for k-fold cross-validation. k = nr of folds.
function [Folds] = new22_CreateFolds(Data,k_folds,loro,randomize,NrLocalizerRuns,NrTasks,NrRepeats,NrVoxels)
% Loro = 0 indicated 3-fold cv, Loro = 1 inidcated leave-one-run-out cv.
% Randomize indicates where you want to randomize the fold generation in
% 3-fold cross validation.


if loro == 0
    k_folds = 3;
    % For 3-fold cross-valiation
   
    vector = repmat(1:NrLocalizerRuns,1);
    if randomize == 1  % Select 2 runs randomly for testing, then use the rest for training.
    %1. Randomly permute a vector, and then always select the first k for
    %testing
       vector = vector(randperm(length(vector))); % If you choose randomize == 0, then you always take the same cross-validatins scheme of run 1-6.
       % So fold 1 = run 1 and 2 for testing, fold 2 = run 3-4 for testing
       % and fold 3 = run 5-6 for testing.
    end
    j=1;
    
  % Preallocate structure to speed up processing time
    Folds = struct('Testing',zeros(1,NrTasks,NrRepeats,NrVoxels),'Training',zeros(6,NrTasks,NrRepeats,NrVoxels));
    
    for fold = 1:2:NrLocalizerRuns % In steps of 2, and -1 because you only use 6 runs for 3-fold
        NrLocalizerRuns = 6;
        %rand_fold = [rand_vector(fold) rand_vector(fold+1)];
        try
        Folds(j).Testing = [Data.LocalizerData(vector(fold),:,:,:);Data.LocalizerData(vector(fold+1),:,:,:)]; % Select the current run(fold) for testing.
        catch
            disp(' ');
            disp('======!!!');
            disp('======Error in the number of folds. Check whether params.NrLocalizerRuns = 6!');
            disp('======!!!');
        end
        Folds(j).TestingRun = [vector(fold) vector(fold+1)]; % Use these for checking whether you got the correct runs
        trainfold_indices = setdiff([1:NrLocalizerRuns],Folds(j).TestingRun); % Create the vector of the runs used for training (got this trick from Giancarlo's CreateSplits code)
        Folds(j).Training = Data.LocalizerData(trainfold_indices,:,:,:); % Select the other runs for training.
        Folds(j).TrainingRuns = trainfold_indices;
        j = j+1;
    end
end

if loro == 1
    disp('====Performing leave-one-run-out cross-validation...')
    NrLocalizerRuns =7;
    k_folds = 7;
    % For leave-one-run-out
    for fold = 1:k_folds
        Folds(fold).Testing = Data(fold,:,:,:); % Select the current
       % run(fold) for testing. (TO SAVE MEMORY)
        Folds(fold).TestingRun = fold; % Use these for checking whether you got the correct runs
        trainfold_indices = setdiff([1:k_folds],fold); % Create the vector of the runs used for training (got this trick from Giancarlo's CreateSplits code)
        Folds(fold).Training = Data(trainfold_indices,:,:,:); % Select the
        %other runs for training. (TO SAVE MEMORY)
        Folds(fold).TrainingRuns = trainfold_indices;
        
    end
end
end