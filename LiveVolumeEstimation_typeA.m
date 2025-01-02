%% Live Volume Estimation
% This program processes live audio from a microphone, analyzes it, and 
% determines the domain frequency and amplitude in real time. Based on this
% data, it estimates the volume of bottle, if the sound originates from a bottle.

clear all; clc;

% Initialize parameters
Fs = 48000; % Sampling frequency (Hz)
frameDuration = 0.1; % Frame duration in seconds (100 ms)
frameSize = round(frameDuration * Fs); % Samples per frame
overlapDuration = 0.05; % Overlap duration in seconds (50 ms)
overlapLength = round(overlapDuration * Fs); % Samples of overlap

% Setup audio device reader for live audio input
deviceReader = audioDeviceReader('SampleRate', Fs, 'SamplesPerFrame', frameSize);

% STFT parameters
window_length = frameSize;
window = hamming(window_length, 'periodic');

% Define frequency range and minimum amplitude threshold based on the bottle's shape
low_cutoff = 1400; % Minimum frequency of interest (Hz)
high_cutoff = 2900; % Maximum frequency of interest (Hz)
min_credible_amplitude = 100; % Minimum credible amplitude threshold

% Initialize Buffers and Variables
buffer = zeros(overlapLength, 1); % Buffer for frame overlap
maxSize = 10; % Maximum size of the circular buffer
circularBuffer = [];

% Variables for storing current and previous measurements
current_max_measurement = [0; 0];
last_max_measurement = [0; 0];

% Create a figure window for real-time visualization of results
figure_handle = figure('Name', 'Live Audio Processing', 'NumberTitle', 'off');
set(figure_handle, 'Position', [100, 100, 350, 150]); % Set figure size and position
volume_text = uicontrol('Style', 'text', 'Position', [10 90 330 40], 'FontSize', 14, 'HorizontalAlignment', 'center', 'String', 'Volume = ');
frequency_text = uicontrol('Style', 'text', 'Position', [10 50 330 40], 'FontSize', 14, 'HorizontalAlignment', 'center', 'String', 'Frequency = ');
amplitude_text = uicontrol('Style', 'text', 'Position', [10 10 330 40], 'FontSize', 14, 'HorizontalAlignment', 'center', 'String', 'Amplitude = ');

% Main loop for live audio processing
disp('Starting live audio processing... Close the figure window to stop.');
while true
    % Check if figure is still open. If not, exit the program.
    if ~ishandle(figure_handle)
        disp('Figure closed. Exiting...');
        break;
    end

    % Read audio frame from the device
    audioData = deviceReader();

    % Combine current audio data with the buffer for overlap
    y = [buffer; audioData];

    % Update the buffer with the last part of the current frame for overlap
    buffer = audioData(end - overlapLength + 1 : end);

    % Compute STFT for frequency domain analysis
    [stft_data, f] = stft(y, Fs, 'Window', window, 'OverlapLength', overlapLength);

    % Compute time vector for display purposes
    t = (0:size(stft_data, 2)-1) * (window_length - overlapLength) / Fs;

    % Find frequencies within the desired range
    freq_idx = (f >= low_cutoff) & (f <= high_cutoff);

    % Process each time frame in the STFT result
    for i = 1:length(t)
        % Get an amplitude spectrum in current the current time span
        spectrum = abs(stft_data(:, i));

        % Select required part of spectrum
        spectrum_in_range = spectrum(freq_idx);
        f_in_range = f(freq_idx);

        % Find max amplitude and its index     
        [max_ampl, max_idx] = max(spectrum_in_range);

        % Save dominant frequency
        dominant_frequency = f_in_range(max_idx);

        % Update circular buffer
        [circularBuffer, MaxElement] = addToBuffer(circularBuffer, [max_ampl; dominant_frequency], maxSize);

        % Check if the measurement is credible and corresponds to a bottle
        if (max_ampl > min_credible_amplitude && MaxElement(2) == dominant_frequency)
            current_max_measurement = MaxElement;
        end
    end

    % Update visualization if a new frequency is detected
    if (last_max_measurement(2) ~= current_max_measurement(2))
        last_max_measurement = current_max_measurement;
        volume = convert_f_to_V_typeA(current_max_measurement(2));
        
        % Update the text fields
        set(frequency_text, 'String', sprintf('Frequency = %.2f [Hz]', current_max_measurement(2)));
        set(amplitude_text, 'String', sprintf('Amplitude = %.2f [-]', current_max_measurement(1)));
        set(volume_text, 'String', sprintf('Volume = %.2f [ml]', volume));
    end

    % Force MATLAB to update the figure
    drawnow;
end
