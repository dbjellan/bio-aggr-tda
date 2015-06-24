clear all;
load_javaplex;

javaaddpath('./');

points = [0 0; 1 0; 0 1; 1 1; .5 1.5; 3 3];

timestrapper = VeitorisRipsTimeStrapper(2, 1.1, false);
for i = 1:8
    timestrapper.addComplex(points + .005*randn(size(points)) + (i*.05));
end

barcodes = timestrapper.performTimeStrap();
barcodes.toString()

%plot_barcodes(barcodes);

transformer = homology.filtration.IdentityConverter.getInstance();
filtration_value_intervals = transformer.transform(barcodes);
plot_barcodes(filtration_value_intervals);