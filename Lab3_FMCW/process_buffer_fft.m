function [strongest_freqs, power] = process_buffer_fft(buffer, f_sampling, chunk_size, overlap)
    % Default chunk size if not provided
    if nargin < 3
        chunk_size = 1024;  % Default chunk size
    end
    
    % Default overlap if not provided (50% overlap)
    if nargin < 4
        overlap = round(chunk_size / 2);  % Default overlap (50% overlap)
    end
    
    % Get the number of chunks based on the buffer length
    num_chunks = ceil(length(buffer) / chunk_size);
    
    % Initialize the result vector to store the strongest frequencies
    strongest_freqs = zeros(1, num_chunks);  % Vector for strongest frequencies
    power = zeros(1, num_chunks);

    % Loop through the buffer and process each chunk
    for i = 1:num_chunks
        % Determine the start and end indices for the current chunk
        start_idx = (i-1) * chunk_size + 1;
        end_idx = min(i * chunk_size, length(buffer));
        
        % Extract the chunk from the buffer
        chunk = buffer(start_idx:end_idx);
        
        % Apply FFT to the chunk and normalize as fft is integrating
        magnitude = abs(fft(chunk).^2 / chunk_size);
        
        % Find the index of the maximum magnitude (excluding the DC component)
        [pwr, max_index] = max(magnitude(2:end));  % Ignore DC (index 1)
        
        freq_bin = max_index + 1;  % Adjust index because we ignored DC component
        freq_resolution = f_sampling / length(chunk);
        strongest_freq = (freq_bin - 1) * freq_resolution;
        power(i) = pwr;
        % Store the strongest frequency for this chunk
        strongest_freqs(i) = strongest_freq;
    end
    
    power = 10 * log10(power);

    % Now generate the spectrogram
    %[spectrogram_data, ~, ~, ~, ~] = spectrogram(buffer, chunk_size, overlap, [], f_sampling); 
end
