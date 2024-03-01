%% Figure 3
clc
clear
%%
% LIFG:1 2 3 4 5 6 7 8 9
% RIFG:22 23 24 25 26 27 28 29 30
% LSTS:10 13 15 16 17
% RSTS:31 34 36 37 38
% LIPL:11 12 14 18 19 20 21
% RIPL:32 33 35 39 40 41 42
load('channel_seq.mat')
ROI = channel_seq(1:42);
ntime=30;
sim_type = 2;  % adjusted cosine
emo_num = 4;  %happy
sim_results_mean = zeros(ntime,3);
sim_results = zeros(80,ntime,3);
sim_results_std = zeros(ntime,3);

%t2
datadir = 'xxx\fnirs_data\t2';  
FilesStruct  = dir(fullfile(datadir,'*mat'));   
load('design_inf_t2.mat')

sim_result = mimic_singleNPS(datadir,FilesStruct,design_inf,1,ROI,sim_type,emo_num,'within_emo');
sim_results(:,:,1) = sim_result;
sim_results_mean(:,1) = mean(sim_result);
sim_results_std(:,1) = std(sim_result);
[~,sim_results_max(:,1)] = min(sim_result,[],2);
x=[1:ntime]';
patch([x; flipud(x)], [mean(sim_result)'-std(sim_result)'/sqrt(80); flipud(mean(sim_result)'+std(sim_result)'/sqrt(89))], [169 184 198] / 255, 'FaceA', 0.2, 'EdgeA', 0);
hold on 
plot(1:ntime,mean(sim_result),'Color',[20 81 124]/255,'LineWidth',3)
hold on

%t9
datadir = 'xxx\fnirs_data\t9';  
FilesStruct  = dir(fullfile(datadir,'*mat'));   
load('design_inf_t9.mat')

sim_result = mimic_singleNPS(datadir,FilesStruct,design_inf,1,ROI,sim_type,emo_num,'within_emo');
sim_results(:,:,2) = sim_result;
sim_results_mean(:,2) = mean(sim_result);
sim_results_std(:,2) = std(sim_result);
[~,sim_results_max(:,2)] = min(sim_result,[],2);

x=[1:ntime]';
patch([x; flipud(x)], [mean(sim_result)'-std(sim_result)'/sqrt(80); flipud(mean(sim_result)'+std(sim_result)'/sqrt(89))], [169 184 198] / 255, 'FaceA', 0.2, 'EdgeA', 0);
hold on 
plot(1:ntime,mean(sim_result),'Color',[47 127 193]/255 ,'LineWidth',3)
hold on

%t16
datadir = 'xxx\fnirs_data\t16';  
FilesStruct  = dir(fullfile(datadir,'*mat'));  
load('design_inf_t16.mat')

sim_result = mimic_singleNPS(datadir,FilesStruct,design_inf,1,ROI,sim_type,emo_num,'within_emo');
sim_results(:,:,3) = sim_result;
sim_results_mean(:,3) = mean(sim_result);
sim_results_std(:,3) = std(sim_result);
[~,sim_results_max(:,3)] = min(sim_result,[],2);

x=[1:ntime]';
patch([x; flipud(x)], [mean(sim_result)'-std(sim_result)'/sqrt(80); flipud(mean(sim_result)'+std(sim_result)'/sqrt(89))], [169 184 198] / 255, 'FaceA', 0.2, 'EdgeA', 0);
hold on 
plot(1:ntime,mean(sim_result),'Color',[150 195 125]/255,'LineWidth',3)
hold on

for i = 1 : 30
    
    [h(i,1),p(i,1)]= ttest(sim_results(:,i,1),sim_results(:,i,2));
    [h(i,2),p(i,2)]= ttest(sim_results(:,i,2),sim_results(:,i,3));
    [h(i,3),p(i,3)]= ttest(sim_results(:,i,1),sim_results(:,i,3));
end
FDR_P(:,1) = mafdr(p(:,1),'BHFDR', true);
FDR_P(:,2) = mafdr(p(:,2),'BHFDR', true);
FDR_P(:,3) = mafdr(p(:,3),'BHFDR', true);
sim_auc=reshape(sum(sim_results,2),[80,3]);
[h_auc(1,1),p_auc(1,1),ci,stat]= ttest(sim_auc(:,2),sim_auc(:,1));
t_auc(1,1) = stat.tstat;
[h_auc(1,2),p_auc(1,2),ci,stat]= ttest(sim_auc(:,3),sim_auc(:,2));
t_auc(1,2) = stat.tstat;
[h_auc(1,3),p_auc(1,3),ci,stat]= ttest(sim_auc(:,3),sim_auc(:,1));
t_auc(1,3) = stat.tstat;
t_auc(2,1:3) = mafdr(p_auc,'BHFDR', true);