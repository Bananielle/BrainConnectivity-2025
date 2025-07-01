function Sort_files_DE(num_runs,num_participant,num_session)
% Created by Reebal Rafeh (2018)
% Adapted for session 2, offline and online (27-02-19) by Danielle Evenblij
% Check line 102 and 149 for notes
%% Define parameters
clear all
OfflineSorting = 1;
num_participant = 19;
str_participant = ['P',num2str(num_participant,'%02.f')]; % Makes sure the participant string number alwasy contains 2 digits.


num_runs = 21; % Is at the moment always 21?
num_session = 2; % Is usually 1.
StartFunctionalRuns = 1; % Usually at the 7th run of the raw data files.

scouts_str = '-0001-0001-'; % Define the run that contains the scouts (usually 0001-0001).
anatomy_str = '-0002-0001'; % Defin the run that contains the anatomy files (usualy 0006-0001).
AAscouts_str = '-0003-0001-';  % Define the run that contains the scouts (usually 0001-0001).
if OfflineSorting == 1
    StartFunctionalRuns = 7; % Usually at the 7th run of the raw data files.
end

NrLocalizerRuns = 7;
NrEncodingRuns = 2;
NrFunctionalRuns = NrLocalizerRuns + NrEncodingRuns; % 7 functional runs, 5 encoding runs 

tic % Time the process.
display('====Started sorting script.')

% Retrieve and Store File Paths in Corresponding Cell Arrays
dirname=uigetdir('D:','Please Select the Participant Folder to be Sorted');
newdirname=uigetdir('D:','Select a Folder in which the Files are to be Sorted');
cd(dirname);
d=dir; % Creates structure with the filenames and paths for all the (unsorted) files in the current directory.

% Create empt cell arrays
Full_File_Path={};
Scouts={};
Anatomy={};
AAscouts={};
Functional={};

for i=3:numel(d) % Skip the first 2 rows in d, because they are empty.
    Full_File_Path{i-2}=fullfile(dirname,d(i).name); % Put all the filepaths in a new cell array.
end

% Sort 
for i=1:length(Full_File_Path) 
    if isempty(strfind(Full_File_Path{i},scouts_str))==0 % If the cell is NOT empty (so if there is a string containing '-0001-0001-'):
        Scouts{i}=Full_File_Path{i}; % Put these filepath in the cell array 'scouts'.
    elseif isempty(strfind(Full_File_Path{i},anatomy_str))==0 % Same for anatomy.
        Anatomy{i}=Full_File_Path{i};
    elseif isempty(strfind(Full_File_Path{i},AAscouts_str))==0 % Same for AAscouts
        AAscouts{i}=Full_File_Path{i};
    else
        Functional{i}=Full_File_Path{i}; % Put the rest of the file paths in the 'functional' cell array.
    end
end

% Create New Folders and Store Anatomical/Scout/AAscout Files in Corresponding Folders via File Path Retrieval from Cell Array
cd(newdirname);
mkdir(str_participant,'functional');
if OfflineSorting == 1;
    mkdir(str_participant,'anatomy');
    mkdir(str_participant,'scouts');
    mkdir(str_participant,'AAscouts');
    
    cd(['./' str_participant '/scouts']);
    d=cd;
    Scouts=Scouts(~cellfun('isempty',Scouts));
    for i=1:length(Scouts)
        copyfile(Scouts{i},d);
    end
    
    cd(newdirname);
    cd(['./' str_participant '/anatomy']);
    d=cd;
    Anatomy=Anatomy(~cellfun('isempty',Anatomy));
    for i=1:length(Anatomy)
        copyfile(Anatomy{i},d);
    end
    
    cd(newdirname);
    cd(['./' str_participant '/AAscouts']);
    d=cd;
    AAscouts=AAscouts(~cellfun('isempty',AAscouts));
    for i=1:length(AAscouts)
        copyfile(AAscouts{i},d);
    end
end
% Segmenting Functional DataFiles into Corresponding Localizer and Encoding Runs
cd(newdirname);
cd(['./' str_participant '/functional']);
d=cd;
Functional=Functional(~cellfun('isempty',Functional));
    
if OfflineSorting == 1% For the offline DCMs (for BrainVoyager)
    % Put each funtional run (with the associated filepaths) in its own cell array
    for run_nr = 1:NrFunctionalRuns
        for i=1:length(Functional) % The '%04.f' pads the number with zeros so that it will always outputs 4 digits
            if isempty(strfind(Functional{i},[str_participant,' -',num2str(StartFunctionalRuns-1+run_nr,'%04.f'),'-']))==0 % Check whether string is correct!
                FunctionalRun(run_nr).Run{i} =Functional{i};
            end
        end
        % -------------------------------------------------------------------
        % NOTE! You can change the string here if the DICOMs have an
        % alternative name.
        
    end
end

if OfflineSorting == 0 % For the online DCMs (for TurboBrainVoyager)
    % Put each funtional run (with the associated filepaths) in its own cell array
    for run_nr = 1:NrFunctionalRuns
        for i=1:length(Functional) % The '%04.f' pads the number with zeros so that it will always outputs 4 digits
            if isempty(strfind(Functional{i},['_',num2str(StartFunctionalRuns-1+run_nr,'%06.f'),'_']))==0 % The string should be something like: '_000001_'
                FunctionalRun(run_nr).Run{i} =Functional{i};
            end
        end
        % -------------------------------------------------------------------
        % NOTE! You can change the string here if the DICOMs have an
        % alternative name.
        
    end
end
     % Create functional run folders
    cd(newdirname); % Go to the newly created directory 
    cd(['./' str_participant '/functional']);
    for func_run=1:NrLocalizerRuns % Create localizer folders
        mkdir([str_participant '_S0' num2str(num_session) '_0' num2str(func_run) '_localizer' num2str(func_run)]);
    end
    for enc_run=1:NrEncodingRuns % Create encoding run folders
            mkdir([str_participant '_S0' num2str(num_session) '_0' num2str(NrLocalizerRuns+enc_run) '_encoding' num2str(enc_run)]);
    end
    
    
    % Copy the files in the correct functional folders
    
    for func_run = 1:NrFunctionalRuns
        if func_run <= NrLocalizerRuns
            cd([str_participant '_S0' num2str(num_session) '_0',num2str(func_run),'_localizer',num2str(func_run)]);
        else
            cd([str_participant '_S0' num2str(num_session) '_0',num2str(func_run),'_encoding',num2str(func_run-NrLocalizerRuns)]);
        end
        
        d=cd;
        temp_functionalrun=FunctionalRun(func_run).Run(~cellfun('isempty',FunctionalRun(func_run).Run)); 
        for i=1:length(temp_functionalrun) % <------------------------------ you can reduce the Nr of volumes it copies manually here.
            copyfile(temp_functionalrun{i},d);
        end
        cd([newdirname,'\',str_participant,'\functional'])
        display(['=====Finished run ',num2str(func_run),'.'])
    end

display('====Finished.')
toc

