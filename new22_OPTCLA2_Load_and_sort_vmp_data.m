%% Get VMPs- OPTCLA2
% Put all the data into a matrix of params.NrLocalizerRuns (7) *
% params.NrTasks (7) * params.NrRepeats (4) * params.NrVoxels (106720)

function [LocalizerData,Filenames,LocalizerFilenames,TrialNames] = new22_OPTCLA2_Load_and_sort_vmp_data(params)

display(['======Opening vmp files ',params.str_participant,'...']);
load([params.MainFolder,'/MentalTasks.mat']);
FolderContent = dir(params.DataFolder); 
cd(params.DataFolder);
count = 1;
for i = 1:size(FolderContent,1)
    if startsWith(FolderContent(i).name,params.str_participant) == 1 % If the filename starts with the participant's number:
        Filenames{count} = FolderContent(i).name;                   % Add to the file list
        temp = xff(Filenames{count});                                % Open the file with neuroelf
        Runs(count).Data = temp.Map;                                  % .Map contains ll 28 trials of that run in normal order (per row)
        count = count + 1;
    end
end

% Sort all localizer runs
% Put all the data into a matrix of params.NrLocalizerRuns (7) *
% params.NrTasks (7) * params.NrRepeats (4) * params.NrVoxels (106720)

LocalizerData = zeros(params.NrLocalizerRuns,params.NrTasks,params.NrRepeats,params.NrVoxels);
run = 1;
for count = 1:size(Filenames,2)
    if contains(Filenames{count},'localizer') == 0 % If the filename is not a localizer, skip the loop to the next filename.
        continue;
    end
    trial = 1;
    for task = 1:params.NrTasks
        task;
        %disp(MentalTasks{task}); % For checking if the task order is correct
        temporary_task = zeros(params.NrRepeats,params.NrVoxels);
        for repeat = 1:params.NrRepeats
            repeat;
            temporary_task(repeat,:) = Runs(count).Data(trial).VMPData(:); % VMPData(:) means that you're unrolling the matrix.
            TrialNames{trial} = Runs(count).Data(trial).Name;
            trial = trial +1;
        end
        LocalizerData(run,task,:,:) = temporary_task;
        LocalizerFilenames{run} = Filenames{count};
    end
    run = run+1;
end

TrialNames= TrialNames' % Just for checking if the trial and task order is correct

display('======Done.');
end

