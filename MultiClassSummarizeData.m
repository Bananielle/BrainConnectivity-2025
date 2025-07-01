%% Summarize data
    

    maxParticipantNr = max(ParticipantsAnalyzed); 
    Accuracy = squeeze(Accuracy);  % squeeze out 1 (is for the nr of permutations)
    MulticlassData = Accuracy(5:maxParticipantNr,:,2:7);% Always start from 5 because participant numbering starts with P05 (not P01, those were pilot data)
   %, Also remove the 1st class because there is no 1-class (only 2 to 7
    % class)
    
    class2 = squeeze(MulticlassData(:,1:21,1));
    class3 = squeeze(MulticlassData(:,1:35,2));
    class4 = squeeze(MulticlassData(:,1:35,3)); 
    class5 = squeeze(MulticlassData(:,1:21,4));
    class6 = squeeze(MulticlassData(:,1:7,5));
    class7 = squeeze(MulticlassData(:,1:1,6));
    
    
   % Mean accuracy per class
   clear all_classes_participant;
    for ParticipantNr = ParticipantsAnalyzed-4 %Participant-4 because I'm skipping the first 4 participants (they're pilot)
        all_classes_participant(ParticipantNr,:) = [mean(class2(ParticipantNr,:));...
            mean(class3(ParticipantNr,:));mean(class4(ParticipantNr,:));mean(class5(ParticipantNr,:));...
            mean(class6(ParticipantNr,:));mean(class7(ParticipantNr,:))];
    end
    clear all_classes_participant_SD;
    % Standard deviation
    stdPerClass = std(all_classes_participant);
    for ParticipantNr = ParticipantsAnalyzed-4 %Participant-4 because I'm skipping the first 4 participants (they're pilot)
        all_classes_participant_SD(ParticipantNr,:) = [std(class2(ParticipantNr,:));...
            std(class3(ParticipantNr,:));std(class4(ParticipantNr,:));std(class5(ParticipantNr,:));...
            std(class6(ParticipantNr,:));std(class7(ParticipantNr,:))];
    end
    
    % Add mean and std
    clear meanPerClass stdPerClass
    meanPerClass = mean(all_classes_participant)
    stdPerClass = std(all_classes_participant);
    
    all_classes_participant(end+1,:) = meanPerClass;
    all_classes_participant_SD(end+1,:) = stdPerClass;
    
    % Note that chance level decreases at each class:
    % 3-class = 33.3%
    % 4-class = 25.0%
    % 5-class = 20.0%
    % 6-class = 16.6%
    % 7-class = 14.3%
    
    
    chanceLevels = zeros(size(all_classes_participant));
    chanceLevels(:,1) = 0.50;
    chanceLevels(:,2) = 0.333;
    chanceLevels(:,3) = 0.25;
    chanceLevels(:,4) = 0.20;
    chanceLevels(:,5) = 0.166;
    chanceLevels(:,6) = 0.143;
    distanceFromChanceLevel = all_classes_participant - chanceLevels;
    %distanceFromChanceLevel = chanceLevels; % Just show theoretial chance level. More intuitive than distnace.
    
   