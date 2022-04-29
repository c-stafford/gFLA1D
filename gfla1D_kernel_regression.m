% Kernel regression for reconstruction of number density field
% Use Jacobian to determine shape of Gaussian kernel function
% Set upper limit on scaling factor along semi-major axis

clear

load gfla1D

% Number of dimensions in extended phase space
n = 2;

% Elements of phase-space variable \xi = (x,r)
xid(:,:,1) = xd;
xid(:,:,2) = rd;

% Sampling rate of timesteps
nf = 1;
NSF = floor(NS/nf);

% Number of different fold statuses
nfolds = max(reshape(foldcount,[],1)) + 1;

% Set grid spacing
dx = 0.04;
dr = 0.04;

% Creation of grids in x and r direction for number density
xmin = xd0;
xmax = 8;
xmesh = xmin:dx:xmax;
Nx = length(xmesh) - 1;

rmin = 0;
rmax = rdmax;
rmesh = rmin:dr:rmax;
Nr = length(rmesh) - 1;

p_weight_sum = zeros(Nx+1,Nr+1,nfolds);
weight_sum = zeros(Nx+1,Nr+1,nfolds);
part_count = zeros(Nx+1,Nr+1,NR,nfolds);
p_grid_folds = zeros(Nx+1,Nr+1,nfolds);
p_grid = zeros(Nx+1,Nr+1);

% Tolerance for range of compact support
% (number of standard deviations along Gaussian semi-major axis to include)
tol = 3;

% Set smoothing lengths as grid spacing for each phase-space variable
% Should be:
%   > 1/tol*dx to ensure contributions at distributed over at least 2 grid points
%   > 0.5/tol*dx to ensure contributions do not vanish
hx = 1.0*dx;
hr = 1.0*dr;

% Phase-space quantities
dxi = [dx;dr];
hxi = [hx;hr];
ximin = [xmin;rmin];
xigridleft = ones(2,1);
xigridright = [Nx+1;Nr+1];

% Maximum and minimum scaling factors for Jacobian
r0max = 10;
r0min = 0;
Jlimmax = r0max^n;
Jlimmin = r0min^n;

% ----------------------------------------------------------

for ns = 1:nf:NS+1

    fprintf(1,'%6i / %-6i \n',ns,NS+1)

    for nrd = 1:NR
        
        % Only include droplets which haven't yet evaporated
        if rd(ns,nrd) > 0
    
            % Coordinates of gridpoint
            xip = [xid(ns,nrd,1);xid(ns,nrd,2)];
            
            % Denote Jacobian determinant for particle
            detJval = abs(detJ(ns,nrd));
            
            % Evaluate scalar field at sample point
            ndval = nd(ns,nrd);
            
            % Fold status of particle
            pfold = foldcount(ns,nrd) + 1;
            
            % Compute radius of circle associated with elemental area
            r0 = detJval^(1/n);     % Factor of pi cancels out (two appearances)
            
            % Modify volume of Jacobian determinant if outside range of limiting factor
            if detJval > Jlimmax
                r0 = r0max;
                detJval = Jlimmax;
            elseif detJval < Jlimmin
                r0 = r0min;
                detJval = Jlimmin;
            end
            
            % Rescale phase-space smoothing lengths hxi by r0
            hr0 = hxi*r0;
            
            % Compute inverse of covariance matrix
            invCov = diag(1./(hr0.^2));

            % Find grid cell which particle is in
            xigrid = floor((xip - ximin)./dxi) + 1;     % Gives grid left coordinate

            % Define range within which gridpoints will receive contributions
            % based upon Gaussian standard deviation components in axial directions
            xirange = hr0*tol;

            % Transform range to number of gridpoints
            xigridrange = ceil(xirange./dxi);

            % Calculate gridpoint ranges for current particle
            xigridmin = xigrid - xigridrange;  % Subtract from grid left coordinate
            xigridmax = (xigrid + 1) + xigridrange;    % Add to grid right coordinate

            % Ensure that grid points are within domain boundaries
            xigridmin = max(xigridmin,xigridleft);
            xigridmax = min(xigridmax,xigridright);
            
            % Set gridpoints to include within range
            xi1gridpts = xigridmin(1):xigridmax(1);
            xi2gridpts = xigridmin(2):xigridmax(2);

            % Set size of local gridpoint arrays
            Nxi1grid = length(xi1gridpts);
            Nxi2grid = length(xi2gridpts);
            
            % Initialise temporary arrays for current particle contributions
            rhoweight_sum_part = zeros(Nxi1grid,Nxi2grid);
            weight_sum_part = zeros(Nxi1grid,Nxi2grid);
            part_count_part = zeros(Nxi1grid,Nxi2grid);

            % Interpolate number density onto grid from trajectory positions
            for nx = 1:Nxi1grid

                for nr = 1:Nxi2grid

                    xivals = [xmesh(xi1gridpts(nx));rmesh(xi2gridpts(nr))];

                    % Compute coordinate difference between interpolation point and sample point
                    xidist = xivals - xip;

                    % Compute square of Mahalanobis distance
                    mdistsq = invCov(1,1)*(xidist(1)^2) + (invCov(1,2) + invCov(2,1))*xidist(1)*xidist(2) + invCov(2,2)*(xidist(2)^2);

                    % Compute weighting kernel
                    % Only include contributions greater than tolerance value associated with range of compact support
                    if mdistsq < tol^2

                        wkernel = 1/detJval*exp(-0.5*(mdistsq));     % Bivariate Gaussian

                        % Add contribution to weighted average expressions
                        rhoweight_sum_part(nx,nr) = wkernel*ndval;
                        weight_sum_part(nx,nr) = wkernel;

                        part_count_part(nx,nr) = 1;

                    end

                end

            end
            
            p_weight_sum(xi1gridpts,xi2gridpts,pfold) = p_weight_sum(xi1gridpts,xi2gridpts,pfold) + rhoweight_sum_part;
            weight_sum(xi1gridpts,xi2gridpts,pfold) = weight_sum(xi1gridpts,xi2gridpts,pfold) + weight_sum_part;
            
            % Update particle count
            part_count(xi1gridpts,xi2gridpts,nr,pfold) = part_count(xi1gridpts,xi2gridpts,nr,pfold) + part_count_part;
        
        end

    end
    
end

% ----------------------------------------------------------

% Set contibution sof zero to machine precision to avoid NaN on division
weight_sum(weight_sum == 0) = eps;

% Compute final weighted average using Nadaraya-Watson estimator
p_grid_folds = p_weight_sum./weight_sum;

% Accumulate contributions from folds to overall number density
p_grid = sum(p_grid_folds,3);

save(mfilename,'p_grid','xmesh','rmesh','dt','xmin','xmax','rmin','rmax','dx','dr')