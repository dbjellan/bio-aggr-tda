function particles =  particles_in_connected_component(indx, frame, epsilon)
    queue = [indx];
    particles = [indx];
    dist_matrix = vicsek_distance(frame);
    while length(queue) > 0
        current = queue(end);
        queue(end) = [];
        for i = 1:length(points)
            if any(abs(points(i)-particles)<1e-10)
                particles = [particles, points(i)];
                queue = [queue, points(i)];
            end
        end    
    end
end