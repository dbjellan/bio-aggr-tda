%point_cloud = [-0.18948, -0.021266; -0.17512, 0.005759; -0.16467, -0.018453; -0.1271, 0.010114; -0.13533, 0.034321; -0.112, -0.0080129; -0.11276, -0.020114; -0.089773, -0.11076; -0.086291, -0.041335; -0.061133, -0.0034352; -0.045374, -0.053467; -0.00257, 0.04227; -0.14426, 0.010507; -0.1475, -0.02076; -0.13319, -0.011004; -0.18082, -0.077383; -0.014861, 0.12195; -0.14136, -0.0091204; -0.14336, -0.013028];

function plotpersistence(data, expnum, framenum),
%data = load('aphiddata.csv');
%expnum = 1;
%framenum = 2;    
    load_javaplex;
    
    indx = (data(:, 1) == expnum);
    sim1 = data(indx, [3 4 5]);

    indx = (sim1(:, 1) == framenum);
    sim1 = sim1(indx, [2 3]);

    %fname = which('load_javaplex');
    %[pathstr,name,ext] = fileparts(fname);
    %cd(pathstr);
    %load_javaplex;
    
    m_space = metric.impl.EuclideanMetricSpace(sim1);
    stream = api.Plex4.createVietorisRipsStream(sim1, 2, 4, 500);
    persistence = api.Plex4.getModularSimplicialAlgorithm(3, 2);
    intervals = persistence.computeIntervals(stream);
    options.filename = 'ripsFrame1';
    options.max_filtration_value = 0.1;
    options.max_dimension = 2;
    plot_barcodes(intervals, options);

   
    end