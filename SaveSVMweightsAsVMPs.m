%% Save SVM weights as VMPs.\
% The betas are the saved averaged SVM weights after training and testing
% in the 7-fold cross-validation 2-class scheme.
% 
% For each taskpair of a participant. Scale the svm weights first so that BV can actually vizualize the values,
% then put the weights back into a 106720 format, put it back into 3D space
% and save as a .vmp map.

%% Rescale betas(SVM weights) for each taskpair and each participant and put them in a VMP file


% Betas = 7 (folds) x 21 (taskpairs) x nr of voxels

betas_allTaskpairs = squeeze(mean(Betas));
clear rescaledBetas


% rescale: see https://stats.stackexchange.com/questions/281162/scale-a-number-between-a-range
% Needs to be done, because otherwise BrainVoyager can't visualize the
% values.
newMin = -10;
newMax = 10;

for i = 1:size(betas_allTaskpairs,1)
    betas = betas_allTaskpairs(i,:);
    rescaledBetas = ((betas - min(betas)) / (max(betas)-min(betas))) * (newMax-newMin) + newMin;
    
    % Put back into 106720 format
    taskpair = MentalTaskpairs{i};
    participant = num2str(ParticipantNr);
    nonzeroMaskIndices = find(Mask);
    originalMap = zeros(params.NrVoxels,1);
    originalMap(nonzeroMaskIndices) = rescaledBetas;
    
    % Save as VMP map
    data = reshape(originalMap,[58,40,46]);
    data = single(data);
    %
    cd([params.MainFolder,'/SVMweights/DifferentlySorted']);
    filename = [num2str(i),'_P',participant,'_',taskpair,'_svmweights_matlab.vmp'];
    temp = xff('P14_MC_vs_rest_Bonf0.05.vmp');
    temp.Map.VMPData = data;
    temp.Map.Name = [participant,'_',taskpair,'_svmweights_matlab'];
    temp.saveAs(filename);
    
    disp(['Saved ',filename]);
    
end

%% Save all SVMweight maps per taskpair nr
% So you'll end up with 21 files with each file containing the SVM weight maps of all 16 participants.
% This makes it easier to open them per taskpair in BrainVoyager

datafolder = '/Users/danielle/Documents/Bureau/Neuroscience/Projects/01_OPTCLA2/Matlab Scripts/New pruned scripts 2022/SVMweights/DifferentlySorted';
cd(datafolder);
FolderContent = dir(datafolder);

% Saves the first trial of each VMP file found in the folder
for tasknr = 1:21
    count = 1;
    cd(datafolder);
    clear newDataMap;
    for participantNr = 5:20
        for i = 1:size(FolderContent,1) % For the size of the folder
            if startsWith(FolderContent(i).name,[num2str(tasknr),'_P',num2str(participantNr)]) == 1 % If the filename starts with a "P" (indicative of a participant number:
                Filenames{count} = FolderContent(i).name;                 % Add to the file list
                currentVMPfile = xff(Filenames{count});                                % Open the file with neuroelf (% .Map contains ll 28 trials of that run in normal order (per row))
                
                trialdata = currentVMPfile.Map; % Only save the first trial of the VMP file (you only need 1 to check whether the data is okay)
                newDataMap(count) = trialdata;
                newDataMap(count).Name = Filenames{count};
                
                count = count + 1;
            end
        end
    end
    
    % Open an existing VMP file and overwrite it.
    cd([datafolder,'/SVMweightMapsPerTaskPair']);
    currentVMPfile = xff('P05_S01_01_localizer1_SCCTBL_3DMCTS_THPGLMF4c_TAL_MD_Task-MT_Task-MC_Task-MS_Task-MR_Task-SN_Task-TacI_Task_GLM-2G_PreOn-0-PostOn-30_LT_z-t_Trials.vmp');
    currentVMPfile.Map = newDataMap; % Put the new data map in that VMP
    filename = [num2str(tasknr),'_',PairNames{tasknr},'_svmWeights_P05-P20.vmp'];
    currentVMPfile.saveAs(filename); % Save it as a new VMP
    
end
%% Sanity check for making SVM weights
% Test with a BV-made SVM volume map: unroll the data, apply a whole-brain mask, then
% put the data back in its original form and save as an .vmp file. Volume
% map in BV should look the same except for the whole-brain mask that is
% now applied.

% temp = xff('P14_MD-MT_NOI_svmweights_2643voxels.vmp');
% test = temp.Map.VMPData;
% test = test(:);
%
%
% test = test(find(Mask));
% nonzeroMaskIndices = find(Mask);
% originalMap = zeros(params.NrVoxels,1);
% originalMap(nonzeroMaskIndices) = test;
%
% data = reshape(originalMap,[58,40,46]);
% data = single(data);
% temp.Map.VMPData = data;
%
% temp.Map.Name = [participant,'_',taskpair,'_svmweights_matlab'];
% temp.saveAs(filename)



