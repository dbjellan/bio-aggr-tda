function confusion = make_confusion(labels, indxs, runs)
%makes confusion matrix for classifying crcoker plots. Takes in the labels
%of the clusters, the indxs of the of the centroids, and the number of runs
%each parameter was run for. this version uses the sometimes incorrect
%approach of assuming the modal classification is correct
    target = []
    for i = 0:length(labels)/runs-1
        correct = mode(labels(i*20+1:(i+1)*20));
        for j = 1:runs
            target(i*20+j) = correct;
        end
    end
    confusion = cfmatrix2(labels, target, 1:length(labels)/runs); 
end