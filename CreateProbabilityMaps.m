%% Make probability maps out of the SVM weights



%% Make probability maps (separately for task 1 and 2)
taskpair = 1;

%cd([params.MainFolder,'SVMweights/DifferentlySorted/SVMweightMapsPerTaskPair/ProbabilityMaps_Matlab']);
% Probability maps made in BrainVoyager (for checking whether I did it
% correctly in Matlab later)
%temp = xff('BV_1_MD-MT__MT_ProbMap_svmWeights_P05-P20.vmp')
%exampleProbabilityMap_MT = temp.Map.VMPData(:);

% Now make my own for all taskpairs

cd([params.MainFolder,'SVMweights/DifferentlySorted/SVMweightMapsPerTaskPair/ProbabilityMaps_Matlab/Reference maps']);
temp = xff('TemplateMap_IndividualTrials_2maps.vmp');

datafolder = [params.MainFolder,'/SVMweights/DifferentlySorted/SVMweightMapsPerTaskPair'];
cd(datafolder);
FolderContent = dir(datafolder);

clear nrVoxelsAboveThreshold_task1;
clear nrVoxelsAboveThreshold_task2;

count = 1;
for taskpair = 1:params.NrPairs % For the 21 taskpairs
    cd(datafolder);
    
    for i = 1:size(FolderContent,1) % For the size of the folder
        
        if startsWith(FolderContent(i).name,[num2str(taskpair),'_']) == 1
            
            filename = FolderContent(i).name
            temp = xff(filename);
            data = temp.Map;
            
            for participant = 1:16
                % Catch which voxels have a SVM weight above the 2 or below the -2 threshold
                weightmap(participant,:) = data(participant).VMPData(:);
                aboveThreshold_task1(participant,:) = weightmap(participant,:) > 2;
                aboveThreshold_task2(participant,:) = weightmap(participant,:) < -2;
                
                % Count the number of voxels above the threshold
                nrVoxelsAboveThreshold_task1(participant,taskpair,:) = sum(aboveThreshold_task1(participant,:));
                nrVoxelsAboveThreshold_task2(participant,taskpair,:) = sum(aboveThreshold_task2(participant,:));
                
            end
            
            probabilitymap_task1 = (sum(aboveThreshold_task1)/16)*100;
            probabilitymap_task2 = (sum(aboveThreshold_task2)/16)*100;
            
            
            % Save as VMP map
            probabilitymap_task1_reshaped = reshape(probabilitymap_task1,[58,40,46]);
            probabilitymap_task1_reshaped = single(probabilitymap_task1_reshaped);
            
            probabilitymap_task2_reshaped = reshape(probabilitymap_task2,[58,40,46]);
            probabilitymap_task2_reshaped = single(probabilitymap_task2_reshaped);
            
            %
            cd([params.MainFolder,'/SVMweights/DifferentlySorted/SVMweightMapsPerTaskPair/ProbabilityMaps_Matlab/Reference maps']);
            temp = xff('TemplateMap_IndividualTrials_2maps.vmp');
            
            
            temp.Map(count).VMPData = probabilitymap_task1_reshaped;
            temp.Map(count+1).VMPData = probabilitymap_task2_reshaped;
            temp.Map(count).Name = [num2str(taskpair),'_',MentalTaskpairs{taskpair},'_Task1_ProbabilityMap_svmweights_matlab'];
            temp.Map(count+1).Name = [num2str(taskpair),'_Task2_ProbabilityMap_svmweights_matlab'];
            
            temp.Map(count).Type = 16;
            temp.Map(count).LowerThreshold = 25;
            temp.Map(count).UpperThreshold = 100;
            temp.Map(count).RGBLowerThreshPos = [0 0 255];
            temp.Map(count).RGBUpperThreshPos = [255 255 0];
            temp.Map(count).RGBLowerThreshNeg = [100 0 0];
            temp.Map(count).RGBUpperThreshNeg = [100 0 0];
            temp.Map(count).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Green.olt';
            temp.Map(count).ClusterSize = 4;
            temp.Map(count).EnableClusterCheck = 1;
            temp.Map(count).ShowPositiveNegativeFlag = 1;
            temp.Map(count).BonferroniValue = 0;
            
            temp.Map(count+1).Type = 16;
            temp.Map(count+1).LowerThreshold = 25;
            temp.Map(count+1).UpperThreshold = 100;
            temp.Map(count+1).RGBLowerThreshPos = [0 0 255];
            temp.Map(count+1).RGBUpperThreshPos = [255 255 0];
            temp.Map(count+1).RGBLowerThreshNeg = [100 0 0];
            temp.Map(count+1).RGBUpperThreshNeg = [100 0 0];
            temp.Map(count+1).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Cyan.olt';
            temp.Map(count+1).ClusterSize = 4;
            temp.Map(count+1).EnableClusterCheck = 1;
            temp.Map(count+1).ShowPositiveNegativeFlag = 1;
            temp.Map(count+1).BonferroniValue = 0;
            
            cd([params.MainFolder,'/SVMweights/DifferentlySorted/SVMweightMapsPerTaskPair/ProbabilityMaps_Matlab/']);
            filename = [num2str(taskpair),'_',MentalTaskpairs{taskpair},'_ProbabiltyMaps_svmweights_matlab.vmp'];
            
            % temp.saveAs(filename);
            
            %disp(['Saved ',filename]);
            
            
        end
    end
    % count = count+2;
end


%% Plot nr of voxels above SVM weight threshold
mean_nrVoxelsAboveThreshold_task1 = mean(nrVoxelsAboveThreshold_task1);
mean_nrVoxelsAboveThreshold_task2 = mean(nrVoxelsAboveThreshold_task2);

VoxelsAboveTreshold_sumOfBothTasks = mean_nrVoxelsAboveThreshold_task1 + mean_nrVoxelsAboveThreshold_task2

difference_task1and2 = mean_nrVoxelsAboveThreshold_task1 - mean_nrVoxelsAboveThreshold_task2;


%% Scatter plot between accuracy and nr of voxels above SVM weight threshold
scatter(meanAccuracyPerTaskPair,VoxelsAboveTreshold_sumOfBothTasks,100,'filled')
% Put figure in standard pretty layout
ylabel('Mean nr of voxels above SVM weigth threshold');
xlabel('Mean classification accuracy');
title('Accuracy vs number of voxels above SVM weight threshold')
fig1_comps.fig = gcf;
STANDARDIZE_FIGURE(fig1_comps); 

% No significant correlation found between accuracy and nr of voxels above SVM weight threshold
[rho,pval] = corr(meanAccuracyPerTaskPair',VoxelsAboveTreshold_sumOfBothTasks')

%% Make fancy plot for nr of voxels
PS.Blue1 = [133, 193, 233]./255;
PS.Blue2 = [93, 173, 226]./255;
PS.Blue3 = [52, 152, 219]./255;
PS.Blue4 = [40, 116, 166]./255;
PS.Blue5 = [27, 79, 114]./255;

%data = difference_task1and2;
data = VoxelsAboveTreshold_sumOfBothTasks;

mainfigure = figure(1);
Title = ['Nr of voxels above SVM weight threshold of 2'];
C = categorical(PairNames,PairNames); % 2 times PairNames to avoid them being put in alphabetical order (weird Matlab quirk)
b= bar(C,data,0.5,'FaceColor',PS.Blue3);
hold on
% if mean(StandardDev) ~= 0 %% Add error bars for the sd if StandardDev isn't empty.
%     errorbar(Accuracies(:,1),StandardDev,'LineWidth',0.6,'LineStyle','none','Color','k');
% end
hold off

% for i = 1:length(idx) % For each taskpair containing the highest accuracy, change the colour of its bar.
%    b.CData(idx(i),:) = [112/255 219/255 147/255];
% end
maxNrOfVoxels = max(VoxelsAboveTreshold_sumOfBothTasks);
ylim([10000 maxNrOfVoxels]); % Always display classification accuracies from 0.30 to 1.00.
ylabel('Nr of voxels above threshold');
xlabel('Mental task pair');
ytickformat('%.2f'); % Sets the y-axis ticks to 2 decimal places
set(gcf,'Color','w'); % set the figure background color to white.
set(findall(gcf, 'Type', 'text'), 'FontSize', 12,'FontName','Helvetica Neue'); % Get a proper font and fontsize for the text.
title(Title);
set(gca, 'YGrid', 'on', 'XGrid', 'off')

%% Creating probability maps per task
% This will separate the SVM weights for eaech taskpair (21 in total) per task (7 in total) So
% positive values for task 1 and negative values for task 2, meaning that the values
% for task 2 need to be inverted (so that they also become positive). Then
% all SVM weights are sorted separately by task, so that you'll have 6 maps
% per task. These can then be visualized in BrainVoyager.

datafolder = [params.MainFolder,'/SVMweights/DifferentlySorted/SVMweightMapsPerTaskPair/ProbabilityMaps_Matlab'];
cd(datafolder);
FolderContent = dir(datafolder);


for tasknr = 1:params.NrTasks
    clear TaskNames;
    clear data;
    count =1;
    mentalTask = MentalTasks{tasknr};
    for i = 1:size(FolderContent,1) % For the size of the folder
        
        % Filename always has a e.g., 'MD-MT' format, so the task before
        % the '-' will the the first task with positive values and the task
        % after the '-' will contain negative values.
        if contains(FolderContent(i).name,[mentalTask,'-']) == 1 % If task name starts task has positive values
            
            filename = FolderContent(i).name;
            temp = xff(filename);
            TaskNames{count} = [mentalTask,'_from_',FolderContent(i).name,'_ProbabilityMap_svmweights_matlab'];
            disp([mentalTask,' ',num2str(count),'_',TaskNames{count}]);
            data(count) = temp.Map(1); % So take first map
            count = count+1;
        end
        
        if contains(FolderContent(i).name,['-',mentalTask]) == 1  % Means task has negative values
            filename = FolderContent(i).name;
            temp = xff(filename);
            TaskNames{count} = [mentalTask,'_from_',FolderContent(i).name,'_ProbabilityMap_svmweights_matlab'];
            disp([mentalTask,' ',num2str(count),'_',TaskNames{count}]);
            data(count) = temp.Map(2); % So take second map
            
            data(count);
            
            count = count+1;
            
            
        end
        
        
    end
    
    
    
    
    
    % Put them in one vmp
    cd([params.MainFolder,'/SVMweights/DifferentlySorted/SVMweightMapsPerTaskPair/ProbabilityMaps_Matlab/Reference maps']);
    temp = xff('TemplateMap_probabilitymaps_6maps.vmp');
    
    for i = 1:6
        
        temp.Map(i).VMPData = data(i).VMPData;
        temp.Map(i).Name = TaskNames{i};
        %temp.Map(i).Name = [mentalTask,'_ProbabilityMap_svmweights_matlab'];
        temp.Map(i).Type = 16;
        temp.Map(i).LowerThreshold = 40;
        temp.Map(i).UpperThreshold = 100;
        temp.Map(i).RGBLowerThreshPos = [0 0 255];
        temp.Map(i).RGBUpperThreshPos = [255 255 0];
        temp.Map(i).RGBLowerThreshNeg = [100 0 0];
        temp.Map(i).RGBUpperThreshNeg = [100 0 0];
        temp.Map(i).ClusterSize = 5;
        temp.Map(i).EnableClusterCheck = 1;
        temp.Map(i).ShowPositiveNegativeFlag = 1;
        
        temp.Map(i).BonferroniValue = 0;
        
        % Give them different colours based on the task
        if tasknr == 1 % MD
            %temp.Map(i).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Red.olt';
            temp.Map(i).LUTName =  [datafolder,'/Probability map colour schemes/ProbMap_Red.olt'];
        end
        
        if tasknr == 2 % MT
            temp.Map(i).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Green.olt';
            % temp.Map(i).LUTName =  [datafolder,'/Probability map colour schemes/ProbMap_Red.olt'];
        end
        
        if tasknr == 3 % MC
            %temp.Map(i).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Red.olt';
            temp.Map(i).LUTName =  [datafolder,'/Probability map colour schemes/ProbMap_Pink.olt'];
        end
        
        if tasknr == 4 % MS
            %temp.Map(i).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Red.olt';
            temp.Map(i).LUTName =  [datafolder,'/Probability map colour schemes/ProbMap_Yellow.olt'];
        end
        
        if tasknr == 5 % MR
            temp.Map(i).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Blue.olt';
            % temp.Map(i).LUTName =  [datafolder,'/Probability map colour schemes/ProbMap_Red.olt'];
        end
        
        if tasknr == 6 % SN
            %temp.Map(i).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Red.olt';
            temp.Map(i).LUTName =  [datafolder,'/Probability map colour schemes/ProbMap_Azure.olt'];
        end
        
        if tasknr == 7 % TacI
            temp.Map(i).LUTName =  '/Users/danielle/Documents/BrainVoyager/MapLUTs/ProbMap_Beige.olt';
            % temp.Map(i).LUTName =  [datafolder,'/Probability map colour schemes/ProbMap_Brown.olt'];
        end
        
        
    end
    % temp.NrOfMaps = 6;
    filename = [mentalTask,'_ProbabiltyMaps_svmweights_matlab.vmp'];
    cd(datafolder);
    temp.saveAs(filename);
    
end

disp('Finished.')