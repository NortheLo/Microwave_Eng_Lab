clc; clear;

R = 10e3;
f_c = 1e6;
f_max = 10e3;
m = 0.3;

omega_c   = (2 * pi * f_c);
omega_max = (2 * pi * f_max);

lower_c = 1 / (omega_c * R)
upper_c = 1 / (omega_max * m * R)

c = 0.5 * upper_c