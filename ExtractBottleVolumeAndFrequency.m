function [sortedVolumes, sortedFrequencies] = ExtractBottleVolumeAndFrequency(path, forename)
    % Analyzes audio files to extract volumes and dominant frequencies of bottles.
    % 
    % Inputs:
    % - path: Path to the folder containing audio files.
    % - forename: Prefix of the file names (e.g., 'MilkBottle_' or 'RandomBottle_').
    %
    % Outputs:
    % - sortedVolumes: Sorted array of volumes (ml).
    % - sortedFrequencies: Corresponding frequencies (Hz) sorted by volume.

    % Create a file pattern using the forename variable
    filePattern = fullfile(path, [forename, '*.m4a']); % Search for files matching the pattern
    files = dir(filePattern); % List all matching files
    
    % Initialize arrays to store volumes and frequencies
    volumes = [];
    frequencies = [];
    
    % Set parameters based on the bottle type
    if strcmp(forename, 'MilkBottle_')
        m_empty = 314; % Empty bottle weight [g]
        water_density = 997; % Water density [g/l^3]
        low_cutoff = 1400; % Lower cutoff frequency in Hz
        high_cutoff = 2900; % Upper cutoff frequency in Hz
    elseif strcmp(forename, 'RandomBottle_')
        % empty bottle weight
        m_empty = 169; % Empty bottle weight [g]
        water_density = 997; % Water density [g/l^3]
        low_cutoff = 1800; % Lower cutoff frequency in Hz
        high_cutoff = 3800; % Upper cutoff frequency in Hz
    else
        error('Unsupported bottle type. Please provide a valid forename.');
    end
    
    % Loop over each audio file
    for k = 1:length(files)
        % Get the filename and full path
        filename = files(k).name;
        fullFilePath = fullfile(path, filename);
    
        % Read the audio file
        [y, Fs] = audioread(fullFilePath);
        
        % Apply the bandpass filter
        y_filtered = BandPass(y, Fs, low_cutoff, high_cutoff);
        
        % Signal length
        N = length(y_filtered);
        
        % Compute the FFT of the filtered signal
        Y = fft(y_filtered);
        
        % Get the magnitude spectrum (only the first half due to symmetry)
        absY = abs(Y(1:floor(N/2)+1));
        
        % Frequency axis
        f = (0:floor(N/2)) * (Fs / N);
        
        % Find the dominant frequency
        dominant_frequency = FindDominantFrequency(absY, f);
        
        % Extract the volume from the filename
        [~, name, ~] = fileparts(filename);
        MassStr = extractAfter(name, forename);
        mass = str2double(MassStr);
        volume = ((mass-m_empty) / water_density)*1000; % [ml]
        
        % Store the volume and frequency
        volumes = [volumes; volume];
        frequencies = [frequencies; dominant_frequency];
    end

    % Sort the results by volume
    [sortedVolumes, idx] = sort(volumes); % Sort volumes and get indices
    sortedFrequencies = frequencies(idx); % Rearrange frequencies based on sorted indices
    
    %%Optionally
    %%Create a results table for further analysis
    %sortedResults = table(sortedVolumes, sortedFrequencies, 'VariableNames', {'Volume', 'Frequency'});
    
    %%Display the results table 
    % disp(sortedResults);
end