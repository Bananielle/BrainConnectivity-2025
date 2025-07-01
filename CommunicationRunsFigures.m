%% Make BCI figure - Subject-driven vs data-driven tasks

bci_data = [
    0.625  0.750;
    0.844  0.938;
    0.656  0.969;
    1.000  1.000;
    0.563  0.844;
    0.844  0.563;
    1.000  0.875;
    0.781  1.000;
    0.938  0.813;
    0.875  0.750;
    1.000  1.000;
    0.840  0.719;
    0.531  0.625;
    0.810  0.830 % last one is the mean (13 participants)
];

std1 = 0.14
std2 = 0.16


b = bar(bci_data,'grouped')


% Set colors (adjust RGB values to match the image)
b(1).FaceColor = [1 0.8 0.6]; % Light orange for "Subject-driven task pair S2"
b(2).FaceColor = [1 0.4 0.4]; % Red for "Data-driven task pair S2"

% Adjust transparency if needed
b(1).FaceAlpha = 0.8;
b(2).FaceAlpha = 1;

% Add legend
legend({'Subject-driven tasks S2', 'Data-driven tasks S2'}, ...
       'Location', 'northoutside', 'Orientation', 'horizontal', 'FontSize', 14);


% Change title and axis labels and its position
hAx=gca;
heightOfYAxis = hAx.YLim(2)
gcf
%title('Accuracies for subject-driven and data-driven mental-task pairs','Position',[11 heightOfYAxis*1.1])
ylabel('Accuracy','Position',[-1 heightOfYAxis/2], 'FontName', 'SansSerif'); 
xlabel('Subject','Position',[11 -0.3], 'FontName', 'SansSerif'); 


% Manuall change x-axis tick labels
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14]); % Set specific tick positions
%xticklabels({'1', '2', '4', '6', '7', '8', '9', '10', '11', '12', '13', '14', '16', 'Mean'}); % Custom labels
xticklabels({'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', 'Mean'}); % Custom labels

% Get bar positions
xPositions = b(1).XEndPoints; % Get x-coordinates for first bar group
xPositions2 = b(2).XEndPoints; % Get x-coordinates for second bar group

% Get bar heights
yHeights = b(1).YData; % Heights of first bars
yHeights2 = b(2).YData; % Heights of second bars


% Define the subjects where asterisks should be placed
subjects_with_asterisks_S1 = [2,4,6,7,8,9,10,11,12]; % S1 (Orange bars)
subjects_with_asterisks_S2 = [1,2,3,4,5,7,8,9,10,11,12];  % S2 (Pink bars)

clear length
% Add asterisks above selected bars (for S1)
for i = 1:length(subjects_with_asterisks_S1)
    subject_idx = subjects_with_asterisks_S1(i);
    text(xPositions(subject_idx), yHeights(subject_idx) + 0.01, '*', ...
         'FontSize', 18, 'HorizontalAlignment', 'center');
end

% Add asterisks above selected bars (for S2)
for i = 1:length(subjects_with_asterisks_S2)
    subject_idx = subjects_with_asterisks_S2(i);
    text(xPositions2(subject_idx), yHeights2(subject_idx) + 0.01, '*', ...
         'FontSize', 18, 'HorizontalAlignment', 'center');
end

% Error bar values for mean (Condition 1 and 2)
xErrorBar1 = xPositions(end); % X-position of mean for Condition 1
xErrorBar2 = xPositions2(end); % X-position of mean for Condition 2
yErrorBar1 = yHeights(end); % Y-position of mean for Condition 1
yErrorBar2 = yHeights2(end); % Y-position of mean for Condition 2

% Define error values
lowerError1 = std1; upperError1 = std2; % Condition 1 (subject driven)
lowerError2 = std1; upperError2 = std2; % Condition 2 (data-driven)

% Add separate error bars
hold on;
e1 = errorbar(xErrorBar1, yErrorBar1, lowerError1, upperError1, 'k', 'CapSize', 10, 'LineWidth', 1.5); % Condition 1
e2 = errorbar(xErrorBar2, yErrorBar2, lowerError2, upperError2, 'k', 'CapSize', 10, 'LineWidth', 1.5); % Condition 2
hold off;

% Remove error bars from legend
set(get(get(e1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
set(get(get(e2, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');


set(gcf, 'Color', 'w'); % Set figure background to white

    % Grid and minor tweaks
grid on;
ax = gca;
ax.XGrid = 'off'; % Disable vertical grid
ax.YGrid = 'on';  % Keep horizontal grid
ax.XMinorGrid = 'off';  % Disable minor ticks/grid on x-axis
box on;

% Put figure in standard pretty layout
%fig_comps.fig = gcf;
%STANDARDIZE_FIGURE(fig_comps); 

% Set x and y label size
h=get(gca,'xlabel')
set(h, 'FontSize', 15, 'FontName', 'SansSerif'); 
h=get(gca,'ylabel')
set(h, 'FontSize', 15, 'FontName', 'SansSerif'); 

% Add legend
legend({'Subject-driven tasks S2', 'Data-driven tasks S2'}, ...
       'Location', 'northoutside', 'Orientation', 'horizontal', 'FontSize', 14,'FontName', 'SansSerif');


% ADDING THE SUBJECT- AND DATA-DRIVEN TASKPAIRS LABELS
% Define subject-driven and data-driven task pairs
task_pairs_subject_driven = {
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 1 (MD-SN)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 2 (MD-SN)
    '\color[rgb]{0.0, 0.5, 0.0}MT-\color[rgb]{0.0, 0.0, 0.55}MR',  % Subject 3 (MT-MR)
    '\color[rgb]{0.55, 0.27, 0.07}TacI-\color[rgb]{0.0, 0.8, 0.8}SN', % Subject 4 (TacI-SN)
    '\color[rgb]{1.0, 0.5, 0.0}MS-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 5 (MS-SN)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 6 (MD-MT)
    '\color[rgb]{0.0, 0.8, 0.8}SN-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 7 (SN-MT)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 8 (MD-MT)
    '\color[rgb]{0.55, 0.0, 0.55}MC-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 9 (MC-MT)
    '\color[rgb]{0.55, 0.0, 0.55}MC-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 10 (MC-SN)
    '\color[rgb]{0.0, 0.5, 0.0}MT-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 11 (MT-SN)
    '\color[rgb]{0.0, 0.0, 0.55}MR-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 12 (MR-MT)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{1.0, 0.5, 0.0}MS'   % Subject 13 (MD-MS)
};

task_pairs_data_driven = {
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.55, 0.0, 0.55}MC',  % Subject 1 (MD-MC)
    '\color[rgb]{1.0, 0.5, 0.0}MS-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 2 (MS-SN)
    '\color[rgb]{1.0, 0.5, 0.0}MS-\color[rgb]{0.0, 0.0, 0.55}MR',  % Subject 3 (MS-MR)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.55, 0.0, 0.55}MC',  % Subject 4 (MD-MC)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.55, 0.0, 0.55}MC',  % Subject 5 (MD-MC)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.55, 0.0, 0.55}MC',  % Subject 6 (MD-MC)
    '\color[rgb]{0.55, 0.0, 0.55}MC-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 7 (MC-SN)
    '\color[rgb]{1.0, 0.5, 0.0}MS-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 8 (MS-SN)
    '\color[rgb]{0.55, 0.0, 0.55}MC-\color[rgb]{1.0, 0.5, 0.0}MS',  % Subject 9 (MC-MS)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{1.0, 0.5, 0.0}MS',  % Subject 10 (MD-MS)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.55, 0.0, 0.55}MC',  % Subject 11 (MD-MC)
    '\color[rgb]{0.0, 0.5, 0.0}MT-\color[rgb]{0.55, 0.0, 0.55}MC',  % Subject 12 (MT-MC)
    '\color[rgb]{0.0, 0.0, 0.55}MR-\color[rgb]{0.55, 0.27, 0.07}TacI'   % Subject 13 (MR-TacI)
};

% Add labels for subject-driven and data-driven
yOffsetTasks = -0.10
text(-0.5, yOffsetTasks, 'Subject-driven tasks:', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'right', 'Interpreter', 'tex','FontName', 'SansSerif');

yOffsetData = -0.18
text(-0.5, yOffsetData, 'Data-driven tasks:', 'FontSize', 12, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'right', 'Interpreter', 'tex','FontName', 'SansSerif');

% Add subject-driven task pairs below bars
for i = 1:length(task_pairs_subject_driven)
    text(i, yOffsetTasks, task_pairs_subject_driven{i}, 'FontSize', 12, ...
         'HorizontalAlignment', 'center', 'Interpreter', 'tex','FontName', 'SansSerif');
end

% Add data-driven task pairs below bars
for i = 1:length(task_pairs_data_driven)
    text(i, yOffsetData, task_pairs_data_driven{i}, 'FontSize', 12, ...
         'HorizontalAlignment', 'center', 'Interpreter', 'tex','FontName', 'SansSerif');
end

        % Make the whole figure outline (axes box) thicker
    ax.LineWidth = 1; % Adjust thickness of figure border
 

       % Increase font size for tick labels
    ax = gca;
    ax.FontSize = 14; % Increases font size of tick labels
    ax.FontName = 'SansSerif'; % Set font type for tick labels


    

%% Make BCI figure 2 - Subject-driven tasks S1 vs Subjectdriven tasks S2 

bci_data = [
    1.000  0.963;
    0.813  1.000;
    0.563  0.563;
    1.000  0.844;
    0.563  1.000;
    0.938  0.781;
    1.000  0.875;
    1.000  0.844;
    1.000  0.840;
    0.880  0.860 % last one is the mean (9 participants)
];

std1 = 0.19
std2 = 0.13


b = bar(bci_data,'grouped')


% Set colors (adjust RGB values to match the image)
b(1).FaceColor = [1.0, 0.87, 0.80]; % Approximate Light Pink/Beige for "Subject-driven task pair S1"
b(2).FaceColor = [1 0.8 0.6]; % Light orange for "Subject-driven task pair S2"

% Adjust transparency if needed
b(1).FaceAlpha = 0.8;
b(2).FaceAlpha = 1;


% Change title and axis labels and its position
hAx=gca;
heightOfYAxis = hAx.YLim(2)
gcf
%title('Accuracies for subject-driven and data-driven mental-task pairs','Position',[11 heightOfYAxis*1.1])
ylabel('Accuracy','Position',[-1 heightOfYAxis/2]);
xlabel('Subject','Position',[11 -0.3]);

% Add legend
legend({'Subject-driven tasks S1', 'Subject-driven tasks S2'}, ...
       'Location', 'northoutside', 'Orientation', 'horizontal', 'FontSize', 14);

% Manuall change x-axis tick labels
xticks([1 2 3 4 5 6 7 8 9 10]); % Set specific tick positions
xticklabels({'1', '2', '3', '4', '5', '6', '7', '8', '9', 'Mean'}); % Custom labels

% Get bar positions
xPositions = b(1).XEndPoints; % Get x-coordinates for first bar group
xPositions2 = b(2).XEndPoints; % Get x-coordinates for second bar group

% Get bar heights
yHeights = b(1).YData; % Heights of first bars
yHeights2 = b(2).YData; % Heights of second bars

% Define the subjects where asterisks should be placed
subjects_with_asterisks_S1 = [1, 2, 4,6,7,8,9]; % S1 (Orange bars)
subjects_with_asterisks_S2 = [1, 2, 4, 5, 6, 7, 8, 9];  % S2 (Pink bars)

% Add asterisks above selected bars (for S1)
for i = 1:length(subjects_with_asterisks_S1)
    subject_idx = subjects_with_asterisks_S1(i);
    text(xPositions(subject_idx), yHeights(subject_idx) + 0.01, '*', ...
         'FontSize', 18, 'HorizontalAlignment', 'center');
end

% Add asterisks above selected bars (for S2)
for i = 1:length(subjects_with_asterisks_S2)
    subject_idx = subjects_with_asterisks_S2(i);
    text(xPositions2(subject_idx), yHeights2(subject_idx) + 0.01, '*', ...
         'FontSize', 18, 'HorizontalAlignment', 'center');
end


% Error bar values for mean (Condition 1 and 2)
xErrorBar1 = xPositions(end); % X-position of mean for Condition 1
xErrorBar2 = xPositions2(end); % X-position of mean for Condition 2
yErrorBar1 = yHeights(end); % Y-position of mean for Condition 1
yErrorBar2 = yHeights2(end); % Y-position of mean for Condition 2

% Define error values
lowerError1 = std1; upperError1 = std2; % Condition 1 (subject driven)
lowerError2 = std1; upperError2 = std2; % Condition 2 (data-driven)

% Add separate error bars
hold on;
e1 = errorbar(xErrorBar1, yErrorBar1, lowerError1, upperError1, 'k', 'CapSize', 10, 'LineWidth', 1.5); % Condition 1
e2 = errorbar(xErrorBar2, yErrorBar2, lowerError2, upperError2, 'k', 'CapSize', 10, 'LineWidth', 1.5); % Condition 2
hold off;

% Remove error bars from legend
set(get(get(e1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
set(get(get(e2, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');

% Grid and minor tweaks
grid on;
ax = gca;
ax.XGrid = 'off'; % Disable vertical grid
ax.YGrid = 'on';  % Keep horizontal grid
ax.XMinorGrid = 'off';  % Disable minor ticks/grid on x-axis
box on;

set(gcf, 'Color', 'w'); % Set figure background to white

% Put figure in standard pretty layout
%fig_comps.fig = gcf;
%STANDARDIZE_FIGURE(fig_comps); 

% Set x and y label size
h=get(gca,'xlabel')
set(h, 'FontSize', 15,'FontName','SansSerif') 
h=get(gca,'ylabel')
set(h, 'FontSize', 15,'FontName','SansSerif') 

% Add legend
legend({'Subject-driven tasks S1', 'Subject-driven tasks S2'}, ...
       'Location', 'northoutside', 'Orientation', 'horizontal', 'FontSize', 14, 'FontName','SansSerif');

% ADDING THE SUBJECT_DRIVEN TASKPAIRS
% Define task pairs for each subject
task_pairs = {
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{1.0, 0.5, 0.0}MS',  % Subject 1 (MD-MS)
    '\color[rgb]{0.55, 0.27, 0.07}TacI-\color[rgb]{0.0, 0.8, 0.8}SN', % Subject 2 (TacI-SN)
    '\color[rgb]{1.0, 0.5, 0.0}MS-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 3 (MS-SN)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 4 (MD-MT)
    '\color[rgb]{0.0, 0.8, 0.8}SN-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 5 (SN-MT)
    '\color[rgb]{1.0, 0.0, 0.0}MD-\color[rgb]{0.0, 0.5, 0.0}MT',  % Subject 6 (MD-MT)
    '\color[rgb]{0.55, 0.0, 0.55}MC-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 7 (MC-SN)
    '\color[rgb]{0.0, 0.5, 0.0}MT-\color[rgb]{0.0, 0.8, 0.8}SN',  % Subject 8 (MT-SN)
    '\color[rgb]{0.0, 0.0, 0.55}MR-\color[rgb]{0.0, 0.5, 0.0}MT'  % Subject 9 (MR-MT)
};

% Add task pair labels below bars
yOffset = -0.08;  % Adjust vertical position of text labels
for i = 1:length(task_pairs)
    if ~isempty(task_pairs{i})
        text(i, yOffset, task_pairs{i}, 'FontSize', 14,'FontName','SansSerif', ...
             'HorizontalAlignment', 'center', 'Interpreter', 'tex');
    end
end

        % Make the whole figure outline (axes box) thicker
    ax.LineWidth = 1; % Adjust thickness of figure border
 

       % Increase font size for tick labels
    ax = gca;
    ax.FontSize = 14; % Increases font size of tick labels
    ax.FontName = 'SansSerif'; % Set font type for tick labels

     ylim([0.0 1]);



     % ADDING DAY BETWEEN SESSIONS

% Define the days between sessions
days_between_sessions = [7, 338, 232, 218, 235, 338, 277, 277, 147];

% Define the y-position for text labels (adjust as needed)
yOffsetDays = -0.1; % Adjust vertical position for "Days between sessions"
yOffsetTasks = -0.2; % Adjust vertical position for "Subject-driven tasks"

% Add the bold label "Days between sessions" on the left
text(0.3, yOffsetDays, '\bf{Days between sessions}', ...
     'FontSize', 12, 'HorizontalAlignment', 'right', 'FontName', 'SansSerif', 'Interpreter', 'tex');

% Add the bold label "Subject-driven tasks" on the left
text(0.3, yOffsetTasks, '\bf{Subject-driven tasks}', ...
     'FontSize', 12, 'HorizontalAlignment', 'right', 'FontName', 'SansSerif', 'Interpreter', 'tex');

% Add text labels for the number of days below each subject's bar
for i = 1:length(days_between_sessions)
    text(i, yOffsetDays, sprintf('%d', days_between_sessions(i)), ...
         'FontSize', 12, 'HorizontalAlignment', 'center', 'FontName', 'SansSerif');
end





     %% Statistiscal tests

     bci_data_subject_subject = [
    1.000  0.963;
    0.813  1.000;
    0.563  0.563;
    1.000  0.844;
    0.563  1.000;
    0.938  0.781;
    1.000  0.875;
    1.000  0.844;
    1.000  0.840;]

     condition1 = bci_data_subject_subject(:,1);
     condition2 = bci_data_subject_subject(:,2);

   

     % Perform a paired t-test
[h, p, ci, stats] = ttest(condition1, condition2);

% Display results
disp('Paired t-test results:');
disp(['t-value: ', num2str(stats.tstat)]);
disp(['Degrees of freedom: ', num2str(stats.df)]);
disp(['p-value: ', num2str(p)]);
disp(['Mean of Condition 1: ', num2str(mean(condition1))]);
disp(['Mean of Condition 2: ', num2str(mean(condition2))]);
disp(['Standard deviation of differences: ', num2str(stats.sd)]);

% Correlation with days between session

days_between_session = [7,338,232,218,235,338,277,277,147]'
diff_condition1_condition2 = condition1-condition2

[r,p] = corr(days_between_session,diff_condition1_condition2, 'Type', 'Spearman')