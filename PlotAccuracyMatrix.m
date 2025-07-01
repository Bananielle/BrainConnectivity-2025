%% Make a task classifcation accuracy matrix
dataFolder = params.MainFolder;
cd(dataFolder)

%% Put accuracies in matrix form
% Needs to run 'Tables and figures 2-class' section in
% new22_MainscriptOPTCLA2.m first (so you get the mean 2-class accuracy
% accross participants)
meanAcrossParticipants;

accuracies_double = [meanAcrossParticipants meanAcrossParticipants];

% Upper half
temp = zeros(7,7)
count = 1;
for i = 1:params.NrTasks
    for j = 1:params.NrTasks
        if i == j % If e.g., MD-MD (which we don't have accuracies for)
            temp(i,j) = nan
            continue
        end
        if i > j % If lower side of the matrix
            continue % Skip placement
        else
            accuracy = meanAcrossParticipants(count);
            temp(i,j) = accuracy;
            count = count+1;
        end
        if count> 21 % Which is the amount of taskpairs we have accuracies for.
            disp('limit reached')
        end
    end
end

data = temp + temp' % Transpose the upperhalf so we can add it as the lower half to the matrix.


%% Plot accuracy matrix
% Note about heatmap from Matlab: "By default, heatmaps support a subset of TeX markup for the text you specify. Use TeX markup to
%add superscripts and subscripts, modify the font type and color, and include special characters in the text. If you want a TeX markup
%character in regular text, such as an underscore (_), then insert a backslash (\) before the character you want to include.
%The backslash is the TeX escape character. For more information, see the Interpreter property of the text object.

data = round(data, 2);

% Create a mask for the upper triangle including diagonal
%mask = triu(true(size(data)));  % upper triangle + diagonal = true
%data(mask) = NaN;  % use mask to turn into nan

xvalues = MentalTasks;
yvalues = MentalTasks;

figure('Position', [100, 100, 800, 600])  % [left, bottom, width, height] Make figure wider to fit everything



h = heatmap(xvalues,yvalues,data,'ColorLimits',[0.6 0.85],'Colormap',bone,'MissingDataColor', [1 1 1],'MissingDataLabel', '','Title','Mean 2-class accuracy');
h.FontSize = 18;
%h.MissingDataLabel = ''


xlabel('Task');
ylabel('Task');


h.FontSize = 18;
%h.FontName = 'Arial Rounded MT Bold';
h.FontName = 'Calibri';
%h.GridVisible = 'off';

ax = gca;


% Colour ticklabels
ticklabels = get(gca,'XDisplayLabels');% get the current tick labeks
ticklabels_new = cell(size(ticklabels)); % prepend a color for each tick label
for i = 1:length(ticklabels)
    ticklabels_new{1} = ['\color{red} ' ticklabels{1}];
    ticklabels_new{2} = ['\color{green} ' ticklabels{2}];
    ticklabels_new{3} = ['\color{magenta} ' ticklabels{3}];
    ticklabels_new{4} = ['\color[rgb]{0.9990 0.7940 0.1250}' ticklabels{4}];
    ticklabels_new{5} = ['\color{blue} ' ticklabels{5}];
    ticklabels_new{6} = ['\color{cyan} ' ticklabels{6}];
    ticklabels_new{7} = ['\color[rgb]{0.5290 0.3940 0.1250}' ticklabels{7}];
end
% set the tick labels
set(gca, 'XDisplayLabels', ticklabels_new);
set(gca, 'YDisplayLabels', ticklabels_new);
set(gcf,'color','w');

% Put the ticklabels to bold
hAx=h.NodeChildren(3);          % return the heatmap underlying axes handle
hCB=h.NodeChildren(2);          % the wanted colorbar handle
hCB.Label.String = 'Accuracy';
hCB.Label.FontSize = 18;

h.Title = '';




%%