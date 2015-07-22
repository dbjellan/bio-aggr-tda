function [avg_distance_matrix, distance_matrix, crocker_result] = compare_vicsek_crockers(params, maxfilt, dimension)
    % params = [0.0075384 0.25128 .1; 0.0075384 0.25128 .3;]
    timesteps = 2000;
    numruns = 3;
    numparticles = 300;
    numparamchoices = size(params, 1);
    
    for i = 1:numparamchoices,
        i
        v_0 = params(i, 1);
        r = params(i, 2);
        sigma = params(i, 3);
        for j = 1:numruns,
            j
            sol = simulate_vicsek(numparticles, timesteps, v_0, r, sigma);
            crocker_result(numruns*(i-1)+j, :, :) = make_vicsek_crocker(sol, dimension, 'test.png', maxfilt);
            pol(:, numruns*(i-1)+j) = polarization(sol);
        end
    end
    distance_matrix = crocker_metric(crocker_result)
    pol;
    hold;
    scatter(1:timesteps, pol(:, 1));
    scatter(1:timesteps, pol(:, numruns+1));
    hold off;
    avg_distance_matrix = zeros(numparamchoices);
    for i = 1:numparamchoices,
        for j = 1:numparamchoices,
            avg_distance_matrix(i, j) = sum(sum(distance_matrix((i-1)*numparamchoices+1:numparamchoices*i, (j-1)*numparamchoices+1:numparamchoices*j)))/numparamchoices^2;
        end
    end
    clusters = kmedoids(distance_matrix, size(params, 2));
    clusters
end

function distance_matrix = crocker_metric(crocker_result),
    numtrials = size(crocker_result, 1);
    distance_matrix = zeros(numtrials);
    for i = 1:numtrials,
        for j = 1:numtrials,
            distance_matrix(i, j) = sum(sum(abs(crocker_result(i, :, :) - crocker_result(j, :, :))));
        end
    end
end

function pol = polarization(sol)
    pol = zeros(size(sol, 2)/3, 1);
    for i = 1:length(pol),
        pol(i) = sum(sol(:, i*3));
    end
end