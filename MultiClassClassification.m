% Multi-class classification

tic;

% Step 1: Sort data in n classes (including labels)
% Localizer data =
params.AnalysisType = 'MulticlassClassification';

Accuracy = zeros(max(ParticipantsAnalyzed),params.NrPermutations,35,params.NrTasks-1); % max participants,  permutation x max. task combinations, 6 (classes computed)
perm_accuracy_multiclass = zeros(params.NrPermutations,35,params.NrTasks-1);

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
TotalNrOfFolds = 7;


PerformPermutationTest = params.Analysis.PerformPermutationTest;
NrPermutations = params.NrPermutations;
performPermutationTest = PerformPermutationTest;

clear Accuracy

for ParticipantNr = ParticipantsAnalyzed
    Participant = ParticipantNr;
    str_participant = ['P',num2str(ParticipantNr,'%02.f')]; % Makes sure the participant string number alwasy contains 2 digits.
    
    disp(' ')
    disp(['=====Performing multi-class classification on ',str_participant,'...'])
    
    clear SelectedLabels
    
    
    TaskLabels = {'MD','MT','MC','MS','MR','SN','TacI'};
    Data = P(ParticipantNr).Data.LocalizerData;
    
    Mask = P(ParticipantNr).Mask;
    Folds = new22_CreateFolds(Data,0,1,0,NrLocalizerRuns,NrTasks,NrRepeats,NrVoxels);  % Insert Data,params,k_folds,loro,randomize)
    
    % Remove data from Folds, just keep the indices
    Folds = rmfield(Folds,'Testing') ;
    Folds = rmfield(Folds,'Training') ;
    TotalNrOfFolds = size(Folds,2);

    %  for PermutationNr = 1: params.NrPermutations
    %    disp(["Permutation ",num2str(PermutationNr)]);
    % Performing training and testing with shuffled labels
    
    
    % Reshape data
    % Put all trials for all runs and for all tasks in one column, but
    % give labels (task, run) in other colums
    
    % Rearrange data
    trials = 1;
    for run = 1:7
        for task = 1:params.NrTasks
            for trial = 1:params.NrRepeats
                DataStructure(trials).Run = run;
                DataStructure(trials).Task = TaskLabels{task};
                DataStructure(trials).Data = Data(run,task,trial,:);
                DataStructure(trials).Participant = ParticipantNr;
                DataStructure(trials).Mask = 0; % zero for now
                trials = trials+1;
            end
        end
    end
    
    P(ParticipantNr).Data = []; % To save memory.
    Data = [];
    
    
    taskvector = [1:NrTasks];
    for classes = 2:NrTasks
        ClassCombinationsPerClass(classes).ClassCombi = nchoosek(taskvector,classes);
        sizeOfClassCombinations(classes) = size(ClassCombinationsPerClass(classes).ClassCombi,1);
    end
    
    classnr = 1;
 
    Accuracy_classes = zeros(NrPermutations,35,params.NrTasks-1); % permutations, max task combinations, 6 (max classes)
    Predictors_classes = cell(params.NrTasks-1, 35); % [class index, task combination index]
    Trues_classes = cell(params.NrTasks-1, 35);

    for classes = 2:NrTasks
        
       
        disp(["Class ",num2str(classes)]);
        % Calculate possible number of combinations for 7 tasks in n
        % classes
        %classes = 3; % n-class classification
        combinations = factorial(7)/(factorial(classes)*factorial(7-classes)); % 35 for 3 and 4, 21 for 5, 7 for 6
        % List all possible combinations:
        taskvector = [1:NrTasks];
        %  ClassCombinations = nchoosek(taskvector,classes);
        currentclasscombisize = sizeOfClassCombinations(classes);
         
       Accuracy_combiNr = zeros(NrPermutations,35); 
   
      
        for combinr = 1:currentclasscombisize %  For all possible combinations of n-class
            CurrentCombi = ClassCombinationsPerClass(classes).ClassCombi(combinr,:); % Get a combination
            % disp(["Current combinr: ",num2str(combinr)]);
            
            Accuracy_perm = zeros(NrPermutations,1);
     
            for PermutationNr = 1: NrPermutations
                %  disp(["Permutation ",num2str(PermutationNr)]);
                % disp(['=====Participant ',num2str(ParticipantNr),', ',num2str(classnr+1),'-class, task-combination: ',num2str(combinr),', permutation ',num2str(PermutationNr)]);
                disp(['=====Participant ',num2str(ParticipantNr),', ',num2str(classes),'-class, task-combination: ',num2str(combinr),', permutation ',num2str(PermutationNr)]);
                
                  accuracy_fold = zeros(TotalNrOfFolds,1); % Nr of combinations, number of classes and number of folds
                  Predictors = zeros(TotalNrOfFolds,params.NrRepeats*classes);
                  Trues = zeros(TotalNrOfFolds,params.NrRepeats*classes);
                for fold = 1:TotalNrOfFolds
                    %   disp(['=====Computing fold ',num2strç(fold),'...']);
                    %  disp(['Runs used for training: ',num2str(Folds(fold).TrainingRuns)]);
                    %  disp(['Runs used for testing: ',num2str(Folds(fold).TestingRun)]);
                   
                    
                    [accuracy_fold(fold),Predictors(fold,:),Trues(fold,:)] = new22_OPTCLA2_trainTestMulticlass(DataStructure,classes,CurrentCombi,Folds,fold,TaskLabels,Mask,performPermutationTest);
                  %  accuracy_fold(fold) = 4576; % For (fast) debugging 
          
                end
                
               Accuracy_perm(PermutationNr) = mean(accuracy_fold); % = one accuracy for each permutation
               
            end
            
            Accuracy_combiNr(:,combinr) = Accuracy_perm; % per permutation per mental task combi
            disp(['     TaskNr ', num2str(combinr),'(mean) = ', num2str(mean(Accuracy_perm))])
            Predictors_classes{classes, combinr} = Predictors;
            Trues_classes{classes, combinr} = Trues;

        end
        
         Accuracy_classes(:,:,classes) = Accuracy_combiNr; % permutation, mental task combi, class
    
         
      
        %Accuracy exists of participant nr, classnr, classcombinations, permutation nr
    end
    Accuracy(ParticipantNr,:,:,:) = Accuracy_classes; % participant, permutation, mental task combi, class
   
    if (PerformPermutationTest ==0)
        P(ParticipantNr).Results.MulticlassClassification = Accuracy_classes; %Accuracy
        P(ParticipantNr).Results.Predictors = Predictors_classes;
        P(ParticipantNr).Results.Trues = Trues_classes;
    else
        % perm_accuracy_multiclass_cv(PermutationNr,:,:,:) % Don't
        % save this  - it costs too much memory
      %  perm_accuracy_multiclass(:,:,:) = mean(Accuracy,4); % Averaged across folds
          perm_accuracy_multiclass = Accuracy; % Averaged across folds
       
        % % Store permutatio results in structure P.
      %  P(ParticipantNr).Permutations.permutations =  mean(Accuracy,4); % Averaged across folds
        P(ParticipantNr).Permutations.permutations =  Accuracy; % Averaged across folds
        
        % P(params.Participant).Permutations.permutations_individualFolds = perm_accuracy_multiclass_cv;
        % P(params.Participant).Permutations.pvalues = p;
    end
    
    
    save(['MainResults_Multiclass_',num2str(NrPermutations),'Perm_',str_participant,'_',datestr(now, '_dd-mm-yy')],'Accuracy');
    
end


% Count how many permutation outcomes are equal or bigger than the actual
% observed classification accuracy. For 100 permutations, with p = 0.05,
% only 5 instances or less can be equal or larger than the observed value.



beep on; beep
disp(['====Finished multiclass classification. Time passed: ',num2str(toc), ' seconds. In minutes: ',num2str(toc/60)]);

%

P = rmfield(P,'Data');
cd(params.SaveFolder)
filename = ['MultiClassResults_P05-P20',params.AnalysisType,datestr(now, '_dd-mm-yy')];
save(filename,'P'); % Save summarized accuracies for all participants (for later analyses)
save(['MultiClassResultsOneVariable_P05-P20_WithVMRandVTCmask',datestr(now,'_dd-mm-yy')],'Accuracy'); % Also save the variable where only the accuracy of all, participntas, classes and task combinations are stored.
%save(filename,'Results_cleaned'); % Save summarized accuracies for all participants (for later analyses)
disp(['=====Results saved in ',params.SaveFolder,'.']);

