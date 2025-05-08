function [S, F, T] = make_spectrogram(buffer, f_sampling, chunk_size, overlap)
    % out
    %   S - Spectrogram
    %   F - Frequency vector 
    %   T - Time vector

    if nargin < 3
        chunk_size = 1024;
    end

    if nargin < 4
        overlap = round(chunk_size / 2);
    end

    win = blackmanharris(chunk_size);
    [S, F, T] = spectrogram(buffer, win, overlap, chunk_size, f_sampling);

    figure;
    imagesc(T, F, 10*log10(abs(S)));
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Spectrogram');
    colorbar;
end
