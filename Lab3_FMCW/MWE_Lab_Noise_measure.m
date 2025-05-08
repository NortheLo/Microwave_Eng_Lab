clear; close all; clc;

function pwr = get_pwr(path)
    load(path);
    
    T_sweep = 10e-3; % [s]

    opt_chunk_size = 2^(nextpow2(2 * T_sweep * fs));
    [~, pwr] = process_buffer_fft(sif, fs, opt_chunk_size);
end


% 4.4 Distance Measurement
pwr_noise = get_pwr("ws_task3.mat");
pwr_sig = get_pwr("ws_task2.mat");

g = mean(pwr_sig)/ mean(pwr_noise);
snr = 10 * log10(abs(g))

% thoughts:
% we compare the max if freq of noise vs the one with a target