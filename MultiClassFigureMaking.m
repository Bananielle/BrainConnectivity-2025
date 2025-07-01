%% Figures for multi-class

    %% Main figure (class per participant)
   % participantStr = ["5","6","7","8,","9","10","11","12","13","14","15","16","17","18","19","20","mean"];
   participantStr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","mean"];
    xlabels = categorical(participantStr,participantStr); % 2 times  to avoid them being put in alphabetical order (weird Matlab quirk)
    
    %t1 = tiledlayout(1,1); 
   % ax = axes(t);
    figure(1);bar(xlabels,all_classes_participant)
    
      % Put figure in standard pretty layout
   % fig1_comps.fig = gcf;
   % STANDARDIZE_FIGURE(fig1_comps); 
   
    % Error bars
    ngroups = size(all_classes_participant, 1);
    nbars = size(all_classes_participant, 2);
    % Calculating the width for each bar group
    groupwidth = min(0.8, nbars/(nbars + 1.5));
    hold on
    for i = 1:nbars
        x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
        errorbar(x, all_classes_participant(:,i), all_classes_participant_SD(:,i),'LineWidth',0.6,'LineStyle','none','Color','k');
    end
    hold off
    
   % title("Mean multi-class classification accuracies across all 21 mental taskpairs")
    ytickformat('%.2f'); % Sets the y-axis ticks to 2 decimal places
    set(gcf,'Color','w'); % set the figure background color to white.
    set(findall(gcf, 'Type', 'text'), 'FontSize', 16,'FontName','SansSerif'); % Get a proper font and fontsize for the text
    ax = gca
    ax.XGrid = 'off';
    ax.YGrid = 'on';
    ytickformat('%.1f'); % Sets the y-axis ticks to 2 decimal places
    h=get(gca,'ylabel')
set(h, 'FontSize', 16) 

   % Increase font size for tick labels
    ax = gca;
    ax.FontSize = 14; % Increases font size of tick labels
    ax.FontName = 'SansSerif'; % Set font type for tick labels
    
    legend('2-class','3-class','4-class','5-class','6-class','7-class','','','','','','','','','','','','');
    legend1 = legend(ax,'show');
set(legend1,...
    'Position',[0.212992603608186 0.0160171313927372 0.487128712871284 0.0303643724696354],...
    'Orientation','horizontal', 'Fontsize',13);

%     
     ylim([0.0 1]); % Always display classification accuracies from 0.30 to 1.00.
%     yline(0.50001,'color','white','LineWidth',1.5);
%     yline(0.5,'color','black','LineWidth',1);
%     yline(0.330001,'color','white','LineWidth',1.5);
%     yline(0.33,'color','black','LineWidth',1);
%     yline(0.250001,'color','white','LineWidth',1.5);
%     yline(0.25,'color','black','LineWidth',1);
%     yline(0.20001,'color','white','LineWidth',1.5);
%     yline(0.20,'color','black','LineWidth',1);
%     yline(0.1660001,'color','white','LineWidth',1.5);
%     yline(0.166,'color','black','LineWidth',1);
%     yline(0.1430001,'color','white','LineWidth',1.5);
%     yline(0.143,'color','black','LineWidth',1);
%     
%    
% % Create textarrow
% annotation('textarrow',[0.900025649174796 0.845257812255198],...
%     [0.374534412955466 0.374534412955466],'String','33% chance level');
% 
% % Create textarrow
% annotation('textarrow',[0.900025649174797 0.845257812255199],...
%     [0.312753036437247 0.312753036437247],'String','25% chance level');
% 
% % Create textarrow
% annotation('textarrow',[0.900025649174797 0.845257812255199],...
%     [0.268825910931174 0.268825910931174],'String','20% chance level');
% 
% % Create textarrow
% annotation('textarrow',[0.900025649174796 0.845257812255198],...
%     [0.240898785425101 0.240898785425101],'String','17% chance level');
% 
% % Create textarrow
% annotation('textarrow',[0.9000256491748 0.845257812255202],...
%     [0.21385020242915 0.21385020242915],'String','14% chance level');
% 
% % Create textarrow
% annotation('textarrow',[0.900025649174801 0.845257812255203],...
%     [0.508474576271186 0.508474576271186],'String','50% chance level');



    ylabel('Accuracy','FontSize', 14, 'FontName', 'SansSerif'); 
    xlabel('Particicpant','FontSize', 14, 'FontName', 'SansSerif'); 
   
    
    % Add distnace to chancelevel
    hold on
    bar(distanceFromChanceLevel,'FaceColor',[0.8 0.8 0.8]);
    hold off
   colororder({'black','black'})
    yyaxis right
    % ylabel('Distance (accuracy - theoretical chance level)')
    %ylabel('Theoretical chance level)')
     
    set(gca,'ytick',[])
    ax2.XAxisLocation = 'top';
    %xlim([0.0 1])
    ax2.Color = 'none';
    hold off
  
        % Make the whole figure outline (axes box) thicker
    ax.LineWidth = 1; % Adjust thickness of figure border
     
     % Do this again, because of a Matlab bug? (gets the proper legend)
    
    legend('2-class','3-class','4-class','5-class','6-class','7-class','','','','','','','','','','','','Distance to chance level');
    legend1 = legend(ax,'show');
set(legend1,...
    'Position',[0.212992603608186 0.0160171313927372 0.487128712871284 0.0303643724696354],...
    'Orientation','horizontal', 'Fontsize',13);

    
%% Prettier

    % Make figure prettier
    PS = PLOT_STANDARDS(); % To be used for easier pretty figure making
fig1_comps.fig = gcf;
STANDARDIZE_FIGURE(fig1_comps); 

    % Set x and y label size
h=get(gca,'xlabel')
set(h, 'FontSize', 24) 
h=get(gca,'ylabel')
set(h, 'FontSize', 24) 

  %%  Mean per class
    %
    figure(2); bar(meanPerClass)
    hold on
    errorbar(meanPerClass,stdPerClass,'LineWidth',0.6,'LineStyle','none','Color','k');
    hold off
    title("Mean multi-class classification accuracies across all 21 mental taskpairs and participants")
    ytickformat('%.1f'); % Sets the y-axis ticks to 2 decimal places
    set(gcf,'Color','w'); % set the figure background color to white.
    set(findall(gcf, 'Type', 'text'), 'FontSize', 14,'FontName','SansSerif'); % Get a proper font and fontsize for the text
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'on';
    ylim([0.0 1]); % Always display classification accuracies from 0.30 to 1.00.
    yline(0.50001,'color','white','LineWidth',1.5);
    yline(0.5,'color','b','LineWidth',1);
    yline(0.330001,'color','white','LineWidth',1.5);
    yline(0.33,'color','r','LineWidth',1);
    yline(0.250001,'color','white','LineWidth',1.5);
    yline(0.25,'color','y','LineWidth',1);
    yline(0.20001,'color','white','LineWidth',1.5);
    yline(0.20,'color','m','LineWidth',1);
    yline(0.1660001,'color','white','LineWidth',1.5);
    yline(0.166,'color','g','LineWidth',1);
    yline(0.1430001,'color','white','LineWidth',1.5);
    yline(0.143,'color','c','LineWidth',1);
    ylabel('Accuracy');
    xlabel('Number of classes used for classification');
    
%   
%     
%      %% Make theoretical-chance level matrix (per participant)
    figure(3)
    xlabels = categorical(participantStr,participantStr); % 2 times  to avoid them being put in alphabetical order (weird Matlab quirk)
    bar(xlabels,distanceFromChanceLevel);
    title("Distance between accuracies and theoretical chancelevel")
    ytickformat('%.2f'); % Sets the y-axis ticks to 2 decimal places
    set(gcf,'Color','w'); % set the figure background color to white.
    set(findall(gcf, 'Type', 'text'), 'FontSize', 16,'FontName','SansSerif'); % Get a proper font and fontsize for the text
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'on';
    ytickformat('%.1f'); % Sets the y-axis ticks to 2 decimal places
    
    legend('2-class','3-class','4-class','5-class','6-class','7-class','','','','','','','','','','','','');
    legend('2-class','3-class','4-class','5-class','6-class','7-class','','','','','','','','','','','','');
    legend1 = legend(ax,'show');
    set(legend1,...
        'Position',[0.274257425742575 0.189169139465876 0.487128712871287 0.0281899109792284],...
        'Orientation','horizontal');
    
    ylim([0.0 (1-0.15)]); 

    ylabel('Distance (accuracy - theoretical chancelevel)');
    xlabel('Particicpant');

    %% Distance to chance level (Boxplot)
    figure(4)

    xlabels = {'2-class','3-class','4-class','5-class','6-class','7-class'}  
    C = categorical(xlabels,xlabels); % 2 times PairNames to avoid them being put in alphabetical order (weird Matlab quirk)
   
    PS.Blue6 = [162, 194, 190]./255;
    b = boxplot(distanceFromChanceLevel, 'Labels', xlabels, 'Symbol', 'o');

    % Change the color of the boxplot lines to black
    set(b, 'Color', 'black'); % 

    % Set median to red
    hMedian = findobj(gca, 'Tag', 'Median'); % Find median line
    set(hMedian, 'Color', 'r', 'LineWidth', 2); 

       % Add numerical values inside bars
    means = mean(distanceFromChanceLevel);
   for i = 1:numel(means)
    text(i, means(i), sprintf('%.2f', means(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontName', 'SansSerif', 'FontSize', 11, 'FontWeight','bold');
end
hold


    % Make the boxplot lines thicker
    set(b, 'LineWidth', 1); % Adjust line thickness 

   % title("Mean distance between accuracies and theoretical chancelevel")
    ytickformat('%.2f'); % Sets the y-axis ticks to 2 decimal places
    set(gcf,'Color','w'); % set the figure background color to white.
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'on';
    ytickformat('%.1f'); % Sets the y-axis ticks to 2 decimal places
   
    ylabel('Distance (accuracy - theoretical chance level)','FontSize', 15, 'FontName', 'SansSerif'); 
    xlabel('Number of classes used for classification','FontSize', 15, 'FontName', 'SansSerif'); 

    %ylim([0 0.6]); 

   % Increase font size for tick labels
    ax = gca;
    ax.FontSize = 14; % Increases font size of tick labels
    ax.FontName = 'SansSerif'; % Set font type for tick labels

    % Make the whole figure outline (axes box) thicker
    ax.LineWidth = 1; % Adjust thickness of figure border



   % Put figure in standard pretty layout
  %  fig1_comps.fig = gcf;
   % STANDARDIZE_FIGURE(fig1_comps); 
    
    

    %% Distance to chance level (histogram)
    figure(4)

    xlabels = {'2-class','3-class','4-class','5-class','6-class','7-class'}  
    C = categorical(xlabels,xlabels); % 2 times PairNames to avoid them being put in alphabetical order (weird Matlab quirk)
   
    PS.Blue6 = [162, 194, 190]./255;
    b = bar(C,mean(distanceFromChanceLevel),'FaceColor',PS.Blue6);
   
   % title("Mean distance between accuracies and theoretical chancelevel")
    ytickformat('%.2f'); % Sets the y-axis ticks to 2 decimal places
    set(gcf,'Color','w'); % set the figure background color to white.
    set(findall(gcf, 'Type', 'text'), 'FontSize', 16,'FontName','Helvetica Neue'); % Get a proper font and fontsize for the text
    ax = gca;
    ax.XGrid = 'off';
    ax.YGrid = 'on';
    ytickformat('%.1f'); % Sets the y-axis ticks to 2 decimal places
    
    % add error bars
    hold on
    errorbar(mean(distanceFromChanceLevel),std(distanceFromChanceLevel),'LineWidth',0.6,'LineStyle','none','Color','k');
    hold off
    
    ylim([0 0.5]); 

    ylabel('Distance (accuracy - theoretical chancelevel)');
    xlabel('Number of classes used for classification');
   % ax.XTick =["2","3","4","5","6","7"]

   % Add numerical values inside bars
   means = mean(distanceFromChanceLevel);
for i = 1:length(b.XEndPoints)
    text(b.XEndPoints(i), means(i) + 0.02, ...
        sprintf('%.2f', means(i)), ... % Format to 2 decimals
        'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');
end
    
   % Put figure in standard pretty layout
    fig1_comps.fig = gcf;
    STANDARDIZE_FIGURE(fig1_comps); 

% % Set x and y label size
% h=get(gca,'xlabel')
% set(h, 'FontSize', 16)
% h=get(gca,'ylabel')
% set(h, 'FontSize', 16) 
% 
%     
    

