function r = sampletoframe(sample, numsamples, numframes)
    r = floor(sample * numframes / numsamples);
end
