%% LeaveOneRunOutClassification_OPTCLA2


function [Accuracy,maskSize,Betas,Predictors,Trues,rescaledSVMweights] = new22_LeaveOneRunOutClassification_OPTCLA2(Data,Folds,Mask,permProgress_str,PerformPermutationTest,NrRepeats,NrPairs,NrTasks,NrVoxels,UseAllVoxels,str_participant)
   

disp(' ');
Accuracy = zeros(size(Folds,2),NrPairs);
Predictors = zeros(size(Folds,2),NrPairs,NrRepeats*2);
Trues = zeros(size(Folds,2),NrPairs,NrRepeats*2);


permString = ['Permutation testing = ',num2str(PerformPermutationTest)];


for foldNr = 1:size(Folds,2)
    disp(['=====',str_participant,': Computing fold ',num2str(foldNr),'... ',permString,', ',permProgress_str]);
    disp(['Run(s) used for training: ',num2str(Folds(foldNr).TrainingRuns)]);
    disp(['Run(s) used for testing: ',num2str(Folds(foldNr).TestingRun)]);
    disp(' ' );
    
    %Input needed: fold,Folds,Contrast,nrRepeats,nrTasks,nrVoxels,UseAllVoxels,PerformPermutationTest
    [Accuracy(foldNr,:),Betas(foldNr,:,:),Predictors(foldNr,:,:),Trues(foldNr,:,:),rescaledSVMweights(foldNr,:,:)] = new22_OPTCLA2_foldTrainingTesting_2class(Data,foldNr,Folds,Mask,NrRepeats,NrTasks,NrVoxels,UseAllVoxels,PerformPermutationTest);
   % Accuracy(foldNr).TaskNr = vectorizedTrainingAndTesting(Data,foldNr,Folds,Mask,NrRepeats,NrTasks,NrVoxels,UseAllVoxels,PerformPermutationTest);
    
    
    
end


maskSize = size(find(Mask));
  disp(['Size of mask: ',num2str(maskSize)]);
disp('====Done.');
end
