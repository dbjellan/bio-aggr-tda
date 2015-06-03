% converts sample number to frame number. Minimum frame is 2 since that is
% the first collected frame in our dataset
function r = sampletoframe(sample, numsamples, numframes)
    r = max(2, floor(sample * numframes / numsamples));
end
