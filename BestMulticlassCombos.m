%% Get multi-class combinations


load('MentalTasks.mat');

load('ClassCombinationsPerClass.mat');

%load('MulticlassResults_CORRECT.mat');

cd([params.MainFolder,'Results']);
load('MultiClassResultsOneVariable_P05-P20_WithVMRandVTCmask_15-12-22.mat');



%% TWO-CLASS
clear ClassCombis
clear Accuracies
clear Accuracies_sorted
clear TopCombinations
clear otherway;

NrOfClasses = 2;
ClassCombis = ClassCombinationsPerClass(NrOfClasses).ClassCombi;

Accuracies = squeeze(MulticlassData(:,1:21,1));
Accuracies = mean(Accuracies)';
[Accuracies_sorted, ind_sorted] = sort(Accuracies,'descend');

ClassCombis_sorted = ClassCombis(ind_sorted,:)
length = size(ClassCombis,1)
for i = 1:length
    combi = ClassCombis_sorted(i,:);
    temp = [MentalTasks{combi(1)},'-',MentalTasks{combi(2)}];
    
    TopCombinations{i} = temp;
    for j = 1:NrOfClasses
        otherway{i,j} = MentalTasks{combi(j)};
    end
end
TopCombinations'
MulticlassTopCombos(NrOfClasses).TopCombinations = TopCombinations';
MulticlassTopCombos(NrOfClasses).TopCombis_tasksPerColumn = otherway;


%% THREE-CLASS
% I want the accuracies sorted from highest to lowest
NrOfClasses = 3;

clear ClassCombis
clear Accuracies
clear Accuracies_sorted
clear TopCombinations
clear otherway;

ClassCombis = ClassCombinationsPerClass(NrOfClasses).ClassCombi;

threeClassAccuracies = MulticlassData(:,:,2);
threeClassAccuracies_mean = mean(threeClassAccuracies);
[threeClassAccuracies_sorted, ind_sorted] = sort(threeClassAccuracies_mean,'descend')

threeClassCombis_sorted = ClassCombis(ind_sorted,:)
length = size(threeClassCombis_sorted,1)
for i = 1:length
    combi = threeClassCombis_sorted(i,:);
    temp = [MentalTasks{combi(1)},'-',MentalTasks{combi(2)},'-',MentalTasks{combi(3)}];
    TopCombinations{i} = temp;
    
    for j = 1:NrOfClasses
        otherway{i,j} = MentalTasks{combi(j)};
    end
end

TopCombinations = TopCombinations'
MulticlassTopCombos(NrOfClasses).TopCombinations = TopCombinations;
MulticlassTopCombos(NrOfClasses).TopCombis_tasksPerColumn = otherway;

% Sanity check re-indexing and sorting a matrix
% A = [1 2 3 ; 4 5 6 ; 7 8 9];
% idx = [2 3 1] ;
% B = A(idx,:)

%% FOUR-CLASS

clear ClassCombis
clear Accuracies
clear Accuracies_sorted
clear TopCombinations
clear otherway;

NrOfClasses = 4;
ClassCombis = ClassCombinationsPerClass(NrOfClasses).ClassCombi;

Accuracies = mean(MulticlassData(:,:,3));
[Accuracies_sorted, ind_sorted] = sort(Accuracies,'descend')

ClassCombis_sorted = ClassCombis(ind_sorted,:)
length = size(ClassCombis,1)
for i = 1:length
    combi = ClassCombis_sorted(i,:);
    temp = [MentalTasks{combi(1)},'-',MentalTasks{combi(2)},'-',MentalTasks{combi(3)},'-',MentalTasks{combi(4)}];
    TopCombinations{i} = temp;
    
    for j = 1:NrOfClasses
        otherway{i,j} = MentalTasks{combi(j)};
    end
end
TopCombinations'
MulticlassTopCombos(NrOfClasses).TopCombinations = TopCombinations';
MulticlassTopCombos(NrOfClasses).TopCombis_tasksPerColumn = otherway;

%% FIVE-CLASS
clear ClassCombis
clear Accuracies
clear Accuracies_sorted
clear TopCombinations
clear otherway;

NrOfClasses = 5;

ClassCombis = ClassCombinationsPerClass(NrOfClasses).ClassCombi;

Accuracies = mean(MulticlassData(:,:,4));
Accuracies = Accuracies(1:21);
[Accuracies_sorted, ind_sorted] = sort(Accuracies,'descend');

ClassCombis_sorted = ClassCombis(ind_sorted,:)
length = size(ClassCombis,1)
for i = 1:length
    combi = ClassCombis_sorted(i,:);
    temp = [MentalTasks{combi(1)},'-',MentalTasks{combi(2)},'-',MentalTasks{combi(3)},'-',MentalTasks{combi(4)},'-',MentalTasks{combi(5)}];
    TopCombinations{i} = temp;
    
    for j = 1:NrOfClasses
        otherway{i,j} = MentalTasks{combi(j)};
    end
end
TopCombinations'
MulticlassTopCombos(NrOfClasses).TopCombinations = TopCombinations';
MulticlassTopCombos(NrOfClasses).TopCombis_tasksPerColumn = otherway;

%% SIX-CLASS
clear ClassCombis
clear Accuracies
clear Accuracies_sorted
clear TopCombinations
clear otherway;

NrOfClasses=6;

ClassCombis = ClassCombinationsPerClass(NrOfClasses).ClassCombi;

Accuracies = mean(MulticlassData(:,:,5));
Accuracies = Accuracies(1:7);
[Accuracies_sorted, ind_sorted] = sort(Accuracies,'descend');

ClassCombis_sorted = ClassCombis(ind_sorted,:)
length = size(ClassCombis,1)
for i = 1:length
    combi = ClassCombis_sorted(i,:);
    temp = [MentalTasks{combi(1)},'-',MentalTasks{combi(2)},'-',MentalTasks{combi(3)},'-',MentalTasks{combi(4)},'-',MentalTasks{combi(5)},'-',MentalTasks{combi(6)}];
    TopCombinations{i} = temp;
    
    for j = 1:NrOfClasses
        otherway{i,j} = MentalTasks{combi(j)};
    end
end
TopCombinations'
MulticlassTopCombos(NrOfClasses).TopCombinations = TopCombinations';

MulticlassTopCombos(NrOfClasses).TopCombis_tasksPerColumn = otherway;

%% Frequency analysis

% Take the top 5
highest_n = 5; %  

T = zeros(7,6)

i = 1;
for class = 2:6
    
    data = MulticlassTopCombos(class).TopCombinations(1:highest_n,:);
    
    for taskNr = 1:7
        taskname = MentalTasks(taskNr);
        idx = strfind(data, taskname);
        taskFrequency(taskNr) = size(find(~cellfun(@isempty,idx')),2);
    end
    
    T(:,i) = taskFrequency'
    i = i+1;
end
classnames = {'2-class','3-class','4-class','5-class','6-class','Sum'}
T(:,end) = sum(T')
frequencyTable = array2table(T,'VariableNames',classnames,'RowNames',MentalTasks)


% Make figure



title = ['Mental task frequency of top 5 task combinations'];
C = categorical(MentalTasks,MentalTasks); % 2 times PairNames to avoid them being put in alphabetical order (weird Matlab quirk)
    
b = bar(C,T(:,end),'FaceColor','flat')

ax = gca
ax.YGrid = 'on';
set(gcf,'Color','w'); % set the figure background color to white.
set(findall(gcf, 'Type', 'text'), 'FontSize', 16,'FontName','SansSerif'); % Get a proper font and fontsize for the text
ytickformat('%,.0f')

% Define colors for each mental task (approximate RGB values based on the image)
TaskColours.MD   = [220 65  43]  / 255;  % Mental Drawing (Red-Orange)
TaskColours.MT   = [91  178 58]  / 255;  % Mental Talking (Green)
TaskColours.MC   = [200 82  144] / 255;  % Mental Calculation (Pink)
TaskColours.MS   = [239 191 70]  / 255;  % Mental Singing (Yellow-Gold)
TaskColours.MR   = [76 136 190] / 255;  % Mental Rotation (Blue)
TaskColours.SN   = [103 185 177] / 255;  % Spatial Navigation (Teal)
TaskColours.TacI = [136 99 66]  / 255;  % Tactile Imagery (Brown)


% % Add colour for eaceh mental task
b.CData(1,:) = TaskColours.MD
b.CData(2,:) = TaskColours.MT
b.CData(3,:) = TaskColours.MC
b.CData(4,:) = TaskColours.MS
b.CData(5,:) = TaskColours.MR
b.CData(6,:) = TaskColours.SN
b.CData(7,:) = TaskColours.TacI

% Make figure prettier
%PS = PLOT_STANDARDS(); % To be used for easier pretty figure making
%fig1_comps.fig = gcf;
%STANDARDIZE_FIGURE(fig1_comps);



    %% Make figures sorted

    % Get the data to be sorted
[sortedValues, sortIdx] = sort(T(:,end), 'descend'); % Sort in descending order

% Reorder mental task labels and colors based on sorting
sortedTasks = MentalTasks(sortIdx); % Reorder task names
sortedColors = [
    TaskColours.MD;  
    TaskColours.MT;  
    TaskColours.MC;  
    TaskColours.MS;  
    TaskColours.MR;  
    TaskColours.SN;  
    TaskColours.TacI  
]; 
sortedColors = sortedColors(sortIdx, :); % Reorder colors accordingly

% Create sorted bar graph
C_sorted = categorical(sortedTasks, sortedTasks); % Maintain correct order
b = bar(C_sorted, sortedValues, 'FaceColor', 'flat');

% Apply the correct colors to each bar
b.CData = sortedColors;


ax=get(gca,'xlabel')
set(ax, 'FontSize', 15, 'FontName', 'SansSerif'); 
ax=get(gca,'ylabel')
set(ax, 'FontSize', 15, 'FontName', 'SansSerif'); 

ax = gca
ax.YGrid = 'on';
set(gcf,'Color','w'); % set the figure background color to white.
set(findall(gcf, 'Type', 'text'), 'FontSize', 16,'FontName','SansSerif'); % Get a proper font and fontsize for the text
ytickformat('%,.0f')


   % Increase font size for tick labels
    ax = gca;
    ax.FontSize = 14; % Increases font size of tick labels
    ax.FontName = 'SansSerif'; % Set font type for tick labels

    set(gcf,'Color','w'); % set the figure background color to white.


      % Make the whole figure outline (axes box) thicker
    ax.LineWidth = 1; % Adjust thickness of figure border

ylabel('Frequency', 'FontSize', 15, 'FontName', 'SansSerif'); 
xlabel('Mental Task', 'FontSize', 15, 'FontName', 'SansSerif'); 
