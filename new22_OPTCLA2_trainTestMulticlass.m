function [accuracy, predlabels, testlabels] = new22_OPTCLA2_trainTestMulticlass(DataStructure,classes,CurrentCombi, Folds, fold,TaskLabels,Contrast,performPermutationTests)
%UNTITLED Summary of this functiongoes here
%   Detailed explanation goes here


nrofTrials = length(DataStructure);
nrOfVoxels = length(squeeze(DataStructure(1).Data)');
%SelectedData_Training = zeros(nrofTrials,nrOfVoxels);


clear SelectedData_Training
clear SelectedLabels_Training


% Training data
trialnr = 1;
for task = 1:classes % Select all tasks in that combination and put in SelectedData
    for trials = 1:length(DataStructure) % check for all trials:
    
        CurrentTask = CurrentCombi(task);
        if strcmp(DataStructure(trials).Task,TaskLabels{CurrentTask}) && any(Folds(fold).TrainingRuns == DataStructure(trials).Run) % If contains task and the run is part of the training data of the fold
            %disp(['trials = ',num2str(trials),', ',DataStructure(trials).Task,', run=',num2str(DataStructure(trials).Run)])
            SelectedData_Training(trialnr,:) = squeeze(DataStructure(trials).Data)';
            SelectedLabels_Training{trialnr,1}= DataStructure(trials).Task;
            
        
            trialnr = trialnr+1;
        end
    end
end



% Testing data
clear SelectedData_Testing
clear SelectedLabels_Testing
trialnr = 1;

for task = 1:classes % Select all tasks in that combination and put in SelectedData
    for trials = 1:length(DataStructure) % check for all trials:
    
        CurrentTask = CurrentCombi(task);
        if strcmp(DataStructure(trials).Task,TaskLabels{CurrentTask}) && any(Folds(fold).TestingRun == DataStructure(trials).Run) % If contains task and the run is part of the training data of the fold
            SelectedData_Testing(trialnr,:) = squeeze(DataStructure(trials).Data)';
            SelectedLabels_Testing{trialnr,1}= DataStructure(trials).Task;
        
            trialnr = trialnr+1;
        end
    end
end


%if params.Analysis.UnivariateContrasts == 1
 %   SelectedData_Training = SelectedData_Training(:,logical(Merged_vsRest_Masks(:,combinr)));
  %  SelectedData_Testing = SelectedData_Testing(:,logical(Merged_vsRest_Masks(:,combinr)));
%else
    SelectedData_Training = SelectedData_Training(:,logical(Contrast));
    SelectedData_Testing = SelectedData_Testing(:,logical(Contrast));%
%end
MaskSize = size(SelectedData_Training,2);


% Divide selected data into training and testing set
% Data.Train = SelectedData_Training;
TrainLabels = SelectedLabels_Training;
%  Data.Test = SelectedData_Testing;
TestLabels = SelectedLabels_Testing;

% If permutation testing, shuffle all labels

if performPermutationTests == 1

    labels = [TrainLabels ; TestLabels];
    length_labels = length(labels);
    rand_labbels = randperm(length_labels);
    perm_label = labels(rand_labbels); % Permute all labels.
    length_trainlabels = length(TrainLabels);
    TrainLabels = perm_label(1:length_trainlabels); % Split up again in training and testing labels
    TestLabels = perm_label((length_trainlabels+1):end);
end


% Add HighestTvalues indices to train and testdata if
% chosen
% if params.Analysis.HighestTvalues == 1
%     params.FeatureSelectionMethod = 'HighestTvalues';
%     if params.NrSelectedVoxels <= MaskSize % Only use the selected t-values if its specified size does not exceed the size of the merged tasks-vs-rest mask.
%         cd(params.MainFolder)
%         
%         [SelectedTvalues_indices,TotalSelectedTvalues]...
%             = SelectTvalues(params, SelectedLabels_Training);
%         
%         P(params.Participant).Task_Vs_Rest_Masks(combinr).TotalSelectedTvalues...
%             = TotalSelectedTvalues; % Store number of selected T-values for each taskpair
%         
%         SelectedData_Training = SelectedData_Training(:,SelectedTvalues_indices);
%         SelectedData_Testing = SelectedData_Testing(:,SelectedTvalues_indices);
%         disp(['Absolute highest t-values used. Size of training data: ',num2str(size(Data.Train))]);
%         
%     end
%     
% end



% Perform multi-class classification
Mdl = fitcecoc(SelectedData_Training,TrainLabels);
trainingerror = resubLoss(Mdl);

accuracy = 1-loss(Mdl,SelectedData_Testing,TestLabels);

% Store predictions and true labels (for making confusion matrices later)
predlabels = categorical(predict(Mdl, SelectedData_Testing));
testlabels = categorical(TestLabels);



end

