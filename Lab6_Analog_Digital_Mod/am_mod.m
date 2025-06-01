clear; clc; close all;

% theoretical meassurement

pow_sb = -19.69; % [dB]
pow_sb = pow_sb + 6;
pow_car = -3.22; % [dB]

sb_lin = db2pow(pow_sb / 2)
car = db2pow(pow_car / 2)

m = sb_lin / car


