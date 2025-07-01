%% Vectorization practice
function [Accuracy] = vectorizedTrainingAndTesting(Data,fold,Folds,Contrast,nrRepeats,nrTasks,nrVoxels,UseAllVoxels,PerformPermutationTest)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



   % Get the training and test run indices of the current fold
    test_ind = Folds(fold).TestingRun;
    train_ind = Folds(fold).TrainingRuns;

% Make labels
  j = 1;
    testlabels = [zeros(1,length(test_ind)*nrRepeats) ...
        ones(1,length(test_ind)*nrRepeats)]';
    trainlabels = [zeros(1,length(train_ind)*nrRepeats) ...
        ones(1,length(train_ind)*nrRepeats)]';
    
    % If permutation testing, shuffle all labels
    if PerformPermutationTest == 1
        labels = [trainlabels;testlabels];
        perm_label = labels(randperm(length(labels))); % Permute all labels.
        trainlabels = perm_label(1:size(trainlabels)); % Split up again in training and testing labels
        testlabels = perm_label(size(trainlabels)+1:end);
    end
    
    i= 0;
    for t1 = 1:nrTasks-1
        for t2 = t1+1:nrTasks
            i = i+1;
            % Create training data
            task1 = squeeze(Data(train_ind,t1,:,:)); % Get the trials from that task from all the runs.
            task1 = reshape(task1,[length(train_ind)*nrRepeats,nrVoxels]);  % Reshape them into a 2D matrix.
            task2 = squeeze(Data(train_ind,t2,:,:)); % Get the trials from that task from all the runs.
            task2 = reshape(task2,[length(train_ind)*nrRepeats,nrVoxels]);  % Reshape them into a 2D matrix.
            
            traindata = [task1;task2];
            
            % Create test data
            task1 = squeeze(Data(test_ind,t1,:,:)); % Get the trials from that task from all the runs.
            task1 = reshape(task1,[length(test_ind)*nrRepeats,nrVoxels]);  % Reshape them into a 2D matrix.
            task2 = squeeze(Data(test_ind,t2,:,:)); % Get the trials from that task from all the runs.
            task2 = reshape(task2,[length(test_ind)*nrRepeats,nrVoxels]);  % Reshape them into a 2D matrix.
            
            testdata = [task1;task2];
           % clear task1;
          %  clear task2;
         %   
%             % Apply a univarate contrast mask if indicated.
%             if params.Analysis.UnivariateContrasts == 1 % Add a contrast mask to the training and testing data (mask based on a univariate contrast using only the training data)
%                 ContrastsMasks = OPTCLA2_ApplyMask(params,t1,t2); % T1 and t2 can be 0 because we're only using whole-brain (t1 and t2 are only needed for the NOI masked based on taskpair)        
%                 Contrast = logical(ContrastsMasks(j,:));
%                 disp(['Mask applied to taskpair ',num2str(j)]);
%                 disp(['Size of Contrast matrix: ',num2str(size(Contrast))]);
%                 disp(['Size of mask: ',num2str(size(find(Contrast)))]);
%                 traindata = traindata(:,Contrast);
%                 testdata = testdata(:,Contrast);
%             else
%              
                if UseAllVoxels == 0 % %Don't all 120.000 voxels, but use a whole-brain mask
                traindata = traindata(:,Contrast);
                testdata = testdata(:,Contrast); 
                end
          %  end
       
           
            

                % Create a structure with all the trainingn data and a
                % structture with all testing data
                dynamicFieldName = ['T',num2str(i)];
                train.(dynamicFieldName) = {traindata,trainlabels};
                test.(dynamicFieldName) = {testdata,testlabels};
              %  testdataCell{i} = testdata;
             %   testlabelCell{i} = testdata;
         
            
%             try
%                 svm = fitclinear(traindata,trainlabels);
%                 Accuracy(j) = 1-loss(svm,testdata,testlabels);
%             catch
%                 Accuracy(j) = 0;
%                 disp('Empty matrix'); % This means there is nothing in the mask and the accuracies will be 0.
%             end
            
            % Save svm weights
            %rescaledSVMweights(j,:) = saveSVMweights(svm.Beta);
            
            j = j+1;
            
        end
    end
    

            % Temp functions training
            trainingFunction = @(traindata,trainlabels) fitclinear(traindata, trainlabels);
            trainOuter = @(cellarray) trainingFunction(cellarray{1},cellarray{2});
            
            svmModels = structfun(trainOuter,train, 'UniformOutput', false);
            
         %   mergestructs = @(x,y) cell2struct([struct2cell(x), struct2cell(y)],fieldnames(x),1);
         %   k = mergestructs(test,svmModels)
            
 
        
            % Temp functions testing
            for i = 1:21
                dynamicFieldName = ['T',num2str(i)]; 
              svm =  svmModels.(dynamicFieldName);
              test.(dynamicFieldName){3} = svm;
            end
            
            
            testingFunction = @(svm,testdata,testlabels) 1-loss(svm,testdata,testlabels);
            testOuter = @(cellarray) testingFunction(cellarray{3},cellarray{1},cellarray{2});
       
            
       
            Accuracy = structfun(testOuter,test,'UniformOutput', false);
            

            
            


end

