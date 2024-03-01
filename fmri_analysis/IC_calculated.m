
%% Figure 6

clc
clear

IC_mask = dir(fullfile('xxx\BN_submask','BN*'));

seed_mask = 'xxx\MNS.nii';

datadir = 'xxx\pre_test\face_single';
IC_result_MNS_positive_pre = informational_connectivity_face(datadir,seed_mask,IC_mask,'positive');

IC_result_MNS_negative_pre = informational_connectivity_face(datadir,seed_mask,IC_mask,'negative');


datadir = 'xxx\face_single';
IC_result_MNS_positive_post = informational_connectivity_face(datadir,seed_mask,IC_mask,'positive');

IC_result_MNS_negative_post = informational_connectivity_face(datadir,seed_mask,IC_mask,'negative');




seed_mask = 'xxx\rr001IFG.nii';

datadir = 'xxx\pre_test\face_single';
IC_result_IFG_positive_pre = informational_connectivity_face(datadir,seed_mask,IC_mask,'positive');

IC_result_IFG_negative_pre = informational_connectivity_face(datadir,seed_mask,IC_mask,'negative');


datadir = 'xxx\post_test\face_single';
IC_result_IFG_positive_post = informational_connectivity_face(datadir,seed_mask,IC_mask,'positive');

IC_result_IFG_negative_post = informational_connectivity_face(datadir,seed_mask,IC_mask,'negative');




