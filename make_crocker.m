

% load data from our experiment
expnum = 1;
aphiddata = load('aphiddata.csv');
indx = (aphiddata(:, 1) == expnum);
ourdata = aphiddata(indx, [3 4 5]);
endframe = max(ourdata(:, 1));

% set up dimensions of matrix for crocker plot
maxfiltration = .3;
filtrationgap = .001;
filtrationtimes = 0:filtrationgap:maxfiltration;
timesamples = 2000;
crocker_dat = 0*ones(length(filtrationtimes), timesamples);

for i = 1:timesamples,
    % convert sample number to frame number and extract the x, y data to <thisframe>
    framenum = sampletoframe(i, timesamples, endframe);
    indx = (ourdata(:, 1) == framenum);
    thisframe = ourdata(indx, [2 3]);

    % calculate persistent homology on this frame
    m_space = metric.impl.EuclideanMetricSpace(thisframe);
    stream = api.Plex4.createVietorisRipsStream(thisframe, 2, .1, 1000);
    persistence = api.Plex4.getModularSimplicialAlgorithm(3, 2);
    intervals = persistence.computeIntervals(stream);
    
    % get barcode's endpoints, and calculate how many intersect with each
    % filtration time that we sample
    endpoints = edu.stanford.math.plex4.homology.barcodes.BarcodeUtility.getEndpoints(intervals, 0, 0);
    for j = 1:size(endpoints, 1),
        % increments all filtrations times, for a fixed persistence
        % interval and frame, that intersect the interval
        indx = (filtrationtimes >= endpoints(j, 1) & (filtrationtimes <= endpoints(j, 2)));
        crocker_dat(:, i) = crocker_dat(:, i) + indx';
    end
    
end

% make our contour plot with provided contours 
contour(crocker_dat, [1:10]);
    