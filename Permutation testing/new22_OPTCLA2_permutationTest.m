%% Permutation testing

function [perm_accuracy,perm_accuracy_cv,p] = OPTCLA2_permutationTest(P,params,Data)

% Get the observed classification accuracies
accuracies = P(params.Participant).Results(1).(params.AnalysisType)...
                .(params.ClassificationMethod).Mean; % I'm using mean now for the leave-one-run-out accuracies

perm_accuracy_cv = zeros(params.NrLocalizerRuns,params.NrPairs,params.NrPermutations);       
perm_accuracy = zeros(params.NrPairs,params.NrPermutations);

 Mask = OPTCLA2_ApplyMask(params,0,0); % T1 and t2 can be 0 because we're only using whole-brain (t1 and t2 are only needed for the NOI masked based on taskpair)

% Perform classifications with shuffled labels.
for PermutationNr = 1: params.NrPermutations
    disp(["Permutation ",num2str(PermutationNr)]);
    % Performing training and testing with shuffled labels
    
    [Folds] = CreateFolds(Data,params,0,1,0);  % Insert Data,params,k_folds,loro,randomize)
    [Accuracies] = LeaveOneRunOutClassification_OPTCLA2(params,Folds,Mask);  %AccuraciesSorted,StandardDev
    
    if (params.ClassificationMethod == 'LeaveOneRunOut')
        perm_accuracy_cv(:,:,PermutationNr) = Accuracies;
        perm_accuracy(:,PermutationNr) = mean(Accuracies);
    else
        perm_accuracy(:,PermutationNr) = Accuracies;
        
    end
end

% Count how many permutation outcomes are equal or bigger than the actual
% observed classification accuracy. For 100 permutations, with p = 0.05,
% only 5 instances or less can be equal or larger than the observed value.



temp = zeros(params.NrPairs,params.NrPermutations);
for i = 1:params.NrPairs % 28 pairs
    temp(i,:) = perm_accuracy(i,:) >= accuracies(i);
end
p_value = sum(temp,2)/params.NrPermutations;
Thres_0_05 = p_value(:,1)<=0.05;

if params.NrPermutations >= 1000
    Thres_0_01 = p(:,1)<=0.01; % These results are only valid if you permute a 1000 times or more.
    Thres_0_001 = p(:,1)<=0.001;
    p = table(p_value,Thres_0_05,Thres_0_01,Thres_0_001);
else
    p = table(p_value,Thres_0_05);
end

end