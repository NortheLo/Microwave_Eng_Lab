clear; close all; clc;

c0 = physconst('LightSpeed');

%% 4.2 Distance Measurement
load("ws_task2.mat");

r = 5;           % [m]
B = 1e9;         % [Hz]
T_sweep = 10e-3; % [s]

gamma = B / (T_sweep);
f_b_max = (2 * gamma * r) / (c0);

f_s_min = 2 * f_b_max * 1.3
f_s_fft_min = f_s_min * 2

[max_freqs, spectr] = process_buffer_fft(sif, 2048);

nbins = 5;  % Number of bins (adjust depending on resolution needed)
[counts, edges] = histcounts(max_freqs, nbins);

% Find the two highest peaks in the histogram
[sorted_counts, sorted_idx] = sort(counts, 'descend');
top_bins = sorted_idx(1:2);  % Indices of top 2 bins

% Get bin centers for those
bin_centers = edges(1:end-1) + diff(edges)/2;
top_freqs = bin_centers(top_bins);

f_b = 0.5 * (top_freqs(1) + top_freqs(2));
r = c0 / (2 * gamma) * f_b
