function dist_matrix = vicsek_distance(frame)
    %time could be halved by not recalculating distance between x and y and
    %then y and x
    length = 2*pi;
    dist_matrix = zeros(size(frame, 1));
    for i = 1:size(frame, 1),
        xdiff = abs(frame(i, 1) - frame(:, 1));
        ydiff = abs(frame(i, 2) - frame(:, 2));
        % Find points inside circle
        if size(frame, 2) == 3
            thetadiff = abs(frame(i, 3) - frame(:, 3));
            dist_matrix(i, :) = sqrt(min(xdiff, length-ydiff).^2 + min(ydiff, length-ydiff).^2 + min(thetadiff, length-thetadiff).^2);
        else
            dist_matrix(i, :) = sqrt(min(xdiff, length-ydiff).^2 + min(ydiff, length-ydiff).^2);
        end
    end
end