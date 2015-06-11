function plotvicsek(solution)
    curstep = 1;
    endstep = size(solution, 2);
    while 1,
        %thisstep = solution(:, [curstep curstep+1]);
        %xindx = mod(1:numparticles, 3) == 2;
        %yindx = mod(1:numparticles, 3) == 0;
        % plots current frame
        scatter(solution(:, curstep), solution(:, curstep+1), 'filled');
        title(strcat('Frame: ', sprintf('%0.1d', num2str(curstep))));
        axis([0 10 0 10]);

        % increment frame and pause
        curstep = curstep + 2;
        if curstep >= endstep
            curstep = 1;
        end
        pause(0.01);
    end
end