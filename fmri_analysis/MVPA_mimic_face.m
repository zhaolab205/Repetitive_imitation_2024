%% Figure 5
clear all
%% pre-task
pre_dir = 'xxx\pre_test\face';
post_dir = 'xxx\post_test\face';


pos_imgs = spm_select('FPListRec', pre_dir, 'con_0001.nii');
neg_imgs = spm_select('FPListRec', pre_dir, 'con_0003.nii');
data = fmri_data([pos_imgs;neg_imgs], gray_matter_mask);


mask = 'xxx\rr001MNS.nii';
data = apply_mask(data, mask);

data.Y = [ones(80,1); -ones(80,1)]; 

%%Training
[~, stats] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr');

n_folds = [(1:160)];
n_folds = n_folds(:); 

[~, stats_loso] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds', n_folds, 'error_type', 'mcr');


%% post-task
pos_dir = 'xxx\pos_test\face';
pre_results_dir = 'xxx\pre_test\face';

pos_imgs = spm_select('FPListRec', pos_dir, 'con_0001.nii');
neg_imgs = spm_select('FPListRec', pos_dir, 'con_0003.nii');
data = fmri_data([pos_imgs;neg_imgs], gray_matter_mask);


data = apply_mask(data, mask);
%%Outcome
data.Y = [ones(80,1); -ones(80,1)]; 

%%Training
[~, stats] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr');

n_folds = [(1:160)];
n_folds = n_folds(:); 

[~, stats_loso] = predict(data, 'algorithm_name', 'cv_svm', 'nfolds', n_folds, 'error_type', 'mcr');


