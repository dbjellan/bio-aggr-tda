function vicsek_persistence(frame, fname, numpoints)
    load_javaplex;
    
    distances = vicsek_distance(frame);
    m_space = metric.impl.ExplicitMetricSpace(distances);
    %stream = api.Plex4.createVietorisRipsStream(frame, 2, 4, 500);
    maxmin_selector = api.Plex4.createMaxMinSelector(m_space, numpoints);
    stream = api.Plex4.createWitnessStream(maxmin_selector, 2, 1, 300);
    persistence = api.Plex4.getModularSimplicialAlgorithm(3, 2);
    
    %intervals = persistence.computeIntervals(stream);
    options.filename = char(fname);
    options.max_filtration_value = 1;
    options.max_dimension = 2;

    intervals = persistence.computeIntervals(stream);
    endpoints = edu.stanford.math.plex4.homology.barcodes.BarcodeUtility.getEndpoints(intervals, 0, 0);
    sort(endpoints);
    plot_barcodes(intervals, options);
end