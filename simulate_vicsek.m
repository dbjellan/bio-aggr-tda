function sol = simulate_vicsek(numparticles, timesteps, v_0, radial_distance, sigma)
    radial_distance_squared = radial_distance^2;
    xy = 2*pi*rand(numparticles,2);
    theta = 2*pi*rand(numparticles, 1);
    boundary = 2*pi;
    halfsigma = sigma/2;
    sol = zeros(numparticles, 3*timesteps);
    for t = 0:timesteps-1
        z = zeros(numparticles,2);
        theta2 = zeros(numparticles, 1);
        for i = 1:numparticles
            indx = pointsincircle(xy, radial_distance_squared, xy(i, :));
            
            theta2(i) = sum(theta(indx))/sum(indx) + rand()*sigma - halfsigma;
            theta2(i) = mod(theta2(i), 2*pi);

            z(i, 1) = xy(i, 1) + v_0 * cos(theta2(i));
            z(i, 1) = mod(z(i, 1), boundary);

            z(i, 2) = xy(i, 2) + v_0 * sin(theta2(i));
            z(i, 2) = mod(z(i, 2), boundary);
        end
        sol(:, [3*t+1, 3*t+2, 3*t+3]) = [xy theta];
        xy = z;
        theta = theta2;
    end
end