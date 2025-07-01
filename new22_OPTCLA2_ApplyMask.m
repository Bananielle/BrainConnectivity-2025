function mask = new22_OPTCLA2_ApplyMask(t1,t2,DataFolder,str_participant,AnalysisType)


% Add wholebrain mask (removes voxels outside of the brain)
temp = xff([DataFolder,'Masks/WholeBrain/',str_participant,'_WholeBrain.msk']);
mask = logical(temp.Mask(:)); % turn mask into a boolean type variable of ones and zeros

% If NOI1000 feature selection is selected, get the highest T-values for
% each taskpair
if contains(AnalysisType,'NOI1000') == 1
    mask = OPTCLA2_CreateHighestTvaluesTaskpairNOIs(params,t1,t2);
end


end