function scaled_data = scale_velocities(data)
    velocity_data = [data(:, 4) .* data(:, 5), data(:, 4) .* data(:, 6)];

    max_velocity = 0;
    for i = 1:size(velocity_data, 2)
        n = norm(velocity_data(i, :));
        if n > max_velocity,
            max_velocity = n;
        end
    end

    max_pos = 0;
    for i = 1:size(data, 2)
        n = norm(data(i, [2, 3]));
        if n > max_pos,
            max_pos = n;
        end
    end

    scaled_data = [data(:, 1), data(:, [2, 3])/max_pos, velocity_data/max_velocity];
end