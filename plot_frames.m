f1 = 200;
f2 = 2000;
f3 = 4000;

for expnum = 1:9
    indx = ( aphiddata(:,1) ==expnum);
    simfxy = aphiddata(indx, [3, 4, 5]);
    
    indx = ( simfxy(:,1) ==f1);    
    f1data = simfxy(indx, :);
    fname = strcat('frame_200_exp_', num2str(expnum));
    han = figure;
    scatter(f1data(:, 2), f1data(:, 3), 'filled');
    title(strcat('Frame 200'));
    axis([-.3 .3 -.3 .3]);
    saveas(han, char(fname), 'png');
    
    

    indx = ( simfxy(:,1) ==f2);    
    f2data = simfxy(indx, :);
    fname = strcat('frame_2000_exp_', num2str(expnum));
    han = figure;
    scatter(f2data(:, 2), f2data(:, 3), 'filled');
    title(strcat('Frame 2000'));
    axis([-.3 .3 -.3 .3]);
    saveas(han, char(fname), 'png');

    indx = ( simfxy(:,1) ==f3);    
    f3data = simfxy(indx, :);
    fname = strcat('frame_4000_exp_', num2str(expnum));
    han = figure;
    scatter(f3data(:, 2), f3data(:, 3), 'filled');
    title(strcat('Frame 4000'));
    axis([-.3 .3 -.3 .3]);
    saveas(han, char(fname), 'png');

end
