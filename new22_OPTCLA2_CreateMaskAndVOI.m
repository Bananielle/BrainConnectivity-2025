function mask = new22_OPTCLA2_CreateMaskAndVOI(params,t1,t2)
% Adapted from Amaia's script

% Get the selected voxel indices.
mask = OPTCLA2_CreateHighestTvaluesTaskpairNOIs(params,t1,t2);

% Convert them into a wholebrain brain mask
temp_matrix = zeros(params.NrVoxels,1);
temp_matrix(mask,:) = 1;
logical_mask = uint8(temp_matrix);
logical_mask = reshape(logical_mask,58,40,46);

% create empty vmp --> default is TAL
temp = xff('new:vmp');
emptyMat = ones(size(temp.Map.VMPData)).*5; % we need a random matrx to trick BV
tempMatrix = emptyMat.*logical(logical_mask); % we mask it with the mask 
temp.Map(1).VMPData = uint8(tempMatrix); % make it single
% temp.SaveAs('test.vmp')

highResVMP = temp.MakeHiResVMP(1); % make highres for voi creation
[c, t, v, vo] = highResVMP.ClusterTable(1); % we only need vo
% vo.SaveAs('test2.voi')

% merge voi files
mergedVOI = xff('new:voi'); % default --> TAL space
mergedVOI.NrOfVOIs = 1;

allVox = [];
for n=1:vo.NrOfVOIs
   allVox = [allVox; vo.VOI(n).Voxels];    
end

mergedVOI.VOI(1).Voxels = allVox;
mergedVOI.VOI(1).VoxelValues = repelem(5,size(allVox,1))';
mergedVOI.VOI(1).NrOfVoxels = size(allVox,1);
mergedVOI.VOI(1).Name ='merged';
mergedVOI.VOI(1).Color = [255 102 18];

% Set directory to which .voi file is to be saved
TaskLabels = {'MD','MT','MC','MS','MR','SN','TacI'};

cd(params.dirsave);
mergedVOI.SaveAs([params.str_participant,'_NOI1000_7runs_',TaskLabels{t1},'-',TaskLabels{t2},'.voi']);

end