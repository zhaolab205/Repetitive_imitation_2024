%% neural pattern similarity (NPS) during imitation

function sim_result = mimic_singleNPS(datadir,FilesStruct,design_inf,data_type,ROI,sim_type,emotion_type,sum_type)

nsub = length(FilesStruct);
HRF=30; %6S
ntime = 30;
sim_result = zeros(nsub,ntime);


nan_signal = zeros(89,5);
for sub_num = 1 :nsub
    disp(sub_num)

    load([datadir,'\',FilesStruct(sub_num).name])

   if data_type == 2
        channel_signal = phase_scrambled_analysis(nirsdata.oxyData(:,ROI));
    end
    
    
    if data_type == 1
        channel_signal = nirsdata.oxyData(:,ROI);
    end

    for time_num = 1 : ntime
        
        time_data = zeros(60,length(ROI));
        for emo_num = 1 : 5
            break_trial = 13;
            for trial_num = 1 : length(design_inf{sub_num+1,emo_num+1})
                signal_point = round(design_inf{sub_num+1,emo_num+1}(trial_num,1))+time_num-1+HRF;
                if signal_point > length(channel_signal) 
                    break_trial = trial_num;
                    break
                end
                time_data((emo_num-1)*12+trial_num,:) = channel_signal(signal_point,:);
                
            end
            if length(design_inf{sub_num+1,emo_num+1}) < 12 || break_trial<=12
                nan_signal(sub_num,emo_num) = 12 - min(break_trial,length(design_inf{sub_num+1,emo_num+1}))+1;
                for trial_num = min(break_trial,length(design_inf{sub_num+1,emo_num+1})) : 12
                    time_data((emo_num-1)*12+trial_num,:) = mean(time_data((emo_num-1)*12+1:(emo_num-1)*12+length(design_inf{sub_num+1,emo_num+1}),:));
                end
            end
 
        end
        sim_matrix = pattern_similarity_analysis(time_data,sim_type);
        if strcmpi(sum_type,'between_emo')  %negative vs positive
            sim_result(sub_num,time_num) =  (sum(sum(sim_matrix((emotion_type-1)*12+1:emotion_type*12,:)))-sum(sum(sim_matrix((emotion_type-1)*12+1:emotion_type*12,(emotion_type-1)*12+1:emotion_type*12))))/576;
        end
        
        if strcmpi(sum_type,'within_emo')  %positive vs positive
            sim_result(sub_num,time_num) =  sum(sum(sim_matrix((emotion_type-1)*12+1:emotion_type*12,(emotion_type-1)*12+1:emotion_type*12)))/132;
        end
        
        if strcmpi(sum_type,'except_emo')  
            sim_result(sub_num,time_num) =  (sum(sum(sim_matrix))-2*sum(sum(sim_matrix((emotion_type-1)*12+1:emotion_type*12,:)))+sum(sum(sim_matrix((emotion_type-1)*12+1:emotion_type*12,(emotion_type-1)*12+1:emotion_type*12))))/2256;
        end
        if strcmpi(sum_type,'within_other')  %negative vs negative
            sim_result(sub_num,time_num) =  (sum(sum(sim_matrix(1:12,1:12)))+sum(sum(sim_matrix(13:24,13:24)))+sum(sum(sim_matrix(25:36,25:36)))+sum(sum(sim_matrix(37:48,37:48)))+sum(sum(sim_matrix(49:60,49:60)))-sum(sum(sim_matrix((emotion_type-1)*12+1:emotion_type*12,(emotion_type-1)*12+1:emotion_type*12))))/132/4;
        end
        

        
        
        
    end
    
    
end