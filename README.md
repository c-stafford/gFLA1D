# gFLA1D

MATLAB scripts for 1D injection of droplets into still hot air with uniform temperature. Droplets are injected with a constant velocity and temperature.

## Case Files

These should be run in the following order:

- **gfla1D** - Main simulation script
- **gfla1D_animation** - Animation of droplet data in 1D
- **gfla1D_animation_xr** - Animation of droplet data in (x,r) space
- **gfla1D_plot_xr** - Droplet trajectory plot
- **gfla1D_kernel_regression** - Kernel regression for reconstruction of probability density field
- **gfla1D_kernel_regression_plot** - Plot of probability density field obtained using kernel regression
- **gfla1D_x_profiles_plot** - Probability density profiles at x cross sections
- **gfla1D_r_profiles_plot** - Probability density profiles at r cross sections
- **gfla1D_statistics** - Postprocessing for averaged field variables
- **gfla1D_statistics_plot** - Plotting of averaged field variables

## Miscellaneous Files

- **clean** - Bash script for removing data and image files from directory
- **plot_opts** - Common formatting options for figures
