
for expnum = 1:9
    indx = ( aphiddata(:,1) ==expnum);
    data = aphiddata(indx, [3 4 5 6 7 8]);   
    endframe = max(data(:, 1));
    x = 1:endframe;
    totalvel = 0*ones(endframe, 2);
    pol = 0*ones(1, endframe);
    mang = 0*ones(1, endframe);
    mabs = 0*ones(1, endframe);
    for frame = 2:endframe
        indx = (data(:, 1)== frame);
        thisframe = data(indx, :);
        vel = [thisframe(:, 4) .* thisframe(:, 5), thisframe(:, 4) .* thisframe(:, 6)];
        totalvel(frame, :) = sum(vel)/length(vel);
        velnorm = 0*ones(length(vel), 1);
        mangs1 = 0*ones(length(vel), 1);
        mangs2 = 0*ones(length(vel), 1);
        mabss1 = 0*ones(length(vel), 1);
        for i = 1:size(thisframe, 1)
            velnorm(i) = norm(vel(i, :));
            mabss1(i) = norm(vel(i, 1) * thisframe(i, 3) - vel(i, 2) * thisframe(i, 2));
            mangs1(i) = vel(i, 1) * thisframe(i, 3) - vel(i, 2) * thisframe(i, 2);
            mangs2(i) = norm(thisframe(i, [2 3]))*norm(vel(i, :));
        end
        pol(frame) = norm(sum(vel)/sum(velnorm));
        mang(frame) = norm(sum(mangs1)/sum(mangs2));
        mabs(frame) = norm(sum(mabss1)/sum(mangs2));
    end
    x = .5 * x;
    
    han = figure;
    plot(x, pol);
    xlabel('Time (s)');
    title(strcat('Polarization vs time for experiment: ', num2str(expnum)));
    fname = strcat('polarization_exp_', num2str(expnum));
    saveas(han, char(fname), 'png');
    
    han = figure;
    plot(x, mang);
    xlabel('Time (s)');
    title(strcat('Total angular momentum vs time for experiment: ', num2str(expnum)));
    fname = strcat('ang_momentum_exp_', num2str(expnum));    
    saveas(han, char(fname), 'png');
        
    han = figure; 
    plot(x, mabs);
    xlabel('Time (s)');
    title(strcat('Absolute vale of angular momentum vs time for experiment: ', num2str(expnum)));
    fname = strcat('abs_ang_momentum_exp_', num2str(expnum));    
    saveas(han, char(fname), 'png');    
    
end