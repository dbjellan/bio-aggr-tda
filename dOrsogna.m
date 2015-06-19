function dOrsogna()
numparticles = 100;
%define tstart, tend and the number of time steps you want to take, n:
tstart = 1;
tend = 20;
n = 500;
m = 1;
tspan = linspace(tstart,tend,n);

%define the initial conditions making sure to use the right ordering
xinit = 10*rand(numparticles, 1);
yinit = 10*rand(numparticles, 1);
%SHOULDN'T THESE TWO BE GENERATED FROM THE ABOVE?
vxinit = 2*pi*rand(numparticles, 1);
vyinit = 2*pi*rand(numparticles, 1);

in = [vxinit, vyinit, xinit, yinit];
in = in';

[t, x] = ode45(@functionOfInterest, tspan, in);
matrix = [t, x];

y = zeros(4*numparticles);

size([t, x])
for theta = 1:n
    for i = 1:numparticles
        
        y = matrix(theta, :);
        
        k = numparticles;
        newvx = y(1:k);
        newvy = y(k+1:2*k);
        newxpos = y(2*k+1:3*k);
        newypos = y(3*k+1:4*k);
        
        %there has GOT to be a more efficient way to do this
        points(i, :) = [newxpos(i), newypos(i)];
    end
    
    scatter(points(:,1), points(:,2))
    axis([-100 100 -100 100]);
    pause(1);
    
end


function dxdt = functionOfInterest(t, x)
    selfPropulsion = 1.5;
    friction = 1;
    repulsion = .3;
    repulsionLength = .5;
    attraction = .5;
    attractionLength = 2;

    Q = zeros(numparticles);

    k = numparticles;
    vx = x(1:k);
    vy = x(k+1:2*k);
    xpos = x(2*k+1:3*k);
    ypos = x(3*k+1:4*k);
    pos = [xpos, ypos];

    xdot = [];
    vdot = [];
    vdotxy = [0;0];

    for i = 1:numparticles 

        %establish Q forces for each i
        for j = 1:numparticles
            if (j ~= i)
                Q(i) = sum(repulsion * exp(-norm(pos(i,:) - pos(j,:))/repulsionLength) - attraction * exp(- norm(pos(i,:) - pos(j,:))/attractionLength));
            end
        end

        %dxdt = zeros([i, 2]);
        xdot = [xdot, vx(i), vy(i)];
        vdotxy = ([xdot(2*i - 1), xdot(2*i)]/m)*(selfPropulsion - friction*norm([xdot(2*i - 1), xdot(2*i)])^2) - gradient(Q(i))/m;
        vdot = [vdot, vdotxy(1), vdotxy(2)];
%             dxdt[i, 2] = vdot(i);
    end

    %out = [newxpos, newypos, newvx, newvy];
    %dxdt = out';
    dxdt = [xdot, vdot]';
end
end
