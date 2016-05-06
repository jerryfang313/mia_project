function [ x, y, r, calc_mask ] = returnCalcification( newImage, calcSpecs, normalizationCoeffs, normalizedVectors )

load training_results.mat

histEqImage = myHistEq(newImage, 0.05);
blurredImage = blur(histEqImage);

imSize = size(blurredImage);
x = 0;
y = 0;
r = 0;

imMean = sum(sum(blurredImage)) / (imSize(1) * imSize(2));

threshold = 2;
aboveThreshold = newImage > imMean;
constrain = 0;
param = 0;
thickness = 0;

calc_mask = zeros(imSize);

checkedPixels = calc_mask;

scoreThreshold = 0.98;

% Loop over rows
for i = 1:(imSize(1)/2)
    currentI = i*2;
    % Loop over cols
    for j = 1:(imSize(2)/2)
        currentJ = j*2;
        if ~checkedPixels(currentI,currentJ) && aboveThreshold(currentI,currentJ)
            
            [R_Mask, B_Mask, equalSeeds] = MIA_Grow(blurredImage, [currentI,currentJ], threshold, constrain, param, thickness);
            
            feature = MIA_GetFeature(blurredImage, R_Mask, B_Mask);
            
            feature = feature ./ normalizationCoeffs; 
            
            distances = compareToFeatVectors(feature, normalizedVectors);
            
            score = 1 ./ (1 + distances);
            
            bestScore = max(score);
            
            checkedPixels(currentI,currentJ) = true;
            
            for k = 1:size(equalSeeds,1)
                checkedPixels(equalSeeds(k,1), equalSeeds(k,2)) = true;
            end
            
            if bestScore > scoreThreshold
                calc_mask = calc_mask | R_Mask; 
                currentI
                currentJ
                bestScore
            end
            
            
        end
    end
end

end

