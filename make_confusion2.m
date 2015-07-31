function [confusion, target] = make_confusion2(labels, indxs, runs)
%makes confusion matrix for classifying crcoker plots. Takes in the labels
%of the clusters, the indxs of the of the centroids, and the number of runs
%each parameter was run for
    target = zeros(size(labels));
    for i = 1:length(indxs),
       indx = indxs(:, i)
       start = idivide(indx, int32(runs));
       start = start *20+1;
       last = start+19;
       target(:, start:last) = i;
    end
    size(target)
    size(labels)
    confusion = cfmatrix2(labels, target, 1:length(labels)/runs); 
end