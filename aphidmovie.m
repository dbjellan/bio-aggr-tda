% fname is path to aphiddata.csv file
% plots the trajectories of the <expnum> experiment
% sample usage: plotaphid('aphiddata.csv', 1);
function aphidmovie(aphiddata, expnum)

    % grabs the [frame number, x coord, y coord] of first experiment 
    indx = ( aphiddata(:,1) ==expnum);
    sim1fxy = aphiddata(indx, [3, 4, 5]);

    endf = 2000;
    startf = min(sim1fxy(:, 1));

    fname = 'aphid_movie.mp4';
    vwriter = VideoWriter(fname, 'MPEG-4');
    open(vwriter);
    curframe = startf;
    while 1,
        % grabs the indexes of points in current frame
        i = (sim1fxy(:, 1)==curframe);
        
        % plots current frame
        scatter(sim1fxy(i, 2), sim1fxy(i, 3), 'filled');
        title(strcat('Frame: ', sprintf('%0.1d', num2str(curframe))));
        axis([-.3 .3 -.3 .3]);
        
        frame = getframe;
        writeVideo(vwriter, frame);

        % increment frame and pause
        if curframe == endf,
            break;
        else
            curframe = curframe + 1;
        end
        %pause(0.005);
    end
end