function [nparams, ncrocker_result] = downsample(params, crocker_result, samples),
%this function takes a set of parameters, and array of crocker plots, and
%returns a subsample of size <samples>
    original_sample = length(params)
    num_runs = size(crocker_result, 1)/length(params);
    nparams = zeros(samples, 3);
    for i = 1:samples,
        frame = sampletoframe(i, samples, original_sample)
        nparams(i, :) = params(frame);
        ncrocker_result((i*num_runs-19):i*num_runs, :, :) = crocker_result((frame*num_runs-19):frame*num_runs, :, :)
    end
end