
for expnum = 1:9
    disp(strcat('Making Crocker plots for experiment: ', num2str(expnum)));
    indx = ( aphiddata(:,1) ==expnum);
    data = aphiddata(indx, [3 4 5 6 7 8]);
    
    fname = strcat('crocker_h0_pos_exp_', num2str(expnum));
    make_crocker(data(:, [1 2 3]), 0, fname, .3);

    fname = strcat('crocker_h1_pos_exp_', num2str(expnum));
    make_crocker(data(:, [1 2 3]), 1, fname, .3);
    
    unscaled_vel = [data(:, [1 2 3]), (data(:, 4) .* data(:, 5)), (data(:, 4) .* data(:, 6))];    
    fname = strcat('crocker_h0_raw_vel_', num2str(expnum));
    make_crocker(unscaled_vel, 0, fname, .3);

    fname = strcat('crocker_h1_raw_vel_', num2str(expnum));
    make_crocker(unscaled_vel, 1, fname, .3);
        
    scaled_data = scale_velocities(data);
    fname = strcat('crocker_h0_scaled_vel_', num2str(expnum));
    make_crocker(scaled_data, 0, fname, 1.5);
    
    fname = strcat('crocker_h1_scaled_vel_', num2str(expnum));
    make_crocker(scaled_data, 1, fname, 1.5);
end