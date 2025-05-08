clear; clc; close all;

sif_with = load('ws_task2.mat').sif;
sif_without = load('ws_task3.mat').sif;

N = min(length(sif_with), length(sif_without));
sif_with = sif_with(1:N);
sif_without = sif_without(1:N);

spectrum_with = abs(fft(sif_with)).^2 / N;
spectrum_noise = abs(fft(sif_without)).^2 / N;

% real data -> only pos side w/o DC
[~, peak_bin] = max(spectrum_with(2:N/2)); 
peak_bin = peak_bin + 1;

P_signal_bin = spectrum_with(peak_bin);
P_noise_bin = spectrum_noise(peak_bin);

% SNR estimate
SNR_bin = P_signal_bin / max(P_noise_bin, eps);
SNR_dB = 10 * log10(SNR_bin);

fprintf('Frequency-domain SNR at peak bin: %.2f dB\n', SNR_dB);

% some plotting 
f = linspace(0, 1, N);  
figure;
plot(f(1:N/2), 10*log10(spectrum_with(1:N/2)), 'b', 'DisplayName', 'Signal+Noise');
hold on;
plot(f(1:N/2), 10*log10(spectrum_noise(1:N/2)), 'r', 'DisplayName', 'Noise Only');
xline(f(peak_bin), '--k', 'DisplayName', 'Peak');
legend; grid on;
xlabel('Normalized Frequency');
ylabel('Power (dB)');
title('FFT Spectra');