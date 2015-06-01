point_cloud = load('frame1coords.txt');
m_space = metric.impl.EuclideanMetricSpace(point_cloud);
stream = api.Plex4.createVietorisRipsStream(point_cloud, 2, 4, 100);
persistence = api.Plex4.getModularSimplicialAlgorithm(3, 2);
intervals = persistence.computeIntervals(stream);
options.filename = 'ripsFrame1';
options.maxFilt = 4;
options.maxDim = 2;
plot_Barcodes(intervals, options);
