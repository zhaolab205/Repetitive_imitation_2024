%% Figure 4

clc
clear
load('sim_result_neg_IFG.mat')
IFG_data = sim_results;
load('sim_result_neg_STS.mat')
STS_data = sim_results;
load('sim_result_neg_IPL.mat')
IPL_data = sim_results;

dPTE_results = zeros(80,18);
for fnirs_time = 1:3
    
    
    for sub_num = 1 : 80
        IFG_sub_data = IFG_data(sub_num,:,fnirs_time)';
        STS_sub_data = STS_data(sub_num,:,fnirs_time)';
        IPL_sub_data = IPL_data(sub_num,:,fnirs_time)';
        [dPTE_results(sub_num,6*(fnirs_time-1)+1),dPTE_results(sub_num,6*(fnirs_time-1)+2)]=transfer_entropy(IFG_sub_data,STS_sub_data);
        [dPTE_results(sub_num,6*(fnirs_time-1)+3),dPTE_results(sub_num,6*(fnirs_time-1)+4)]=transfer_entropy(IFG_sub_data,IPL_sub_data);
        [dPTE_results(sub_num,6*(fnirs_time-1)+5),dPTE_results(sub_num,6*(fnirs_time-1)+6)]=transfer_entropy(STS_sub_data,IPL_sub_data);
        
    end
    
end

load('sim_result_pos_IFG.mat')
IFG_data = sim_results;
load('sim_result_pos_STS.mat')
STS_data = sim_results;
load('sim_result_pos_IPL.mat')
IPL_data = sim_results;

dPTE_results_pos = zeros(80,18);
for fnirs_time = 1:3
    
    
    for sub_num = 1 : 80
        IFG_sub_data = IFG_data(sub_num,:,fnirs_time)';
        STS_sub_data = STS_data(sub_num,:,fnirs_time)';
        IPL_sub_data = IPL_data(sub_num,:,fnirs_time)';
        [dPTE_results_pos(sub_num,6*(fnirs_time-1)+1),dPTE_results_pos(sub_num,6*(fnirs_time-1)+2)]=transfer_entropy(IFG_sub_data,STS_sub_data);
        [dPTE_results_pos(sub_num,6*(fnirs_time-1)+3),dPTE_results_pos(sub_num,6*(fnirs_time-1)+4)]=transfer_entropy(IFG_sub_data,IPL_sub_data);
        [dPTE_results_pos(sub_num,6*(fnirs_time-1)+5),dPTE_results_pos(sub_num,6*(fnirs_time-1)+6)]=transfer_entropy(STS_sub_data,IPL_sub_data);
        
    end
    
end

for i = 1 : 18
    
    [h(i,1),p(i,1),ci,stat]=ttest(dPTE_results_pos(:,i),dPTE_results(:,i));
    stat_t(i,1) = stat.tstat;
    
end








