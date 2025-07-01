
%% Show feature space

% Parameters
WHOLEBRAIN = 0;
svmweightfolder = '/Users/danielle/Documents/Bureau/Neuroscience/Projects/01_OPTCLA2/Matlab Scripts/New pruned scripts 2022/SVMweights/';

taskpair_nr = 0;
nrTasks = 7;

for t1 = 1:nrTasks-1
        for t2 = t1+1:nrTasks
            taskpair_nr = taskpair_nr+1;

            t1_str = MentalTasks{t1};
            t2_str = MentalTasks{t2};
            
            % MD-MT P12 example
            % Get GLM mask
            if WHOLEBRAIN == 0
                %GLM_mask = xff('P12-MC-SN_FFX_TAL_mask.msk');
               % GLM_mask = xff(['P12-',t1_str,'-',t2_str,'_FFX_TAL_mask.msk']);
               task_vs_tasks_vmps = xff('P12_task-vs-task_contrasts.vmp');
               vmp_data = task_vs_tasks_vmps.Map(taskpair_nr).VMPData;
               vmp_data = reshape(vmp_data,1,106720);
               statistical_threshold = task_vs_tasks_vmps.Map(taskpair_nr).LowerThreshold;
               glm_mask_data = vmp_data > statistical_threshold;
               % glm_mask_data = GLM_mask.Mask;
                %glm_mask_data = reshape(glm_mask_data,1,106720);
                %glm_mask_data = logical(glm_mask_data);
            end
            
            
            % Get the data 
            data = (P(12).Data.LocalizerData(:,t1,:,:)); % Task 1
            data_s = squeeze(data);
            data_r = reshape(data_s,28,106720);
            %normalized = (data_r - min(data_r(:))) /  (max(data_r(:)) - min(data_r(:)));
            
            
            data2 = (P(12).Data.LocalizerData(:,t2,:,:)); % Task 2
            data_s2 = squeeze(data2);
            data_r2 = reshape(data_s2,28,106720);
            %normalized_neg = - (data_r2 - min(data_r2(:))) / (max(data_r2(:)) - min(data_r2(:)));
            
            % Combine into one big matrix
            %combined = [normalized; normalized_neg];  % 28 x N stacked on 28 x N
            combined = [data_r; data_r2];  % 28 x N stacked on 28 x N
            
            % Wholebrain mask
            if WHOLEBRAIN == 1
            mask_wholebrain = P(ParticipantNr).Mask;
            data_masked = combined(:,mask_wholebrain);
            end
            if WHOLEBRAIN == 0
            % GLM mask
            data_masked = combined(:,glm_mask_data);
            end
            
            data_min = min(data_masked(:));
            data_max = max(data_masked(:));
            normalized = 2 * (data_masked - data_min) / (data_max - data_min) - 1;
            
            data_masked = normalized;
            
            % Show SVM weights
            cd(svmweightfolder)
            svm_weights = xff(['P12_',num2str(taskpair_nr),'_',t1_str,'-',t2_str,'_svmweights_matlab_2025.vmp']);
            %disp(svm_weights.FilenameOnDisk)

            weights = svm_weights.Map.VMPData;
            weights = reshape(weights,1,106720);
            size(weights);
            if WHOLEBRAIN == 1
                weights_masked = weights(mask_wholebrain);
            end
            if WHOLEBRAIN == 0
                weights_masked = weights(glm_mask_data);
            end
            
            
            size(weights_masked);
            
            data_min = min(weights_masked(:));
            data_max = max(weights_masked(:));
            weights_normalized = 2 * (weights_masked - data_min) / (data_max - data_min) - 1;
            
           
            
            % Create the figures

            figure(taskpair_nr);  % Reuse or create figure #1
            set(gcf, 'Position', [100, 100, 1400, 400]);  % Set size
            set(gcf, 'Units', 'inches', 'Position', [1, 1, 10, 4]);  % slightly larger canvas

            subplot(2,1,1);
            % Plot heatmap
            imagesc(data_masked);
            
            % Colormap and colorbar
            colormap('turbo'); % requires MATLAB 2021b+, otherwise use 'parula'
            clim([-1 1]); % Adjust range if needed for visibility
            
            % Add colorbar (legend)
            cb = colorbar;
            cb.Label.String = 't-value (normalized)'; 
            
            % Add divider line
            hold on;
            yline(size(normalized_neg, 1) + 0.5, 'k--', 'LineWidth', 1.2);
            
            
            % Axis settings
            xlabel('Features ');
            ylabel('Trials');
            title([t1_str,'-',t2_str,': Trial × Feature Matrix']);
            set(gca, 'FontSize', 14);  % axis tick labels
            
            % Optional: improve axis ticks
            xticks(linspace(1, size(data_masked,2), 10));
            xticklabels(round(linspace(1, size(data_masked,2), 10)));
            
            %yticks(linspace(1,1,size(data_masked,1)));
            %yticklabels(1:size(data_masked,1));
            set(gcf, 'Color', 'w'); % Set figure background to white
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Plot heatmap
            subplot(2,1,2);
            imagesc(weights_normalized);
            set(gcf, 'Color', 'w'); % Set figure background to white
            
            % Colormap and colorbar
            colormap('turbo'); % requires MATLAB 2021b+, otherwise use 'parula'
            clim([-1 1]); % Adjust range if needed for visibility
            
            % Add colorbar (legend)
            cb = colorbar;
            cb.Label.String = 'Svm weights'; 
            
            % Axis settings
            xlabel('Features');
            ylabel('Svm weights');
            title([t1_str,'-',t2_str,': Svm weights × Feature Matrix']);
            set(gca, 'FontSize', 14);  % axis tick labels
            
            % Optional: improve axis ticks
            xticks(linspace(1, size(weights_normalized,2), 10));
            xticklabels(round(linspace(1, size(weights_normalized,2), 10)));
            
            yticks(1:size(weights_normalized,1));
            yticklabels(1:size(weights_normalized,1));


            
            
            
            % Similarity
            
            [rho, pval] = corr(mean(data_masked, 1)', weights_normalized','Type','Spearman');
            disp(['Taskpair: ',t1_str,'-',t2_str, ': Spearman r = ', num2str(rho), ' p-value = ', num2str(pval)])

        end
end

% Save allf figures in a PDF file
pdf_filename = 'P12_All_taskpairs_svmweights.pdf';
for i = 1:21
    fig = figure(i);  % or store them in a handle array
    set(fig, 'Units', 'inches', 'Position', [1, 1, 10, 4]);
    exportgraphics(fig, pdf_filename, 'BackgroundColor', 'white','ContentType', 'image','Resolution', 600,'Append', true);
end