%% Greate bar graph (unsorted)
mainfigure = figure(1);
Title = ['Leave-one-run-out cross-validation (with whole functional volume mask)'];
CreateBargraph(PairNames,mean(EndResults)',stdPerTaskPair_andmean',Title,PairNames,0);

% Sort table from highest to lowest
Results_sorted = sortrows(Results_cleaned,size(Results_cleaned,2)-2,'descend') % -2 because otherwise you get the SD
meanOfTaskPairs_sorted = table2array(Results_sorted(:,end-2)); % also here -2
meanOfTaskPairs_sorted_withMean = [meanOfTaskPairs_sorted;mean(meanAccuracyPerTaskPair)]

permutationValues = table2array(Results_sorted(:,end))

stdOfTaksPairs_sorted = table2array(Results_sorted(:,end-1)); % -1 to get the std
stdOfTaksPairs_sorted_withMean = [stdOfTaksPairs_sorted;std(meanAccuracyPerTaskPair)];
PairNames_sorted = Results_sorted.Properties.RowNames;
PairNames_sorted{end+1} = 'Mean';

%% Greate bar graph (sorted)
figure(1);
%Title = ['Leave-one-run-out cross-validation (no feature selection)'];
CreateBargraph(params,meanOfTaskPairs_sorted_withMean,stdOfTaksPairs_sorted_withMean,Title,PairNames_sorted,permutationValues);

% Define the new color (from your image)
newBarColor = [168 196 188] / 255; % Approximate light teal/blue

% Find all bar objects in the current figure
bars = findobj(gcf, 'Type', 'Bar');

% Apply the new color to all bars
for i = 1:length(bars)
    bars(i).FaceColor = 'flat'; % Ensure color can be modified
    bars(i).CData = repmat(newBarColor, size(bars(i).YData, 1), 1); % Set new color
    bars(i).EdgeColor = 'k'; % Set bar outline to black
end


% Put figure in standard pretty layout
%fig1_comps.fig = gcf;
%STANDARDIZE_FIGURE(fig1_comps); 


% Adjust size of figure
x0 = 10;
y0 = 300;
width = 1200;
height = 250
set(gcf,'position',[x0,y0,width,height])

% Adjusts the height of axes to be 95% of default/previous height
hAx=gca;
hAx.Position=hAx.Position.*[1 1 1 0.90]; %x0 y0, width, height

% Change title and axis labels and its position
hAx=gca;
heightOfYAxis = hAx.YLim(2)
gcf
title('2-class classification','Position',[11 heightOfYAxis*1.1])
ylabel('Accuracy','FontName', 'SansSerif', 'Position',[-1 heightOfYAxis/2]);
xlabel('Mental task pair','FontName', 'SansSerif', 'Position',[11 -0.3]);
%legend( '-o', 'Color', [1 0.5 0], 'LineWidth', 1.5, ...
    % 'DisplayName', 'Significant accuracy (p < 0.05)');


% Set x and y label size
h=get(gca,'xlabel')
set(h, 'FontSize', 15, 'FontName', 'SansSerif');
h=get(gca,'ylabel')
set(h, 'FontSize', 15, 'FontName', 'SansSerif'); 
ylim([0.0 1])
ytickformat('%,.1f')

   % Increase font size for tick labels
    ax = gca;
    ax.FontSize = 14; % Increases font size of tick labels
    ax.FontName = 'SansSerif'; % Set font type for tick labels


      % Make the whole figure outline (axes box) thicker
    ax.LineWidth = 1; % Adjust thickness of figure border

