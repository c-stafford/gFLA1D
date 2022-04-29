% 1D stationary quiescent gFLA

% 1D injection of droplets into still hot air with uniform temperature
% Droplets are injected with a constant velocity and temperature

clear

% ----------------------------------------------------------

% Constants
dt = 0.025;     % Timestep
NS = 640;       % Number of timesteps
M = 0.16;       % Mean parameter for initial log-normal size distribution
S = 0.4;        % Standard deviation parameter for initial log-normal size distribution
delta = 1;      % Evaporation rate parameter
NR = 100;       % Number of different droplet radii
rdmax = 4;       % Largest droplet radius (with respect to peak of initial log-normal size distribution)

% ----------------------------------------------------------

% Range of values for radius
dr = rdmax/NR;       % Droplet radius spacing
rd0 = dr:dr:rdmax;   % Set of values of initial droplet radii

% Simulation time
t = 0:dt:NS*dt;

% Variables
xd = zeros(NS+1,NR);        % Position
ud = zeros(NS+1,NR);        % Velocity
rdsq = zeros(NS+1,NR);      % Square of radius
nd = zeros(NS+1,NR);        % Probability density in (x,r) space
Jxx = zeros(NS+1,NR);       % Jacobian components
Jxr = zeros(NS+1,NR);
Jrx = zeros(NS+1,NR);
Jrr = zeros(NS+1,NR);
Oxx = zeros(NS+1,NR);       % Jacobian derivative components
Oxr = zeros(NS+1,NR);
detJ = zeros(NS+1,NR);      % Jacobian determinant
foldcount = zeros(NS+1,NR); % Count of number of fold layers
NSEVAP = zeros(NR,1);       % Number of timesteps needed for initial radius rd0 to evaporate

% Initial conditions
xd0 = 0;
ud0 = 1;
Jxx0 = 1;
Jxr0 = 0;
Jrx0 = 0;
Jrr0 = 1;
Oxx0 = 0;
Orr0 = 0;

% ----------------------------------------------------------

% Compute trajectory for different values of initial droplet radius
for nr = 1:NR
    
    sprintf(['rd0 = ',num2str(rd0(nr))])
    
    % Apply initial conditions
    rdsq(1,nr) = rd0(nr)^2;
    nd(1,nr) = 1/rd0(nr)*1/(S*sqrt(2*pi))*exp(-(log(rd0(nr)) - M)^2/(2*S^2));
    xd(1,nr) = xd0;
    ud(1,nr) = ud0;
    Jxx(1,nr) = Jxx0;
    Jxr(1,nr) = Jxr0;
    Jrx(1,nr) = Jrx0;
    Jrr(1,nr) = Jrr0;
    Oxx(1,nr) = Oxx0;
    Oxr(1,nr) = Orr0;

    % Compute Jacobian determinant
    detJ(1,nr) = Jxx(1,nr)*Jrr(1,nr) - Jxr(1,nr)*Jrx(1,nr);
    
    % Initialise time-stepping
    ns = 1;

    % Advance timestep whilst droplet has not evaporated and timestep is
    % less than specified maximum
    while (rdsq(ns,nr) > 0) && (ns < NS+1)

        % Forward Euler method for square of droplet radius
        rdsq(ns+1,nr) = rdsq(ns,nr) - dt*delta;

        % Check to see if droplet has fully evaporated
        if rdsq(ns+1,nr) < 0
            
            rdsq(ns+1,nr) = 0;
        
        else

            % Forward Euler method for remaining variables
            xd(ns+1,nr) = xd(ns,nr) + dt*ud(ns,nr);
            ud(ns+1,nr) = ud(ns,nr) - dt*1/rdsq(ns,nr)*ud(ns,nr);
            Jxx(ns+1,nr) = Jxx(ns,nr) + dt*Oxx(ns,nr);
            Jxr(ns+1,nr) = Jxr(ns,nr) + dt*Oxr(ns,nr);
            Jrr(ns+1,nr) = Jrr(ns,nr) + dt*delta/(2*rdsq(ns,nr))*Jrr(ns,nr);
            Oxx(ns+1,nr) = Oxx(ns,nr) + dt*(-1/(rdsq(ns,nr))*Oxx(ns,nr) + 2/(rdsq(ns,nr)^(3/2))*ud(ns,nr)*Jrx(ns,nr));
            Oxr(ns+1,nr) = Oxr(ns,nr) + dt*(-1/(rdsq(ns,nr))*Oxr(ns,nr) + 2/(rdsq(ns,nr)^(3/2))*ud(ns,nr)*Jrr(ns,nr));

            % Compute Jacobian determinant
            detJ(ns+1,nr) = Jxx(ns+1,nr)*Jrr(ns+1,nr) - Jxr(ns+1,nr)*Jrx(ns+1,nr);

            % Compute number density
            nd(ns+1,nr) = nd(1,nr)/(abs(detJ(ns+1,nr)));
            
            % Check for folds
            if (detJ(ns+1,nr) < 0 && detJ(ns,nr) > 0) || (detJ(ns+1,nr) > 0 && detJ(ns,nr) < 0)
                foldcount(ns+1,nr) = foldcount(ns,nr) + 1;
            else
                foldcount(ns+1,nr) = foldcount(ns,nr);
            end
            
        end
        
        % Advance timestep
        ns = ns + 1;

    end
    
    % Store number of timesteps needed for initial radius rd0 to evaporate
    NSEVAP(nr) = ns-2;  % Subtract extra timestep due to final increment after droplet has evaporated
    
end

% ----------------------------------------------------------

% Compute droplet radius values
rd = sqrt(rdsq);

% Display maximum number of trajectory crossings
% *** Should be zero for gFLA ***
fprintf('Maximum number of trajectory crossings: %2i\n',max(max(foldcount)));

% Save data to file
save(mfilename)