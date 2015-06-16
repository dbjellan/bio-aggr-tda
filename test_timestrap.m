clear all;
load_javaplex

javaaddpath('/Users/dbjellan/Desktop/commons-lang3-3.4/commons-lang3-3.4.jar');

points = [0 0; 1 0; 0 1; 1 1; .5 1.5; 3 3];

timestrapper = VeitorisRipsTimeStrapper(2, 1.1);
for i = 1:4
    timestrapper.addComplex(points+ .05*randn(size(points)));
end

barcodes = timestrapper.performTimeStrap();
barcodes.toString()

%plot_barcodes(barcodes);

transformer = homology.filtration.IdentityConverter.getInstance();
filtration_value_intervals = transformer.transform(barcodes);
plot_barcodes(filtration_value_intervals);