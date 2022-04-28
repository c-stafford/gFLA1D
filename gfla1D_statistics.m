% Postprocessing for averaged field variables

clear

load gfla1D_kernel_regression

% Extract variables
Nx = size(p_grid,1) - 1;
Nr = size(p_grid,2) - 1;

rho_grid = zeros(Nx+1,1);   % Number density
ravg = zeros(Nx+1,1);       % Average radius
rvar = zeros(Nx+1,1);       % Radius variance

% Numerically integrate using trapezium rule
for nx = 1:Nx+1
    
    % ----------------------------------------------------------
    
    % Number density
    for nr = 1:Nr+1
        
        if (nr == 1) || (nr == Nr+1)
            intcoeff = 0.5*dr;
        else
            intcoeff = dr;
        end
        
        rho_grid(nx) = rho_grid(nx) + intcoeff*p_grid(nx,nr); 
        
    end
    
    % ----------------------------------------------------------
    
    % Average radius
    for nr = 1:Nr+1
        
        if (nr == 1) || (nr == Nr+1)
            intcoeff = 0.5*dr;
        else
            intcoeff = dr;
        end    
        
        ravg(nx) = ravg(nx) + intcoeff*rmesh(nr)*p_grid(nx,nr);
        
    end
    
    % Normalise by number density
    ravg(nx) = ravg(nx)/rho_grid(nx);
    
    % ----------------------------------------------------------
    
    % Radius variance
    for nr = 1:Nr+1
        
        if (nr == 1) || (nr == Nr+1)
            intcoeff = 0.5*dr;
        else
            intcoeff = dr;
        end
        
        rvar(nx) = rvar(nx) + intcoeff*(rmesh(nr) - ravg(nx))*(rmesh(nr) - ravg(nx))*p_grid(nx,nr);
        
    end
    
    % Normalise by number density
    rvar(nx) = rvar(nx)/rho_grid(nx);
    
    % ----------------------------------------------------------
    
end

save(mfilename,'rho_grid','ravg','rvar','xmesh','xmin','xmax')