function V = convert_f_to_V_typeA(f)
    % Converts frequency to volume for a milk bottle based on a polynomial model.
    %
    % Inputs:
    % - f: Frequency (Hz) for which the volume needs to be estimated.
    %
    % Outputs:
    % - V: Estimated volume (ml) corresponding to the input frequency.

    % Coefficients of the polynomial (Volume as a function of Frequency)
    p5 = [-8.10005546311933e-13, 8.71690921938181e-09, -3.79652972989008e-05, 0.0837905216263537, -94.0829661873384, 43545.2170235549];
    
    % Evaluate the polynomial at the given frequency
    V = polyval(p5, f);
end
