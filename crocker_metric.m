
function distance_matrix = crocker_metric(crocker_result),
    numtrials = size(crocker_result, 1);
    distance_matrix = zeros(numtrials);
    for i = 1:numtrials,
        for j = 1:numtrials,
            distance_matrix(i, j) = sum(sum(abs(crocker_result(i, :, :) - crocker_result(j, :, :))));
        end
    end
end