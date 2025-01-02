clear all; clc;

%% Load Dataset
% Path to the dataset folder
path = "TODO";

% Load data
[volumes, frequencies] = ExtractBottleVolumeAndFrequency(path, 'MilkBottle_');

%% Fitting: Frequencies as a function of volumes
order1 = 4; % Order of the polynomial
[p1, volumes_fit, frequencies_fit] = fit_polynomial(volumes, frequencies, order1);

% Plot the fitted curve and original data
figure;
scatter(volumes, frequencies, 'bo', 'DisplayName', 'Measured data'); % Original data points
hold on;
plot(volumes_fit, frequencies_fit, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Fitted polynomial (order %d)', order1)); % Fitted polynomial curve
xlabel('Volume [ml]');
ylabel('Frequency [Hz]');
title('Frequencies as a function of volumes');
legend('Location', 'best');
grid on;
hold off;

% Display polynomial coefficients
disp('Polynomial coefficients (Frequency as a function of Volume):');
disp(p1);

% Calculate percentage error
frequencies_fit_measured = polyval(p1, volumes);
percentage_error1 = abs(frequencies - frequencies_fit_measured) / max(frequencies);

% Display the sum of percentage errors
disp('Sum of percentege errors 1:');
disp(sum(percentage_error1));

% Plot percentage error
figure;
plot(volumes, percentage_error1 * 100, 'k-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'percentege error');
xlabel('Volume [ml]');
ylabel('Error [%]');
title('Percentage error between measured values and fitted curve');
grid on;
legend('Location', 'best');

%% Fitting: Volumes as a function of frequencies

% Sort data by frequency
[sortedFrequencies, idx] = sort(frequencies); % Sort frequencies and get indices
sortedVolumes = volumes(idx); % Rearrange volumes to match sorted frequencies

order2 = 5; % Order of the polynomial
[p2, frequencies_fit, volumes_fit] = fit_polynomial(sortedFrequencies, sortedVolumes, order2);

% Plot the fitted curve and original data
figure;
scatter(sortedFrequencies, sortedVolumes, 'bo', 'DisplayName', 'Measured data'); % Original data points
hold on;
plot(frequencies_fit, volumes_fit, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Fitted polynomial (order %d)', order2)); % Fitted polynomial curve
xlabel('Frequency [Hz]');
ylabel('Volume [ml]');
title('Volumes as a function of frequencies');
legend('Location', 'best');
grid on;
hold off;

% Calculate percentege error
volumes_fit_measured = polyval(p2, sortedFrequencies);
percentage_error2 = abs(sortedVolumes - volumes_fit_measured) / max(sortedVolumes);

% Display the sum of percentege errors
disp('Sum of percentege errors 2:');
disp(sum(percentage_error2));

% Plot percentage error between measured values and fitted curve
figure;
plot(sortedFrequencies, percentage_error2 * 100, 'k-o', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Frequency [Hz]');
ylabel('Error [%]');
title('Percentage error');
grid on;


%% Function to fit data with a polynomial
function [p, x_fit, y_fit] = fit_polynomial(x, y, poly_order)
    % Fits a polynomial to the given data and generates fitted values

    p = polyfit(x, y, poly_order);
    x_fit = linspace(min(x), max(x), 100);
    y_fit = polyval(p, x_fit);
end
