 %% Create bar graph OPTCLA2
 
 function graph = new22_CreateBargraph(params,Accuracies,StandardDev,Title,PairNames)

    C = categorical(PairNames,PairNames); % 2 times PairNames to avoid them being put in alphabetical order (weird Matlab quirk)
    b= bar(C,Accuracies,0.5,'FaceColor',[0 191/255 255/255]);
    hold on
    if mean(StandardDev) ~= 0 %% Add error bars for the sd if StandardDev isn't empty.
        errorbar(Accuracies(:,1),StandardDev,'LineWidth',0.6,'LineStyle','none','Color','k');
    end
    hold off
    [maxval,max_ind] = max(Accuracies(:,1));
    idx = find((Accuracies(:,1)) == maxval); % Index the taskpair(s) with the highest accuracy
    b.FaceColor = 'flat';
   % for i = 1:length(idx) % For each taskpair containing the highest accuracy, change the colour of its bar.
    %    b.CData(idx(i),:) = [112/255 219/255 147/255];
   % end
    ylim([0.3 1]); % Always display classification accuracies from 0.30 to 1.00.
    ylabel('Accuracy');
    xlabel('Mental state pair');
    ytickformat('%.2f'); % Sets the y-axis ticks to 2 decimal places
    set(gcf,'Color','w'); % set the figure background color to white.
    set(findall(gcf, 'Type', 'text'), 'FontSize', 12,'FontName','Helvetica Neue'); % Get a proper font and fontsize for the text.
    title(Title);
    grid on
    
 end