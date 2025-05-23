clear; close all; clc;

c0 = physconst('LightSpeed');
k_b = physconst('Boltzmann');

db_2_lin    = @(g) 10^(g / 10);
dbm_2_lin = @(g) 10.^((g - 30) / 10);

lin_2_db    = @(g) 10 * log10(g);
lin_2_dBm   = @(g) lin_2_db(g) + 30;

f_2_lambda  = @(f) c0 / f;

T       = 300;           % [K]
fc      = 24e9;          % [Hz]
fs      = 100e3;         % [Hz]
r       = 1.56;          % [m]
a       = 0.15;          % [m]
P_vco   = 12;            % [dBm]
L_pd    = 4;             % [dB]
G_ant   = 15;            % [dBi]
G_lna   = 18;            % [dB]
L_mix   = 8;             % [dB]
G_ifa   = 34;            % [dB]
F_lna   = 2.6;           % [dB]
F_mix   = 8;             % [dB]
F_ifa   = 19.1;          % [dB]
F_ad    = 59;            % [dB]


lambda = f_2_lambda(fc);
rcs = 4 * pi * a^4 / (3 * lambda^2)

D_f = lin_2_db((4 * pi)^3 * r^4 / (rcs * lambda^2))

P_in  = P_vco - L_pd + G_ant - D_f + G_ant
N_t   = lin_2_dBm(k_b * T * fs)
SNR_i = P_in - N_t


f_lna = db_2_lin(F_lna);
l_mix = db_2_lin(-F_mix);
g_lna = db_2_lin(G_lna);
g_ifa = db_2_lin(G_ifa);
f_ad = db_2_lin(F_ad);
f_mix = db_2_lin(-F_mix);
f_ifa = db_2_lin(F_ifa);

F =     f_lna +...
       (f_mix - 1) /  g_lna +...
       (f_ifa - 1) / (g_lna * l_mix) +...
       (f_ad  - 1) / (g_lna * l_mix * g_ifa);
NF = 10 * log10(F)

SNR_o = SNR_i - NF