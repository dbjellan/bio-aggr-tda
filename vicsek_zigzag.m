function vicsek_zigzag(ourdata, fname)
    load_javaplex;
    javaaddpath('./');
    
    timestrapper = VeitorisRipsTimeStrapper(2, .8, true);
    for i = 1:300
        indx = i*3*10;
        thisframe = ourdata(:, [indx-2, indx-1, indx] );
        timestrapper.addComplex(thisframe);
    end
    barcodes = timestrapper.performTimeStrap();
    barcodes.toString()

    transformer = homology.filtration.IdentityConverter.getInstance();
    filtration_value_intervals = transformer.transform(barcodes);
    
    options.filename = char(fname);
    options.max_dimension = 2;    
    plot_barcodes(filtration_value_intervals, options);
end