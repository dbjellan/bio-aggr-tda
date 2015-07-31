a = [0.0075384 0.25128 .2]

params = [];
for i = -.007:.001:.007
    for j = -.2:02:.2
        for k = -.15:.02:.15
           params = [params; a(1)+i, a(2)+j, a(3)+k];
        end
    end
end

[avg_distance_matrix, distance_matrix, crocker_result] = compare_vicsek_crockers(params, 1.6, 0)
save('grid', 'avg_distance_matrix', 'distance_matrix', 'crocker_result');