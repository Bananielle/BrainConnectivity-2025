
%% 2-class classification: leave-one-run-out cross-validation (wholebrain)
tic

 % Training trials 
   % nrOfPermutations = 1;
    %nrOfTrainingRuns = 6;
    
    % Prepare paramater inputs
    NrRepeats = params.NrRepeats;
    NrTasks = params.NrTasks;
    NrVoxels = params.NrVoxels;
    UseAllVoxels = params.UseAllVoxels;
    NrPairs = params.NrPairs;
    %str_participant = params.str_participant;
    NrLocalizerRuns = params.NrLocalizerRuns;
    DataFolder = params.DataFolder;
    AnalysisType = params.AnalysisType;
    


MainResultsCV = zeros(max(ParticipantsAnalyzed),nrOfPermutations,params.NrLocalizerRuns,params.NrPairs); % Participants x permutations x folds x taskpairs


for ParticipantNr = ParticipantsAnalyzed
   % PARFOR params.Participant = ParticipantNr;
     str_participant = ['P',num2str(ParticipantNr,'%02.f')]; % Makes sure the participant string number alwasy contains 2 digits.
   
   
    Data = P(ParticipantNr).Data.LocalizerData;
    
    Mask = P(ParticipantNr).Mask; 
    [Folds] = new22_CreateFolds(Data,0,1,0,NrLocalizerRuns,NrTasks,NrRepeats,NrVoxels);  % Insert Data,params,k_folds,loro,randomize)
   % PARFOR clear Data;
   
   % Remove data from Folds, just keep the indices
    Folds = rmfield(Folds,'Testing') ;
    Folds = rmfield(Folds,'Training') ;
      
  
    for permNr = 1: nrOfPermutations
        permProgress_str = ['Permutation ', num2str(permNr),'\',num2str(nrOfPermutations),'.'];
    %for nrOfTrainingRuns = 6 : 6
      %  disp(['=====',params.str_participant,' - Permnr ',num2str(permNr), ': Nr of training runs used = ', num2str(nrOfTrainingRuns)]);
     % PARFOR   clear randomlyselectedTrainingRuns
        
        %[Folds] = new22_CreateFolds(Data,params,0,1,0);  % Insert Data,params,k_folds,loro,randomize)
        %clear Data;
        
        % Randomly select the training runs (for when doing training trials
        % analysis)
%         for fold = 1:size(Folds,2)
%             randomArray = randperm(length(Folds(fold).TrainingRuns),nrOfTrainingRuns);
%             randomlyselectedTrainingRuns(fold,:) = Folds(fold).TrainingRuns(randomArray);
%             Folds(fold).TrainingRuns = randomlyselectedTrainingRuns(fold,:);
%             Folds(fold).Training = Data(randomlyselectedTrainingRuns(fold,:),:,:,:);
%         end
        
       
        [Accuracies,maskSize,Betas,Predictors,Trues,rescaledSVMweights] = new22_LeaveOneRunOutClassification_OPTCLA2(Data,Folds,Mask,permProgress_str,PerformPermutationTest,NrRepeats,NrPairs,NrTasks,NrVoxels,UseAllVoxels,str_participant);  %AccuraciesSorted,StandardDev
       % PARFOR clear Folds;
        
      %  meanCV = mean(Accuracies,1);
      %  StandardDev = std(Accuracies,1);
        
        %  MainResultsCV(ParticipantNr,:,:) = Accuracies;
       % MainResultsCV(ParticipantNr,permNr,nrOfTrainingRuns,:,:) =
       % Accuracies; % When trainingrun analysis included
       
        MainResultsCV(ParticipantNr,permNr,:,:) = Accuracies; % No
%        trainingrun analysis SFSKJFHSDKJFHKSDJFHKSDJHF
        
  %  end
    
    end
    
    % Saving results in structure P
    %    P(ParticipantNr).Results.Folds = Folds;
     
    P(ParticipantNr).Results.(params.AnalysisType).MaskSize = maskSize;
    P(ParticipantNr).Results.(params.AnalysisType).All = Accuracies;
    P(ParticipantNr).Results.(params.AnalysisType).Predictors = Predictors;
    P(ParticipantNr).Results.(params.AnalysisType).Trues = Trues;
    P(ParticipantNr).Results.SVMWeights = rescaledSVMweights;
% 
    
    % % Save as VMP map
    for taskpair = 1:21
        data = squeeze(mean(rescaledSVMweights)); % Take average of the 7 folds
        mean_svm_weights = data(taskpair,:);
        
        full_weights = zeros(106720, 1);       % initialize full-size vector
        full_weights(Mask) = mean_svm_weights;      % fill in the weights where the mask is true
    
        full_weights = reshape(full_weights,[58,40,46]);
        full_weights = single(full_weights);
    
        cd([params.MainFolder,'/SVMweights']);
        filename = ['P',num2str(ParticipantNr),'_',num2str(taskpair), '_', MentalTaskpairs{taskpair},'_svmweights_matlab_2025.vmp'];
        temp = xff('P14_MC_vs_rest_Bonf0.05.vmp');
        temp.Map.VMPData = full_weights;
        temp.Map.Name = ['P',num2str(ParticipantNr),'_',num2str(taskpair),'_svmweights_matlab_2025'];
        temp.saveAs(filename);
    end


  
end

disp('=====Finished leave-one-run-out crossvalidation');

toc