%arams = [0.0075384 0.25128 .1; 0.0075384 0.25128 .3;]
function avg_distance_matrix = compare_vicsek_crockers(params, maxfilt, dimension)
    timesteps = 2000;
    numruns = 10;
    numparticles = 300;
    numparamchoices = size(params(1), 1)
    for i = 1:numparamchoices,
        i
        v_0 = params(i, 1);
        r = params(i, 2);
        sigma = params(i, 3);
        for j = 1:numruns,
            j
            sol = simulate_vicsek(numparticles, timesteps, v_0, r, sigma);
            crocker_result(:, :, numruns*(i-1)+j) = make_vicsek_crocker(sol, dimension, 'test.png', maxfilt);
        end
    end
    distance_matrix = crocker_metric(crocker_result);
    avg_distance_matrix = zeroes(numparamchoices);
    for i = 1:numparamchoices,
        for j = 1:numparamchoices,
            avg_distance_matrix(i, j) = sum(sum(distance_matrix((i-1)*numparamchoices+1:numparamchoices*i, (i-1)*numparamchoices+1:numparamchoices*i)));
        end
    end
    
end

function distance_matrix = crocker_metric(crocker_result),
    numtrials = size(crocker_result, 1);
    distance_matrix = zeroes(numtrials);
    for i = 1:numtrials,
        for j = 1:numtrials,
            distance_matrix(i, j) = abs(sum(sum(crocker_result(i, :, :) - crocker_result(j, :, :))));
        end
    end
end