function [R_Mask, B_Mask] = MIA_Grow(inImage, inPoint, threshold, constrain, param, thickness)

R_Mask = zeros(size(inImage));
B_Mask = R_Mask;

lowerBound = inImage(inPoint(1), inPoint(2)) - threshold;
upperBound = inImage(inPoint(1), inPoint(2)) + threshold;

[R_Mask, B_Mask] = MIA_GrowPoint(inImage, inPoint, R_Mask, B_Mask, lowerBound, upperBound);

end


