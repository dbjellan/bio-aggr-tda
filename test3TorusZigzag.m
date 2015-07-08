clear all;
load_javaplex;

javaaddpath('./');

%points = [0 0; 1 0; 0 1; 1 1; .5 1.5; 3 3];

points = zeros(10, 3);
%d = (0:2*pi/10:2*pi)
points(:, 1) = 2*pi*rand(10, 1);
timestrapper = VeitorisRipsTimeStrapper(2, .8,true);
points = 2*pi*rand(50, 3);
timestrapper.addComplex(points);
for i = 1:8
    points = zeros(50, 3);
    %d = (0:2*pi/10:2*pi)
    points(:, 1) = 2*pi*rand(50, 1);
    %points = 2*pi*rand(500, 3);
    timestrapper.addComplex(points);
end

barcodes = timestrapper.performTimeStrap();
barcodes.toString()

iter = barcodes.getIntervalGeneratorPairIterator();
%plot_barcodes(barcodes);

transformer = homology.filtration.IdentityConverter.getInstance();
filtration_value_intervals = transformer.transform(barcodes);
plot_barcodes(filtration_value_intervals);