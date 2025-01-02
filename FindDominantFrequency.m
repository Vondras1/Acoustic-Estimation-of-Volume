function dominant_frequency = FindDominantFrequency(absY, f)
    % Finds the dominant frequency in the amplitude spectrum.
    %
    % Inputs:
    %   absY - Amplitude spectrum (absolute values).
    %   f - Frequency vector corresponding to the spectrum.
    %
    % Output:
    %   dominant_frequency - Frequency with the highest smoothed amplitude.

    % Set window size for moving average
    windowSize = 10;
    
    % Apply moving average to the amplitude spectrum
    smoothedAmplitude = movmean(absY, windowSize);
    
    % Find index of maximum amplitude in smoothed spectrum
    [~, idx] = max(smoothedAmplitude);
    
    % Find corresponding frequency
    dominant_frequency = f(idx);
end