function dOrsogna()
N = 100;
tstart = 0;
tend = 34;
m = 1;

%define the initial conditions making sure to use the right ordering
xinit = 10*rand(N, 1);
yinit = 10*rand(N, 1);

vxinit = 2*rand(N, 1) - 1;
vyinit = 2*rand(N, 1) - 1;



in = [vxinit; vyinit; xinit; yinit];

[t, x] = ode45(@functionOfInterest, [tstart,tend], in, [], N);

for theta = 1:length(t)
    xpos = x(theta,2*N+1:3*N);
    ypos = x(theta,3*N+1:4*N);
%     xpos = xpos - mean(xpos);
%     ypos = ypos - mean(ypos);
    plot(xpos,ypos,'ko');
    
    %axis([-2 12 -2 12]);
    %axis([0 8 0 8]);
    %axis([-1 1 -1 1]);
    axis([4 6 4 6]);
    pause(0.01);
end

end


function dxdt = functionOfInterest(t, x, N)
selfPropulsion = 1;
friction = 0.5;
repulsion = .5;
repulsionLength = .5;
attraction = 1;
attractionLength = 1;

vx = x(1:N);
vy = x(N+1:2*N);
xpos = x(2*N+1:3*N);
ypos = x(3*N+1:4*N);

z = xpos + i*ypos;
v = vx + i*vy;

zdot = v;
[Z1,Z2] = meshgrid(z,z);
Rdiff = Z2-Z1;
R = abs(Rdiff);

MOI = -repulsion/repulsionLength*exp(-R/repulsionLength)+attraction/attractionLength*exp(-R/attractionLength);
unitVectors = Rdiff./R;
unitVectors(logical(eye(size(unitVectors)))) = 0;
vdot = (selfPropulsion - friction*abs(v).^2).*v - sum(MOI.*unitVectors,2); % the minus sign comes form the minus sign in front of the gradient term in the master equation

dxdt = [real(vdot);imag(vdot);real(zdot);imag(zdot)];

end
