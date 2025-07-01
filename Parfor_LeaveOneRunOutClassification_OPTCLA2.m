%% LeaveOneRunOutClassification_OPTCLA2

function [Accuracy] = Parfor_LeaveOneRunOutClassification_OPTCLA2(params,Folds,Mask)
disp(' ');
Accuracy = zeros(size(Folds,2),params.NrPairs);
%rescaledSVMweights = zeros(size(Folds,2),params.NrPairs,params.NrVoxels);

for foldNr = 1:size(Folds,2)
   % disp(['=====',params.str_participant,': Computing fold ',num2str(foldNr),'...']);
    disp(['Runs used for training: ',num2str(Folds(foldNr).TrainingRuns)]);
    disp(['Runs used for testing: ',num2str(Folds(foldNr).TestingRun)]);
    disp(' ' );
    
    [Accuracy(foldNr,:)] = new22_OPTCLA2_foldTrainingTesting_2class(params,foldNr,Folds,Mask);

end

disp('====Done.');
end
