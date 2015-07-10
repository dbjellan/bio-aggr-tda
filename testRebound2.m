function testRebound2

sample = 1000; % Number of points for numerical computations

%so well behaved, merlin.
% zi = 0.4806 - 1.8985i;
% zf = 0.5394 - 1.9445i;

%works fine
% zi = -0.2544 + 1.9235i;
% zf =  -0.1814 + 1.9935i;

%works
% zi = 1.7727 + 0.8384i;
% zf = 1.8417 + 0.8386i;

%works
% zi = 0.8 + 0*1i;
% zf = 2.3 + 0*1i;

%works now
% zi = 0 + 1.8*1i;
% zf = 0 + 2.1*1i;

%YAY I think it works now!
zi = -0.5721 - 1.8929*1i;
zf = -0.5195 - 1.9715*1i;


line = linspace(zf, zi, sample);

r = 2;
theta = linspace(0,2*pi,sample);
circle = r*exp(1i*theta);
% line = aphids(i, 4) + linspace(0,(newX + 1i*newY)-aphids(i, 4),sample);

%line = [real(line); imag(line)]
figure; hold on; plot(circle,'b-'); plot(real(line),imag(line),'r-'); hold off;
%hold on; plot(real(zi),imag(zi),'ko'); hold off;
axis([-r r -r r]);
circle = [real(circle);imag(circle)];
line = [real(line); imag(line)];
%line = [imag(line); real(line)]
pointIntersect = InterX(circle,line);

hold on; plot(pointIntersect(1),pointIntersect(2),'ko'); hold off;


d =  [real(zf)-real(zi), imag(zf)-imag(zi)];
n = -pointIntersect/norm(pointIntersect);


r = d-2*(d*n)*transpose(n);

reflect_vect = r ./ norm(r);

%find length of reflected segment
%reflectLength = abs(zi-zf) - sqrt(real(zi)^2 + imag(zi)^2)
abs(zi-zf)
reflectLength = abs(zi-zf) - sqrt((pointIntersect(1)-real(zi))^2 + (pointIntersect(2)- imag(zi))^2)
%location of endpoint is angle&reflectLength away from origin,
%transposed by the intersection point

reflect_vect = reflectLength .* reflect_vect;
%final = transpose(pointIntersect) + reflect_vect;
finalLocation = reflect_vect(1) + 1i*reflect_vect(2) + pointIntersect(1) + 1i*pointIntersect(2);


lineTwo = linspace(finalLocation, pointIntersect(1) + 1i*pointIntersect(2), sample);
hold on; plot(lineTwo,'r-'); plot(real(finalLocation),imag(finalLocation),'ko'); hold off;

end


% From Matlab file exchange
function P = InterX(L1,varargin)
%INTERX Intersection of curves
%   P = INTERX(L1,L2) returns the intersection points of two curves L1 
%   and L2. The curves L1,L2 can be either closed or open and are described
%   by two-row-matrices, where each row contains its x- and y- coordinates.
%   The intersection of groups of curves (e.g. contour lines, multiply 
%   connected regions etc) can also be computed by separating them with a
%   column of NaNs as for example
%
%         L  = [x11 x12 x13 ... NaN x21 x22 x23 ...;
%               y11 y12 y13 ... NaN y21 y22 y23 ...]
%
%   P has the same structure as L1 and L2, and its rows correspond to the
%   x- and y- coordinates of the intersection points of L1 and L2. If no
%   intersections are found, the returned P is empty.
%
%   P = INTERX(L1) returns the self-intersection points of L1. To keep
%   the code simple, the points at which the curve is tangent to itself are
%   not included. P = INTERX(L1,L1) returns all the points of the curve 
%   together with any self-intersection points.
%   
%   Example:
%       t = linspace(0,2*pi);
%       r1 = sin(4*t)+2;  x1 = r1.*cos(t); y1 = r1.*sin(t);
%       r2 = sin(8*t)+2;  x2 = r2.*cos(t); y2 = r2.*sin(t);
%       P = InterX([x1;y1],[x2;y2]);
%       plot(x1,y1,x2,y2,P(1,:),P(2,:),'ro')

%   Author : NS
%   Version: 3.0, 21 Sept. 2010

%   Two words about the algorithm: Most of the code is self-explanatory.
%   The only trick lies in the calculation of C1 and C2. To be brief, this
%   is essentially the two-dimensional analog of the condition that needs
%   to be satisfied by a function F(x) that has a zero in the interval
%   [a,b], namely
%           F(a)*F(b) <= 0
%   C1 and C2 exactly do this for each segment of curves 1 and 2
%   respectively. If this condition is satisfied simultaneously for two
%   segments then we know that they will cross at some point. 
%   Each factor of the 'C' arrays is essentially a matrix containing 
%   the numerators of the signed distances between points of one curve
%   and line segments of the other.

    %...Argument checks and assignment of L2
    error(nargchk(1,2,nargin));
    if nargin == 1,
        L2 = L1;    hF = @lt;   %...Avoid the inclusion of common points
    else
        L2 = varargin{1}; hF = @le;
    end
       
    %...Preliminary stuff
    x1  = L1(1,:)';  x2 = L2(1,:);
    y1  = L1(2,:)';  y2 = L2(2,:);
    dx1 = diff(x1); dy1 = diff(y1);
    dx2 = diff(x2); dy2 = diff(y2);
    
    %...Determine 'signed distances'   
    S1 = dx1.*y1(1:end-1) - dy1.*x1(1:end-1);
    S2 = dx2.*y2(1:end-1) - dy2.*x2(1:end-1);
    
    C1 = feval(hF,D(bsxfun(@times,dx1,y2)-bsxfun(@times,dy1,x2),S1),0);
    C2 = feval(hF,D((bsxfun(@times,y1,dx2)-bsxfun(@times,x1,dy2))',S2'),0)';

    %...Obtain the segments where an intersection is expected
    [i,j] = find(C1 & C2); 
    if isempty(i),P = zeros(2,0);return; end;
    
    %...Transpose and prepare for output
    i=i'; dx2=dx2'; dy2=dy2'; S2 = S2';
    L = dy2(j).*dx1(i) - dy1(i).*dx2(j);
    i = i(L~=0); j=j(L~=0); L=L(L~=0);  %...Avoid divisions by 0
    
    %...Solve system of eqs to get the common points
    P = unique([dx2(j).*S1(i) - dx1(i).*S2(j), ...
                dy2(j).*S1(i) - dy1(i).*S2(j)]./[L L],'rows')';
              
    function u = D(x,y)
        u = bsxfun(@minus,x(:,1:end-1),y).*bsxfun(@minus,x(:,2:end),y);
    end
end

%for float/double equality testing
function bool = testEquality (argOne, argTwo, epsilon)
bool = (argOne < argTwo + epsilon) && (argOne > argTwo - epsilon);
end
