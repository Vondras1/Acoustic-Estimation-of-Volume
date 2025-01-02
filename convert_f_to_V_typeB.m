function V = convert_f_to_V_typeB(f)
    % Converts frequency to volume for a type B bottle based on a polynomial model.
    %
    % Inputs:
    % - f: Frequency (Hz) for which the volume needs to be estimated.
    %
    % Outputs:
    % - V: Estimated volume (ml) corresponding to the input frequency.

    % Coefficients of the polynomial (Volume as a function of Frequency)
    p5 = [-2.87505647667480e-13	3.96064793875682e-09	-2.17163742258517e-05	0.0593222651201244	-81.0059373477689	44649.6799524653];
    
    % Evaluate the polynomial at the given frequency
    V = polyval(p5, f);
end