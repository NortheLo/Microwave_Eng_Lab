clear; clc;

% --- Load signals from files ---
data_with = load('ws_task2.mat');      % Assumes it contains variable 'sif'
data_without = load('ws_task3.mat');   % Assumes it contains variable 'sif'

% Extract 'sif' from the structs
sif_with_object = data_with.sif;
sif_without_object = data_without.sif;

% --- Ensure same length ---
N = min(length(sif_with_object), length(sif_without_object));
sif_with_object = sif_with_object(1:N);
sif_without_object = sif_without_object(1:N);

% --- Step 1: Compute power in time domain ---
P_total = mean(abs(sif_with_object).^2);
P_noise = mean(abs(sif_without_object).^2);
P_signal = max(P_total - P_noise, eps);  % eps avoids division by zero

% --- Step 2: Compute SNR ---
SNR_linear = P_signal / P_noise;
SNR_dB = 10 * log10(SNR_linear);

% --- Step 3: Display result ---
fprintf('Estimated SNR: %.2f dB\n', SNR_dB);

% --- Optional: visualize signal and noise ---
figure;
subplot(2,1,1);
plot(abs(sif_with_object));
title('Signal with Object Present');
xlabel('Sample Index'); ylabel('|Amplitude|');

subplot(2,1,2);
plot(abs(sif_without_object));
title('Noise Only (No Object)');
xlabel('Sample Index'); ylabel('|Amplitude|');
