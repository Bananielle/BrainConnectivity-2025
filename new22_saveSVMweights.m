function [rescaledBetas] = saveSVMweights(betas)

%participant = params.str_participant;
%taskpair = PairNames{taskpairNr};

% rescale: see https://stats.stackexchange.com/questions/281162/scale-a-number-between-a-range 
% Needs to be done, because otherwise BrainVoyager can't visualize the
% values.
newMin = -10;
newMax = 10;

% for i= 1 : size(betas,1)
%     x = betas(i);
% rescaledBetas(i) = ((x - min(betas)) / (max(betas)-min(betas))) * (newMax-newMin) + newMin;
% end

rescaledBetas = ((betas - min(betas)) / (max(betas)-min(betas))) * (newMax-newMin) + newMin;

% 
% 
% 
% % Save SVM weights from all 7 folds
% P(params.Particpant).SVMWeights(fold) = rescaledBetas;
% 
% 
% % Save as VMP map
% data = reshape(rescaledBetas,[58,40,46]);
% data = single(data);
% 
% cd([params.MainFolder,'/SVMweights']);
% filename = [participant,'_',taskpair,'_svmweights.vmp'];
% temp = xff('P14_MC_vs_rest_Bonf0.05.vmp');
% temp.Map.VMPData = data;
% temp.Map.Name = [participant,'_',taskpair,'_svmweights'];
% temp.saveAs(filename)
% end
% 
