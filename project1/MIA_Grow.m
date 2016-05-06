function [R_Mask, B_Mask] = MIA_Grow(inImage, inPoint, threshold)

R_Mask = zeros(size(inImage));
B_Mask = R_Mask;

lower = inImage(inPoint(1), inPoint(2)) - threshold;
upper = inImage(inPoint(1), inPoint(2)) + threshold;

toCheck = zeros(10000,2);
toCheck(1,:) = inPoint;

numToCheck = 1;
numChecked = 0;

equalSeeds = [];
while numChecked < numToCheck
    numChecked = numChecked + 1;
    [R_Mask, B_Mask, numToCheck, toCheck, equalSeeds] = MIA_CheckPoint(inImage, toCheck(numChecked,:), numToCheck, toCheck, R_Mask, B_Mask, lower, upper, seed, equalSeeds);

end
toCheck(1:5,:);
end


