% fname is path to aphiddata.csv file
% plots the trajectories of the <expnum> experiment
% sample usage: plotaphid('aphiddata.csv', 1);
function plotaphi(fname, expnum)

    aphiddata = load(fname);

    % grabs the [frame number, x coord, y coord] of first experiment 
    indx = ( aphiddata(:,1) ==expnum);
    sim1fxy = aphiddata(indx, [3, 4, 5]);

    endf = max(sim1fxy(:, 1));
    startf = min(sim1fxy(:, 1));


    curframe = startf;
    while 1,
        % grabs the indexes of points in current frame
        i = (sim1fxy(:, 1)==curframe);

        % plots current frame
        scatter(sim1fxy(i, 2), sim1fxy(i, 3));
        axis([-.3 .3 -.3 .3]);

        % increment frame and pause
        if curframe == endf,
            curframe = startf;
        else
            curframe = curframe + 1;
        end
        pause(0.005);
    end
end