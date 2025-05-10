clc; clear;

% === Parameters from the document ===

% Source and path
P_VCO_dBm = 12;           % VCO output power
L_PD_dB = 3;              % Power divider loss
G_Tx_dB = 17;             % Transmit antenna gain
DF_dB = 74.8;             % Free-space path loss (approx from context)
G_Rx_dB = 17;             % Receive antenna gain

% === Equation (1.31): Input power before the LNA ===
P_in_dBm = P_VCO_dBm - L_PD_dB + G_Tx_dB - DF_dB + G_Rx_dB;

% === Equation (1.32): Thermal noise power ===
kB = 1.38e-23;        % Boltzmann constant [J/K]
T = 290;              % Receiver temperature [K]
B = 50e3;             % Bandwidth [Hz]
N_T_dBm = 10 * log10(kB * T * B) + 30;

% === Equation (1.33): SNR at receiver input ===
SNR_in_dB = P_in_dBm - N_T_dBm;

% === Component Noise Figures and Gains from Table 1.2 ===
F_LNA_dB = 2.6;
F_mix_dB = 8;
F_IFA_dB = 19.1;
F_ADC_dB = 59;

G_LNA_dB = 18;
L_mix_dB = 8;   % Mixer loss (used as negative gain)
G_IFA_dB = 34;

% Convert from dB to linear
F_LNA = 10^(F_LNA_dB / 10);
F_mix = 10^(F_mix_dB / 10);
F_IFA = 10^(F_IFA_dB / 10);
F_ADC = 10^(F_ADC_dB / 10);

G_LNA = 10^(G_LNA_dB / 10);
G_mix = 10^(-L_mix_dB / 10);  % Loss is negative gain
G_IFA = 20^(G_IFA_dB / 10);

% === Equation (1.34): Total system noise figure (Friis) ===
F_sys = F_LNA + ...
        (F_mix - 1) / G_LNA + ...
        (F_IFA - 1) / (G_LNA * G_mix) + ...
        (F_ADC - 1) / (G_LNA * G_mix * G_IFA);

F_sys_dB = 10 * log10(F_sys);

% === Display Results ===
fprintf('Input power before LNA: %.1f dBm\n', P_in_dBm);
fprintf('Thermal noise power: %.1f dBm\n', N_T_dBm);
fprintf('Input SNR: %.1f dB\n', SNR_in_dB);
fprintf('Total system noise figure: %.1f dB\n', F_sys_dB);
