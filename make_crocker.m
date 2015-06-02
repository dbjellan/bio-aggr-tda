
timesamples = 1000;
filtrationsamples = 500;

expnum = 1;
aphiddata = load('aphiddata.csv');
indx = (aphiddata(:, 1) == expnum);
ourdata = aphiddata(indx, [3 4 5]);

endframe = max(ourdata(:, 1));

maxfiltration = .3;
filtrationgap = .01;
filtrationtimes = 0:filtrationgap:maxfiltration;

crocker_dat = 0*ones(length(filtrationtimes), timesamples);

for i = 1:timesamples,
    framenum = sampletoframe(i, timesamples, endframe);
    indx = (ourdata(:, 1) == framenum);
    thisframe = ourdata(indx, [2 3]);

    m_space = metric.impl.EuclideanMetricSpace(thisframe);
    stream = api.Plex4.createVietorisRipsStream(thisframe, 2, 4, 500);
    persistence = api.Plex4.getModularSimplicialAlgorithm(3, 2);
    intervals = persistence.computeIntervals(stream);
    
    endpoints = edu.stanford.math.plex4.homology.barcodes.BarcodeUtility.getEndpoints(intervals, 0, 0);
    for j = 1:size(endpoints, 1),
        thisendpoint = endpoints(j, :);
        indx = (filtrationtimes >= endpoints(j, 1) & (filtrationtimes <= endpoints(j, 2)));
        crocker_dat(:, i) = crocker_dat(:, i) + indx';
    end
    
end

contour(crocker_dat, [1 2 3 4 5]);
    