function [S, F, T] = make_spectrogram(buffer, f_sampling, chunk_size, overlap)
    % make_spectrogram - Computes the spectrogram of a signal buffer
    %
    % Inputs:
    %   buffer       - Time-domain signal vector
    %   f_sampling   - Sampling frequency in Hz
    %   chunk_size   - Window size (FFT length)
    %   overlap      - Overlap between segments (in samples)
    %
    % Outputs:
    %   S - Spectrogram matrix (complex)
    %   F - Frequency vector (Hz)
    %   T - Time vector (s)

    % Default chunk size if not provided
    if nargin < 3
        chunk_size = 1024;
    end

    % Default overlap if not provided (50%)
    if nargin < 4
        overlap = round(chunk_size / 2);
    end

    % Apply windowing (Hann window)
    win = blackmanharris(chunk_size);

    % Compute spectrogram
    [S, F, T] = spectrogram(buffer, win, overlap, chunk_size, f_sampling);

    % Optional: Plot the spectrogram
    figure;
    imagesc(T, F, 10*log10(abs(S)));
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Spectrogram');
    colorbar;
end
