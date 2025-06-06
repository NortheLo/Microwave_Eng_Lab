clear; clc; close all;

% theoretical meassurement

%pow_sb = -19.69; % [dB] ORIGINAL
pow_sb = [-19.61826 -19.62]; % [dB] 
pow_sb = pow_sb + 6;
%pow_car = -3.22; % [dB] ORIGINAL
pow_car = -3.15; %-3.1457814; % [dB]


sb_lin = db2pow(pow_sb/2)
car = db2pow(pow_car/2)

m = sb_lin / car


% === Extracted from Spectrogram ===
% Carrier and sideband powers in dB (measured)
P_carrier_dB = -3.1457814;     % at 1.000 MHz
P_LSB_dB     = -19.69;      % at 0.990 MHz
P_USB_dB     = -19.69;     % at 1.010 MHz

% === Convert dB to linear scale ===
P_carrier_lin = db2pow(P_carrier_dB);
P_LSB_lin     = db2pow(P_LSB_dB);
P_USB_lin     = db2pow(P_USB_dB);

% === Total sideband power ===
P_SB_total = P_LSB_lin + P_USB_lin;

% === Compute modulation index (theoretical) ===
% m = sqrt(2 * (P_sidebands_total / P_carrier))
m = sqrt(2 * P_SB_total / P_carrier_lin)



