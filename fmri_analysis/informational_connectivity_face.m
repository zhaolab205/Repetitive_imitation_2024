%% informational connectivity

function IC_results = informational_connectivity_face(datadir,seed_mask,IC_mask,emo_type)

SubFilesStruct  = dir(fullfile(datadir,'sub*'));  
nsub = length(SubFilesStruct);
IC_results=zeros(nsub,length(IC_mask));

for sub_num = 1 :nsub
    subdatadir = [datadir,'\',SubFilesStruct(sub_num).name];
    load([subdatadir,'\','SPM.mat'])
    condition_index = zeros(130,1);
    for beta_num = 1 : length(SPM.Vbeta)
        if SPM.Vbeta(beta_num).descrip(29)=='h'
            condition_index(beta_num) = 1;
        elseif sum(SPM.Vbeta(beta_num).descrip(29)==['a','f'])
            condition_index(beta_num) = 2;
        elseif sum(SPM.Vbeta(beta_num).descrip(29)==['n'])
            condition_index(beta_num) = 3;
        elseif sum(SPM.Vbeta(beta_num).descrip(29)==['s'])
            condition_index(beta_num) = 4;
        end
    end
    positive_index = find(condition_index==1);
    negative_index = find(condition_index==2);
    neutral_index = find(condition_index==3);
    scramble_index = find(condition_index==4);
    if strcmpi(emo_type,'positive')
        condition_index1 = positive_index;
    end
    if strcmpi(emo_type,'negative')
        condition_index1 = negative_index;
    end
    condition_index2 = neutral_index;
    condition_index4 = scramble_index;
    clear img_pos img_neg
    for img_num = 1 : length(condition_index1)
        img_con1(img_num,:) =  [subdatadir,'\','beta_',num2str(condition_index1(img_num),'%04d'),'.nii'];
        
    end
    
    for img_num = 1 : length(condition_index2)
        img_con2(img_num,:) =  [subdatadir,'\','beta_',num2str(condition_index2(img_num),'%04d'),'.nii']; 
    end
    
    for img_num = 1 : length(condition_index4)
        img_scr(img_num,:) =  [subdatadir,'\','beta_',num2str(condition_index4(img_num),'%04d'),'.nii']; 
    end
    
    
    seed_acc_within = zeros(length(condition_index1)+length(condition_index2),1);
    seed_acc_between = zeros(length(condition_index1)+length(condition_index2),1);
    data_con1_ori = fmri_data(img_con1);
    data_con2_ori = fmri_data(img_con2);
    
    data_con1_seed = apply_mask(data_con1_ori, seed_mask);
    data_con1_seed = double(data_con1_seed.dat);
    
    data_con2_seed = apply_mask(data_con2_ori, seed_mask);
    data_con2_seed = double(data_con2_seed.dat);
    
    seed_acc_within(1:length(condition_index1),1) = fisher_r_to_z(corr(data_con1_seed,mean(data_con1_seed,2)));
    seed_acc_within(1+length(condition_index1):end,1) = fisher_r_to_z(corr(data_con2_seed,mean(data_con2_seed,2)));
    
    seed_acc_between(1:length(condition_index1),1) = fisher_r_to_z(corr(data_con1_seed,mean(data_con2_seed,2)));
    seed_acc_between(1+length(condition_index1):end,1) = fisher_r_to_z(corr(data_con2_seed,mean(data_con1_seed,2)));
    
    seed_acc = seed_acc_within-seed_acc_between;

    roi_acc = zeros(length(condition_index1)+length(condition_index2),length(IC_mask));
    disp(sub_num)
    for mask_num = 1 : length(IC_mask)
        
        roi_mask = [IC_mask(mask_num).folder,'\',IC_mask(mask_num).name];
        
        roi_acc_within = zeros(length(condition_index1)+length(condition_index2),1);
        roi_acc_between = zeros(length(condition_index1)+length(condition_index2),1);
        
        data_con1_roi = apply_mask(data_con1_ori, roi_mask);
        data_con1_roi = double(data_con1_roi.dat);
        
        data_con2_roi = apply_mask(data_con2_ori, roi_mask);
        data_con2_roi = double(data_con2_roi.dat);
        
        roi_acc_within(1:length(condition_index1),1) = fisher_r_to_z(corr(data_con1_roi,mean(data_con1_roi,2)));
        roi_acc_within(1+length(condition_index1):end,1) = fisher_r_to_z(corr(data_con2_roi,mean(data_con2_roi,2)));
        
        roi_acc_between(1:length(condition_index1),1) = fisher_r_to_z(corr(data_con1_roi,mean(data_con2_roi,2)));
        roi_acc_between(1+length(condition_index1):end,1) = fisher_r_to_z(corr(data_con2_roi,mean(data_con1_roi,2)));
        
        roi_acc(:,mask_num) = roi_acc_within-roi_acc_between;
        IC_results(sub_num,mask_num) = 1-pdist2(seed_acc',roi_acc(:,mask_num)','cosine');
    end



end
