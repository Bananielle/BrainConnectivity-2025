 %% Create bar graph OPTCLA2
 
 function graph = CreateBargraph(params,Accuracies,StandardDev,Title,PairNames, permutationValues)
 
    PS.Blue1 = [133, 193, 233]./255;
    PS.Blue2 = [93, 173, 226]./255;
    PS.Blue3 = [52, 152, 219]./255;
    PS.Blue4 = [40, 116, 166]./255;
    PS.Blue5 = [27, 79, 114]./255;
    PS.Blue6 = [162, 194, 190]./255;
    PS.Orange = [255, 165, 0]./255; % RGB values for orange color


    C = categorical(PairNames,PairNames); % 2 times PairNames to avoid them being put in alphabetical order (weird Matlab quirk)
    b= bar(C,Accuracies,0.5,'FaceColor',PS.Blue6);

    % Initialize handles for the legend
    legendHandles = [b];
    legendLabels = {'Mean accuracy'};
    
    hold on
    
    % Add error bars for the sd if StandardDev isn't empty.
    if mean(StandardDev) ~= 0 
        errorbar(Accuracies(:,1),StandardDev,'LineWidth',0.6,'LineStyle','none','Color','k');
    end
    
    % Add the new line plot if there are permutation values
    if permutationValues ~= 0 
        permutationValues = [permutationValues;mean(permutationValues)]
        pl = plot(1:length(PairNames), permutationValues, 'o-', 'Color', PS.Orange, 'LineWidth', 1.5, 'MarkerSize', 6);
        legendHandles(end+1) = pl;
        legendLabels{end+1} = '% of accuracies p<0.05';
    end

    % Add legend
    legend(legendHandles, legendLabels, 'Location', 'best');

    hold off
    
    [maxval,max_ind] = max(Accuracies(:,1));
    idx = find((Accuracies(:,1)) == maxval); % Index the taskpair(s) with the highest accuracy
    b.FaceColor = 'flat';
   % for i = 1:length(idx) % For each taskpair containing the highest accuracy, change the colour of its bar.
    %    b.CData(idx(i),:) = [112/255 219/255 147/255];
   % end
    ylim([0 1]); % Always display classification accuracies from 0.30 to 1.00.
    ylabel('Accuracy','FontSize', 15, 'FontName', 'SansSerif'); 
    xlabel('Mental state pair','FontSize', 15, 'FontName', 'SansSerif'); 
    ytickformat('%.2f'); % Sets the y-axis ticks to 2 decimal places
    set(gcf,'Color','w'); % set the figure background color to white.
    set(findall(gcf, 'Type', 'text'), 'FontSize', 12,'FontName','SansSerrif'); % Get a proper font and fontsize for the text.
    title(Title);
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    
    
 end