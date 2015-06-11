

numparticles = 100;
sigma = .5;
radial_distance_squared = .3;
v_0 = 1;
timestep = .01;
xy = 10*rand(numparticles,2);
theta = 2*pi*rand(numparticles, 1);
sol = [];
boundary = 10;
for t = 1:timestep:20
    z = zeros(numparticles,2);
    theta2 = zeros(numparticles, 1);
    for i = 1:numparticles
        %count = 0;
        %for j = 1:numparticles
        %    theta_sum = 0;
        %    if (y(i*3-1) - y(j*3-1))^2 + (y(i*3) - y(j*3))^2 <= radial_distance^2
        %        theta_sum = theta_sum + y(j*3-2);
        %        count = count + 1;
        %    end
        %end
        indx = pointsincircle(xy, radial_distance_squared, xy(i, :));
        
        theta2(i) = sum(theta(indx))/size(indx, 1) + randn()*sigma;
        theta2(i) = mod(theta2(i), 2*pi);
        
        z(i, 1) = xy(i, 1) + v_0 * cos(theta2(i)) * timestep;
        z(i, 1) = mod(z(i, 1), boundary);
        
        z(i, 2) = xy(i, 2) + v_0 * sin(theta2(i)) * timestep;
        z(i, 2) = mod(z(i, 2), boundary);
    end
    xy = z;
    theta = theta2;
    sol = [sol z];
end