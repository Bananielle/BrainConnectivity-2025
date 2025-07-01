%% Individual trial quality check on fMRI runs
% In 'datafolder', put all VMP files you create in the indivudal trial estimation
% tab of the MVPA dialogue in Brainvoyager. The filenames are identified if
% they start with a "P" (indicative of a participant).

% The scripts saves the first trial of each VMP file found in the folder,
% and them puts them all together in one single VMP file.
% This makes it easier in Brainvoyager to check each functional run 
% for data quality.


datafolder = '/Users/danielle/Documents/Bureau/Neuroscience/OPTCLA2/Matlab Scripts/OPTCLA2_Pruned scripts Danielle_for paper/Data';
cd(datafolder);

FolderContent = dir(datafolder); 
count = 1;

% Saves the first trial of each VMP file found in the folder
for i = 1:size(FolderContent,1) % For the size of the folder
    if startsWith(FolderContent(i).name,"P") == 1 % If the filename starts with a "P" (indicative of a participant number:
        Filenames{count} = FolderContent(i).name                   % Add to the file list
        currentVMPfile = xff(Filenames{count});                                % Open the file with neuroelf (% .Map contains ll 28 trials of that run in normal order (per row))
        
        trialdata = currentVMPfile.Map(:,1); % Only save the first trial of the VMP file (you only need 1 to check whether the data is okay)
        newDataMap(count) = trialdata;
        newDataMap(count).Name = Filenames{count};
        
        count = count + 1;
    end
end

% Open an existing VMP file and overwrite it.
currentVMPfile = xff('P05_S01_01_localizer1_SCCTBL_3DMCTS_THPGLMF4c_TAL_MD_Task-MT_Task-MC_Task-MS_Task-MR_Task-SN_Task-TacI_Task_GLM-2G_PreOn-0-PostOn-30_LT_z-t_Trials.vmp');
currentVMPfile.Map = newDataMap; % Put the new data map in that VMP
currentVMPfile.saveAs("QualityCheck.vmp"); % Save it as a new VMP