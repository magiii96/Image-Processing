function [result] = computeWeighting(d, h, sigma, patchSize)
    %Implement weighting function from the slides
    %Be careful to normalise/scale correctly!
    
    %normalize the distance according to the patchsize
    d = d/patchSize^2;
    % normalize 3 channels
    %d = d/3;
    
    %REPLACE THIS
    result = exp(-max(d-2*sigma^2,0.0)/h^2);
end