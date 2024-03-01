
% sim_matrix = pattern_similarity_analysis(vector_matrix,dis)
% vector_matri(size:n*m): n vector * m fecture
% dis: 1 cosine similarity
%      2 adjusted cosine similarity
%      3 Pearson's correlation
function sim_matrix = pattern_similarity_analysis(vector_matrix,dis)
% 1 cosine similarity
if dis == 1 
    sim_matrix = squareform(1-pdist(vector_matrix,'cosine'));
end
%2 adjusted cosine similarity
if dis == 2
    feature_mean = mean(vector_matrix);
    vector_matrix = vector_matrix-feature_mean;
    sim_matrix = squareform(1-pdist(vector_matrix,'cosine'));
end
% 3 Pearson's correlation
if dis == 3
    sim_matrix = corr(vector_matrix');
end
