function nbits_additional = find_traceback_bits(current_decomp_level, num_decomp_levels, bitmapping)

nbits_additional = 0;

for i = 1:num_decomp_levels - current_decomp_level - 1
    [row col] = size(bitmapping);
    new_map = mat2cell(bitmapping, 2.*ones(1,row/2), 2.*ones(1,col/2));
    sum_mat = zeros(row/2, col/2);
    for ii = 1:row/2
        for jj = 1:col/2
            %create a 'sum' matrix
            sum_mat(ii,jj) = sum(sum(new_map{ii,jj}));         
        end
    end
    
    sum_mat = sum_mat > 0;
    nbits_additional = nbits_additional + 8*sum(sum(sum_mat));
    bitmapping = sum_mat;
end
bitmapping = bitmapping + 2;
