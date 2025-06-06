clear; clc; close all;

% meassurement
pow_car = 2.2;  % [dBm]
pow_sb = -13.1; % [dBm]


sb_lin  = db2pow(pow_sb)
car_lin = db2pow(pow_car)

m_ratio = sb_lin / car_lin

m = 2 * sqrt(m_ratio)