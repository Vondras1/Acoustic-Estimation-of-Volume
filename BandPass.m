function y_filtered = BandPass(y, Fs, low_cutoff, high_cutoff)
    % y - measured signal
    % Fs - sampling frequncy
    % low_cutoff - Lower cutoff frequency in Hz
    % hight_cutoff - Upper cutoff frequency in Hz
    
    % Define filter order
    filter_order = 4; % Filter order
    
    % Design the bandpass filter
    [b, a] = butter(filter_order, [low_cutoff high_cutoff]/(Fs/2), 'bandpass');
    
    % Apply the filter to the original signal in the time domain
    y_filtered = filter(b, a, y);
end