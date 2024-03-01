function mean_dediagonal_value = mean_dediagonal(matrix,condition_num,sum_type)
% sum_type: 1 去除对角线  2 只包含对角线
sum_matrix = 0;
n_matrix = 0;
ncondition = length(condition_num);
for con_x = 1 : ncondition
    
    if sum_type == 1
        for con_y = con_x+1 : ncondition
            
            n_matrix = n_matrix + condition_num(con_x)*condition_num(con_y);
            sum_matrix = sum_matrix + sum(sum(matrix(sum(condition_num(1:con_x))-condition_num(con_x)+1:sum(condition_num(1:con_x)),sum(condition_num(1:con_y))-condition_num(con_y)+1:sum(condition_num(1:con_y)))));
        end
    end
    
    if sum_type == 2
        n_matrix = n_matrix + condition_num(con_x)*condition_num(con_x);
        sum_matrix = sum_matrix + sum(sum(matrix(sum(condition_num(1:con_x))-condition_num(con_x)+1:sum(condition_num(1:con_x)),sum(condition_num(1:con_x))-condition_num(con_x)+1:sum(condition_num(1:con_x)))));
    end
    
end
mean_dediagonal_value = sum_matrix/n_matrix;