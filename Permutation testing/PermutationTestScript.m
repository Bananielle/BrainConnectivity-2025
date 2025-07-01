%% Permutation test

disp(['=====Starting permutation tests']);
tic; % Start timer
cd(params.MainFolder);
params.Analysis.PerformPermutationTest = 1;
params.NrPermutations = 100;

for ParticipantNr = ParticipantsAnalyzed
    
    cd(params.MainFolder)
    params.Participant = ParticipantNr;
    params.str_participant = ['P',num2str(ParticipantNr,'%02.f')]; % Makes sure the participant string number alwasy contains 2 digits.
    %  Data.LocalizerData = P(ParticipantNr).Data.LocalizerData; % Get the data for current participant
    
    % Compare the permuted accuracies with observed accuracy
    [perm_accuracy,perm_accuracy_cv,p] = OPTCLA2_permutationTest(P,params,P(ParticipantNr).Data.LocalizerData);
    
    % % Store results in structure P.
    P(params.Participant).Permutations.permutations = perm_accuracy;
    P(params.Participant).Permutations.permutations_individualFolds = perm_accuracy_cv;
    P(params.Participant).Permutations.pvalues = p;
    
    %             % Show distribution
    %             figure(ParticipantNr)
    %             hist(perm_accuracy(:)) % Incorrect. Take individual taskpair accuracies.
    %             xlim([0 1])
    %             ylabel('Frequency');
    %             xlabel('Accuracy');
    %             title('Null-distribution after permutation testing')
    %
    %         boxplot(perm_accuracy(:))
    %         ylim([0 1])
    %         ylabel('Accuracy');
    %         title('Null-distribution after permutation testing')
    
    
    
    
end
beep on; beep % Make a sound when done.
time_perm = toc/60; %
display(['=====Finished permutation testing. Time of computation (in minutes): ',num2str(time_perm)]);


