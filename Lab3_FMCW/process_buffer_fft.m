function [strongest_freqs, spectrogram_data] = process_buffer_fft(buffer, chunk_size, overlap)
    % Default chunk size if not provided
    if nargin < 2
        chunk_size = 1024;  % Default chunk size
    end
    
    % Default overlap if not provided (50% overlap)
    if nargin < 3
        overlap = round(chunk_size / 2);  % Default overlap (50% overlap)
    end
    
    % Get the number of chunks based on the buffer length
    num_chunks = ceil(length(buffer) / chunk_size);
    
    % Initialize the result vector to store the strongest frequencies
    strongest_freqs = zeros(1, num_chunks);  % Vector for strongest frequencies
    
    % Sampling frequency (you can adjust this based on your system)
    f_sampling = 1e6;  % Example: 1 MHz sampling rate (change as per your system)
    
    % Loop through the buffer and process each chunk
    for i = 1:num_chunks
        % Determine the start and end indices for the current chunk
        start_idx = (i-1) * chunk_size + 1;
        end_idx = min(i * chunk_size, length(buffer));
        
        % Extract the chunk from the buffer
        chunk = buffer(start_idx:end_idx);
        
        % Apply FFT to the chunk
        magnitude = abs(fft(chunk));
        
        % Find the index of the maximum magnitude (excluding the DC component)
        [~, max_index] = max(magnitude(2:end));  % Ignore DC (index 1)
        
        freq_bin = max_index + 1;  % Adjust index because we ignored DC component
        freq_resolution = f_sampling / length(chunk);
        strongest_freq = (freq_bin - 1) * freq_resolution;
        
        % Store the strongest frequency for this chunk
        strongest_freqs(i) = strongest_freq;
    end
    
    % Now generate the spectrogram
    [spectrogram_data, ~, ~, ~, freq] = spectrogram(buffer, chunk_size, overlap, [], f_sampling); 
end
