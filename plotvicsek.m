function plotvicsek(solution)
    curstep = 1;
    endstep = size(solution, 2);
    dl = .08;
    while 1,
        % plots current frame
        %scatter(solution(:, curstep), solution(:, curstep+1), 'filled');
        scatter(solution(:, curstep), solution(:, curstep+1));
        dx = [solution(:, curstep)'; (solution(:, curstep)+ dl* cos(solution(:,curstep+2)))'];
        dy = [solution(:, curstep+1)'; (solution(:, curstep+1)+ dl* sin(solution(:,curstep+2)))'];
        hold on;
        plot(dx, dy, 'b');
        hold off;
        title(sprintf('Frame: %s', num2str((curstep+2)/3)));
        axis([0 2*pi 0 2*pi]);

        % increment frame and pause
        curstep = curstep + 3;
        if curstep >= endstep
            curstep = 1;
        end
        pause(0.01);
    end
end