
%% PARFOR 2-class classification: leave-one-run-out cross-validation (wholebrain)

function Results = parfor_2classclassification(Data)

tic

 % Training trials 
    nrOfPermutations = 1;
    nrOfTrainingRuns = 6;

MainResultsCV = zeros(max(ParticipantsAnalyzed),nrOfPermutations,params.NrLocalizerRuns,params.NrPairs); % Participants x permutations x folds x taskpairs

parfor ParticipantNr = ParticipantsAnalyzed
 
   str_participant = ['P',num2str(ParticipantNr,'%02.f')]; % Makes sure the participant string number alwasy contains 2 digits.
    
    Data = P(ParticipantNr).Data.LocalizerData;
    [Folds] = new22_CreateFolds(Data,params,0,1,0);  % Insert Data,params,k_folds,loro,randomize)
    clear Data;
   
  
    for permNr = 1: nrOfPermutations
        permProgress_str = ['Permutation ', num2str(permNr),'\',num2str(nrOfPermutations),'.'];
    %for nrOfTrainingRuns = 6 : 6
      %  disp(['=====',params.str_participant,' - Permnr ',num2str(permNr), ': Nr of training runs used = ', num2str(nrOfTrainingRuns)]);
        clear randomlyselectedTrainingRuns
        
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
        
        
        % Apply whole-brain mask
        
        Mask = OPTCLA2_ApplyMask(params,0,0); % T1 and t2 can be 0 because we're only using whole-brain (t1 and t2 are only needed for the NOI masked based on taskpair)
        [Accuracies,maskSize] = new22_LeaveOneRunOutClassification_OPTCLA2(params,Folds,Mask,permProgress_str);  %AccuraciesSorted,StandardDev
      %  clear Folds;
        
      %  meanCV = mean(Accuracies,1);
      %  StandardDev = std(Accuracies,1);
        
        %  MainResultsCV(ParticipantNr,:,:) = Accuracies;
       % MainResultsCV(ParticipantNr,permNr,nrOfTrainingRuns,:,:) =
       % Accuracies; % When trainingrun analysis included
        MainResultsCV(ParticipantNr,permNr,:,:) = Accuracies; % No trainingrun analysis
        
  %  end
    
    end
    
    % Saving results in structure P
    %    P(ParticipantNr).Results.Folds = Folds;
     P(ParticipantNr).Results.(params.AnalysisType).MaskSize = maskSize;
    P(ParticipantNr).Results.(params.AnalysisType).All = Accuracies;
  %  P(ParticipantNr).Results.(params.AnalysisType).Mean = mean(Accuracies,1);
   % P(ParticipantNr).Results.(params.AnalysisType).SD = std(Accuracies,1);
    
   P(ParticipantNr).Params = params; % Add used parameters for each participant
end

disp('=====Finished leave-one-run-out crossvalidation');

toc