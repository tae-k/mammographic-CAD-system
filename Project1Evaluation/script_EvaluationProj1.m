% Evaluation script project 1
close all;
clc; clearvars;

%% Read file lists for and true segmentations
datatopdir = './MammoTraining/';  
sublistfile = fullfile('./Project1List.xlsx');
% datatopdir = './MammoTesting/';  
% sublistfile = fullfile(['./Project1ListTesting.xlsx']);

[~,~,alllist] = xlsread(sublistfile);
sublist = alllist(2:end,1);
sublist = num2str(cell2mat(sublist));
numsubs = length(sublist);
truediag = alllist(2:end,2:3);
truediag = cell2mat(truediag);

%% Read the subject mammograms and generate results 

dices = zeros(numsubs,2);       % ovelap measure
estdiag = zeros(numsubs,2);     % diagnosis measure
times = zeros(numsubs,1);       % time measure
for i = 1:numsubs               % for each subject
    
    %display([datatopdir,sublist(i,:)]);
    fprintf('file: %s\n',[datatopdir,sublist(i,:)])
    mammoimgleft = imread([datatopdir,sublist(i,:) '_LEFT.png']);
    mammoimgright = imread([datatopdir,sublist(i,:) '_RIGHT.png']);
    
    tic
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% REPLACE THE LINE BELOW WITH YOUR FUNCTION CALL for runProject1! %%
    
    [estdiag(i,:), estmaskleft,estmaskright] = runProject1(mammoimgleft,mammoimgright);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    times(i)=toc;
    %% Compute overlap
    % Left side
    if truediag(i,1) == 0   
        % If the true diagnosis is healthy and your estimated diagnosis is
        % correct, the Dice will be 1. Otherwise, the Dice will be 0.
        if estdiag(i,1) == 0  
            dices(i,1) = 1;
        else
            dices(i,1) = 0;
        end
    else
        % If the true diagnosis is benign/cancer and your estimated
        % diagnosis is healthy, the Dice will be 0. Otherwise, the Dice
        % will be a coefficient that measure the overlap between your
        % estimated mask and the groundtruth mask.
        if estdiag(i,1) == 0
            dices(i,1) = 0;
        else
            truemaskfile = [datatopdir sublist(i,:) '_LEFT_MASK.png'];
            truemask = imread(truemaskfile);
            dices(i,1) = 2*(length(find(estmaskleft & truemask)))/(sum(estmaskleft(:))+sum(truemask(:)));
        end
    end
    % Right side
    if truediag(i,2) == 0   
        if estdiag(i,2) == 0    
            dices(i,2) = 1;
        else
            dices(i,2) = 0;
        end
    else
        if estdiag(i,2) == 0
            dices(i,2) = 0;
        else
            truemaskfile = [datatopdir sublist(i,:) '_RIGHT_MASK.png'];
            truemask = imread(truemaskfile);
            dices(i,2) = 2*(length(find(estmaskright & truemask)))/(sum(estmaskright(:))+sum(truemask(:)));
        end
    end
    
end

%% Compute the sensitivities and specificities
conMatrix = zeros(3,3);
conMatrix(1,1) = sum(estdiag(:)==0 & truediag(:)==0);
conMatrix(1,2) = sum(estdiag(:)==0 & truediag(:)==1);
conMatrix(1,3) = sum(estdiag(:)==0 & truediag(:)==2);
conMatrix(2,1) = sum(estdiag(:)==1 & truediag(:)==0);
conMatrix(2,2) = sum(estdiag(:)==1 & truediag(:)==1);
conMatrix(2,3) = sum(estdiag(:)==1 & truediag(:)==2);
conMatrix(3,1) = sum(estdiag(:)==2 & truediag(:)==0);
conMatrix(3,2) = sum(estdiag(:)==2 & truediag(:)==1);
conMatrix(3,3) = sum(estdiag(:)==2 & truediag(:)==2);
cancer_sen = conMatrix(3,3)/sum(conMatrix(:,3));
cancer_spe = sum(sum(conMatrix(1:2,1:2)))/(numsubs*2 - sum(conMatrix(:,3)));
diag_accuracy = (conMatrix(1,1)+conMatrix(2,2)+conMatrix(3,3))/(numsubs*2);

%% Display performance
disp('Total Time:');
disp(num2str(sum(times)));
disp('Mean mask overlap (Left side):');
disp(num2str(mean(dices(:,1))));
disp('Mean mask overlap (Right side):');
disp(num2str(mean(dices(:,2))));
disp('Sensitivity of cancer:');
disp(num2str(cancer_sen));
disp('Specificity of cancer:');
disp(num2str(cancer_spe));
disp('Diagnostic accuracy:');
disp(num2str(diag_accuracy));
