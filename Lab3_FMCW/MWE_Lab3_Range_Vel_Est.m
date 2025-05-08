clear; clc; close all;

load("ws_task4.mat");

c0 = physconst('LightSpeed');
f_c     = 24e9;     % [Hz]
T_sweep = 10e-3;    % [s]

BW = fmax - fmin;
gamma = BW / (T_sweep);

% n samples which are needed for one sweep
N = round(T_sweep * fs);
fft_length = 2^nextpow2(N);

% 4 * for smooth vel
fft_length = 4 * fft_length
[s, f, t] = make_spectrogram(sif, fs, fft_length);
[~, time_slices] = size(s);

v_r = zeros(1, time_slices);
range = zeros(1, time_slices);

for t = 1:time_slices
    % for each spectrum of the spectrogram
    % find the two local max (try to avoid finding two adjacent bins)
    % then use f_b + f_d formulas

    spec = s(:, t);
    spec = abs(spec);

    max_mask = islocalmax(spec);              
    peak_vals = spec(max_mask);  

    % for debugging the peaks
    %plot_spectrum_with_peaks(spec, max_mask, fs);
    
    if numel(peak_vals) >= 2
        [~, idx_sorted] = maxk(peak_vals, 2);         
        peak_indices_in_spec = find(max_mask);    
        top2_indices = peak_indices_in_spec(idx_sorted);
        top2_values = spec(top2_indices);          
    elseif numel(peak_vals) == 1
        top2_indices = find(max_mask);
        top2_values = spec(top2_indices);
    else
        top2_indices = [];
        top2_values = [];
    end

    top2_indices = top2_indices * fs / fft_length;

    f_b = 0.5 * (top2_indices(1) + top2_indices(2));
    f_d = 0.5 * (top2_indices(1) - top2_indices(2));

    range(t) = c0 / (2 * gamma) * f_b;
    v_r(t)   = c0 / (2 * f_c)   * f_d;
end

r_min = min(range);
r_max = max(range);
v_min = min(v_r);
v_max = max(v_r);

fprintf('Raw:\n');
fprintf('Range:   Min = %.3f m, Max = %.3f m\n', r_min, r_max);
fprintf('Velocity: Min = %.3f m/s, Max = %.3f m/s\n', v_min, v_max);

range_filtered = sgolayfilt(range, 3, 11);
v_r_filtered = sgolayfilt(v_r, 3, 11);

r_min_f = min(range_filtered);
r_max_f = max(range_filtered);

v_r_min_f = min(v_r_filtered);
v_r_max_f = max(v_r_filtered);

fprintf('\nFiltered:\n');
fprintf('Range:   Min = %.3f m, Max = %.3f m\n', r_min_f, r_max_f);
fprintf('Velocity: Min = %.3f m/s, Max = %.3f m/s\n', v_r_min_f, v_r_max_f);
fprintf('For Q. 4.2.2: %.3f m\n', mean(range_filtered));

% Time or index axis
t = 1:length(range);

% Create figure
figure('Color', 'w', 'Position', [100, 100, 1000, 500]);

% === Plot 1: Range ===
subplot(2,1,1);
plot(t, range, '--k', 'LineWidth', 1); hold on;
plot(t, range_filtered, 'b', 'LineWidth', 2);
yline(r_min, ':r', 'Min', 'LabelVerticalAlignment','bottom');
yline(r_max, ':g', 'Max', 'LabelVerticalAlignment','bottom');
grid on;
title('Range over Time');
xlabel('Time (samples)');
ylabel('Range (m)');
legend('Original', 'Smoothed', 'Min', 'Max');
ylim([r_min - 0.05*(r_max - r_min), r_max + 0.05*(r_max - r_min)]);

% === Plot 2: Velocity ===
subplot(2,1,2);
plot(t, v_r, '--k', 'LineWidth', 1); hold on;
plot(t, v_r_filtered, 'r', 'LineWidth', 2);
yline(v_min, ':b', 'Min', 'LabelVerticalAlignment','bottom');
yline(v_max, ':m', 'Max', 'LabelVerticalAlignment','bottom');
grid on;
title('Radial Velocity over Time');
xlabel('Time (samples)');
ylabel('Velocity (m/s)');
legend('Original', 'Smoothed', 'Min', 'Max');
ylim([v_min - 0.05*(v_max - v_min), v_max + 0.05*(v_max - v_min)]);

sgtitle('Range and Velocity with Smoothing & Limits');



function plot_spectrum_with_peaks(spec, max_mask, fs)
    % Plots the spectrum and overlays peaks provided by max_mask
    %
    % Inputs:
    %   spec      - Spectrum vector (e.g., abs(FFT))
    %   fs        - Sampling frequency (Hz)
    %   max_mask  - Logical vector (same size as spec), true where peaks are

    N = length(spec);
    f = linspace(0, fs/2, N);  % Frequency axis (assuming one-sided spectrum)

    % Get peak locations
    peak_freqs = f(max_mask);
    peak_vals = spec(max_mask);

    % Plot spectrum and peaks
    figure('Color','w');
    plot(f, spec, 'b-', 'LineWidth', 1.5); hold on;
    plot(peak_freqs, peak_vals, 'ro', 'MarkerSize', 6, 'LineWidth', 1.5);  % red circles
    grid on;
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title('Spectrum with Provided Peaks');
    legend('Spectrum', 'Detected Peaks');
end
