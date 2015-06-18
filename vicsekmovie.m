function vicsekmovie(solution, fname)
    curstep = 1;
    endstep = size(solution, 2)/2;
    dl = .08;
    vwriter = VideoWriter(fname, 'MPEG-4');
    open(vwriter);
%    ax1 = axes('XLim', [0, 2*pi], 'YLim', [0, 2*pi]);
    while 1,
        % plots current frame
        %scatter(solution(:, curstep), solution(:, curstep+1), 'filled');
%        figure('Visible','off');
%        close all;
        scatter(solution(:, curstep), solution(:, curstep+1));
        dx = [solution(:, curstep)'; (solution(:, curstep)+ dl* cos(solution(:,curstep+2)))'];
        dy = [solution(:, curstep+1)'; (solution(:, curstep+1)+ dl* sin(solution(:,curstep+2)))'];
        hold on;
        plot(dx, dy);
        hold off;
%        set(gcf, 'CurrentAxes', ax1);
        title(strcat('Frame: ', sprintf('%d', num2str(curstep/3))));
        axis([0 2*pi 0 2*pi]);
        frame = getframe;
        writeVideo(vwriter, frame);
        if curstep == 1
            print('first_frame','-dpng')
        end
        % increment frame and pause
        curstep = curstep + 3;
        if curstep >= endstep
            break;
        end
        %pause(0.01);
    end
end