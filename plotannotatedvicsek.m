function plotannotatedvicsek(solution, timestrapper, maxfilt, usedframes)
    curstep = 1;
    endstep = size(solution, 2);
    dl = .08;
    numparticles = size(solution, 1);
    intervalgenerators = timestrapper.getIntervalsWithGenerators(0);
    for i = 0:intervalgenerators.size()-1
        pair = intervalgenerators.get(i);
        interval = pair.getFirst();
        generator = pair.getSecond();
        %we are only tracking components that persist
        if interval.getEnd() > interval.getStart()
            indx = str2num(generator.toString());
            particle = mod(indx, numparticles);
            frame = idivide(int32(indx), numparticles);
            particles_in_connected_component(particle, solution(:, [frame+1 frame+2 frame+3], maxfilt)
        end
    end
    
    while 1,
        % plots current frame
        %scatter(solution(:, curstep), solution(:, curstep+1), 'filled');
        scatter(solution(:, curstep), solution(:, curstep+1));
        dx = [solution(:, curstep)'; (solution(:, curstep)+ dl* cos(solution(:,curstep+2)))'];
        dy = [solution(:, curstep+1)'; (solution(:, curstep+1)+ dl* sin(solution(:,curstep+2)))'];
        hold on;
        plot(dx, dy, 'b');
        hold off;
        title(strcat('Frame: ', sprintf('%d', num2str(curstep/3))));
        axis([0 2*pi 0 2*pi]);

        % increment frame and pause
        curstep = curstep + 3;
        if curstep >= endstep
            curstep = 1;
        end
        pause(0.01);
    end
end