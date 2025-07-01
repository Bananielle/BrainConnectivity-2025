function [Accuracy,betas,all_preds,all_trues,rescaledSVMweights] = new22_OPTCLA2_foldTrainingTesting_2class(Data,fold,Folds,Contrast,nrRepeats,nrTasks,nrVoxels,UseAllVoxels,PerformPermutationTest)
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


    

    for t1 = 1:nrTasks-1
        for t2 = t1+1:nrTasks
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
       
           
            
            % disp(['Size of traindata: ',num2str(size(traindata))]);
            %disp(['Size of testdata: ',num2str(size(testdata))]);
            %   disp(' ');
            
          
            svm = fitcsvm(traindata,trainlabels);
            Accuracy(j) = 1-loss(svm,testdata,testlabels);
            betas(j,:) = svm.Beta;
            
            % For making confusion matrices later
            predlabels = predict(svm, testdata);

            % Store predictions and true labels
            all_preds(j,:) = predlabels;
            all_trues(j,:) = testlabels;


          
     
            % Save svm weights
            % rescale: see https://stats.stackexchange.com/questions/281162/scale-a-number-between-a-range 
            % Needs to be done, because otherwise BrainVoyager can't visualize the
            % values.
            newMin = -8;
            newMax = 8;
            rescaledBetas = ((svm.Beta - min(svm.Beta)) / (max(svm.Beta)-min(svm.Beta))) * (newMax-newMin) + newMin;

            rescaledSVMweights(j,:) = rescaledBetas;
            %rescaledSVMweights(j,1:10) % Show the first 10 for sanity check
            %
       
        
    
            j = j+1;
            
        end
    end



    

    
     

end

