solfunction crocker_dat = make_vicsek_crocker(ourdata, dimension, fname, maxfilt)
    load_javaplex;
    % set up dimensions of matrix for crocker plot
    filtrationgap = .05;
    filtrationtimes = 0:filtrationgap:maxfilt;
    timesamples = 50;
    crocker_dat = 0*ones(length(filtrationtimes), timesamples);
    endstep = size(ourdata, 2)/3;
    
    for i = 1:timesamples,
        % convert sample number to frame number and extract the x, y data to <thisframe>
        framenum = sampletoframe(i, timesamples, endstep);
        indx = framenum*3;
        thisframe = ourdata(:, [indx-2, indx-1, indx] );

        % calculate persistent homology on this frame
        %m_space = metric.impl.EuclideanMetricSpace(thisframe);
        distances = vicsek_distance(thisframe);
        m_space = metric.impl.ExplicitMetricSpace(distances);
        stream = api.Plex4.createVietorisRipsStream(m_space, dimension+1, maxfilt, 50);
        persistence = api.Plex4.getModularSimplicialAlgorithm(3, 2);
        intervals = persistence.computeIntervals(stream);

        % get barcode's endpoints, and calculate how many intersect with each
        % filtration time that we sample
        endpoints = edu.stanford.math.plex4.homology.barcodes.BarcodeUtility.getEndpoints(intervals, dimension, 0);
        for j = 1:size(endpoints, 1),
            % increments all filtrations times, for a fixed persistence
            % interval and frame, that intersect the interval
            indx = (filtrationtimes >= endpoints(j, 1) & (filtrationtimes <= endpoints(j, 2)));
            crocker_dat(:, i) = crocker_dat(:, i) + indx';
        end

    end

    % make our contour plot with provided contours
    y = 0:filtrationgap:maxfilt;
    x = 1:timesamples;
    for i = 1:timesamples
        x(1, i) = sampletoframe(i, timesamples, endstep);
    end
    x = .5 * x;
    %[X, Y] = meshgrid(x,y);
    han = figure;
    %[C, h] = contour(x, y, crocker_dat, 1:10, 'ShowText','on');
    if dimension == 0
        contours = 2:10;
    else
        contours = 1:10;
    end
    [C, h] = contour(x, y, crocker_dat, contours);
    xlabel('Time (s)');
    ylabel('Filtration parameter');
    %hgexport(han, fname);
    %hgsave(fname);
    saveas(han, char(fname), 'png');
end