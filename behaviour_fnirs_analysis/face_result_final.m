
%% Figure 1
clc
clear
mimic_train = zeros(80,16,90);
%  1-anger A；2-disgust D；3-fearF；4-happyH；5-sadS;
mimic_mean_emo = zeros(80,16,90);

load('facereader_result.mat')
for emo_num =4 :4
    emo_index = find(facereader_result(:,4)==emo_num);
    emo_data = facereader_result(emo_index,:);
    sub_id = unique(emo_data(:,1));
    for sub_num = 1 : length(sub_id)
        sub_index =  find(emo_data(:,1)==sub_id(sub_num));
        sub_data = emo_data(sub_index,:);
        for time_num = 1 : 16
            
            time_index = find(sub_data(:,2)==time_num);
            time_data = sub_data(time_index,5:94);
            for point_num = 1 : 90
                zero_index = find(time_data(:,point_num)~=0);
                if ~isempty(zero_index)
                    mimic_train(sub_num,time_num,point_num) = mean(time_data(zero_index,point_num));
                end
            end
        end
    end
end


for time_num = 1 : 16
    
    for point_num = 1 : 90
        zero_index = find(mimic_train(:,time_num,point_num)==0);
        non_zero_index = find(mimic_train(:,time_num,point_num)~=0);
        
        if ~isempty(zero_index)
            
            mimic_train(zero_index,time_num,point_num) = mean(mimic_train(non_zero_index,time_num,point_num));
        end
    end
end



% 降维
i = 0;
mimic_data = zeros(80*12,37);
for point_num =1 :3: 90
    i = i+1;

    for time_num = 3:8
        mimic_data((time_num-3)*80+1:(time_num-2)*80,1) = [1 : 80]';
        mimic_data((time_num-3)*80+1:(time_num-2)*80,i+1) = mean(mimic_train(:,time_num,point_num:point_num+2),3);
        mimic_data((time_num-3)*80+1:(time_num-2)*80,36) = time_num;
        mimic_data((time_num-3)*80+1:(time_num-2)*80,37) = time_num;
    end
    
    for time_num = 10:15
        mimic_data((time_num-4)*80+1:(time_num-3)*80,1) = [1 : 80]';
        mimic_data((time_num-4)*80+1:(time_num-3)*80,i+1) = mean(mimic_train(:,time_num,point_num:point_num+2),3);
        mimic_data((time_num-4)*80+1:(time_num-3)*80,36) = time_num;
        mimic_data((time_num-4)*80+1:(time_num-3)*80,37) = time_num;
    end
    
end
mimic_data(:,32)=sum(mimic_data(:,2:31),2);
for i = 1 : 960
    [K,V]=findpeaks(mimic_data(i,2:31));
    if ~isnan(K)
        mimic_data(i,33)=K(1);
        mimic_data(i,34)=V(1);
        mimic_data(i,35)=(K(1)-mimic_data(i,2))./V(1)*5;
    else
        [mimic_data(i,33),mimic_data(i,34)]=max(mimic_data(i,2:31));
        
        mimic_data(i,35)=(mimic_data(i,33)-mimic_data(i,2))./mimic_data(i,34)*5;
    end
end
for i = 1 : 960
    plot([1:30],mimic_data(i,2:31));
    hold on
end



mean_max = zeros(12,2);
for time_num = 1 : 12
    
    mimic_time_data = mimic_data((time_num-1)*80+1:time_num*80,2:31);
    mimic_time_data_mean = mean(mimic_time_data);
    mean_max(time_num,2) = max(mimic_time_data_mean);
    mimic_time_data_std = std(mimic_time_data)/sqrt(80);
    x=[1:30]';
    patch([x; flipud(x)], [mimic_time_data_mean'-mimic_time_data_std'; flipud(mimic_time_data_mean'+mimic_time_data_std')], [169 184 198] / 255, 'FaceA', 0.2, 'EdgeA', 0);
    hold on
    plot(1:30,mimic_time_data_mean,'Color',[250-15*time_num 10 25+15*time_num]/255,'LineWidth',3)
    plot_color(time_num,1:3)=[250-15*time_num 10 25+15*time_num];
    hold on

end
mimic_data_early = mimic_data(1:80*6,:);
mimic_data_late = mimic_data(481:960,:);
mean_max(1:6,1)=3:8;
mean_max(7:12,1)=10:15;
figure
plot(mean_max(:,1),mean_max(:,2),'.')
hold on
for i = 1:11
    PlotLineArrow(gca, [mean_max(i,1), mean_max(i+1,1)], [mean_max(i,2), mean_max(i+1,2)], 'b', 'r', 10);
end


%% 统计数据
auc_data = zeros(12,3);
auc_total = zeros(80,12);
for i = 1 : 12
    auc_data(i,1)=mean(mimic_data((i-1)*80+1:i*80,32));
    auc_total(:,i) = mimic_data((i-1)*80+1:i*80,32)/5;
    auc_data(i,2)=std(mimic_data((i-1)*80+1:i*80,32));
    auc_data(i,3)=80;
    auc_data(i,4)=80;
end

%% 统计数据进行相关分析
max_data = zeros(80,1);
for i = 1 : 80
   max_data(i) = mimic_data(i*80,32)-mimic_data((i-1)*12+1,32);

end

 
 
 %% 寻找最大值的90%  
 
 load('mimic_data_happy.mat')
 success_point = zeros(960,2);
 for i = 1 : 960
     sub_data = mimic_data(i,2:31);
     sub_max = max(sub_data)-sub_data(1);
     sub_data_diff = sub_data-sub_data(1)-sub_max*0.9;
     [max_value,success_point(i,2)] = max(sub_data);
     for time_num = 1 :29
         
         if sub_data_diff(time_num)<0 && sub_data_diff(time_num+1)>0
             success_point(i,1) = time_num+1;
             break
         end
         
     end
     if success_point(i,1)==0
         success_point(i,1) = 1;
     end
     
     
 end