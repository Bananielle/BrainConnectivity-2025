%% Create a table of 2-class accuracies

cd([params.MainFolder,'Results'])

load('PairNames.mat');
ParticipantsAnalyzed =ParticipantsAnalyzed; %Otherwise Matlab complains about amibuguity at line 11.

% Calculate averages of accuracies
temp = squeeze(MainResultsCV);
meanAccrossFolds = squeeze(mean(temp,2))
meanAccrossFolds = meanAccrossFolds(5:ParticipantsAnalyzed(end),:,:)
meanAcrossParticipants = (mean(meanAccrossFolds))
meanAcrossTasks = (mean(meanAccrossFolds,2))
stdPerParticipant = std(meanAccrossFolds);
meanAccuracyCV = (mean(meanAcrossParticipants))

% Add mean to main results
meanAccuracyPerTaskPair = mean(meanAccrossFolds)
EndResults = [meanAccrossFolds;meanAccuracyPerTaskPair]
meanPerParticipant_andmean = mean(EndResults,2);
%EndResults = [EndResults,meanPerParticipant_andmean]
stdPerTaskPair_andmean = std(EndResults,1);
EndResults = [EndResults;stdPerTaskPair_andmean];
% Add permutation results
EndResults = [EndResults;permutationValues_withoutmean'];



ParticipantsAnalyzed_str = string(ParticipantsAnalyzed)
ParticipantsAnalyzed_str(1,size(ParticipantsAnalyzed_str,2)+1) = 'Mean';
ParticipantsAnalyzed_str(1,size(ParticipantsAnalyzed_str,2)+1) = 'SD';
ParticipantsAnalyzed_str(1,size(ParticipantsAnalyzed_str,2)+1) = 'Percentage p<0.05 ';



% Make table out of it
Results_cleaned = array2table(EndResults','VariableNames',ParticipantsAnalyzed_str,'RowNames',PairNames)