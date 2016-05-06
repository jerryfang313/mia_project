function [ x, y, r, calc_mask ] = returnCalcification(newImage)

load training_results.mat

histEqImage = myHistEq(newImage, 0.05);
blurredImage = blur(histEqImage);

imSize = size(blurredImage);
x = 0;
y = 0;
r = 0;

imMean = sum(sum(blurredImage)) / (imSize(1) * imSize(2));

threshold = 1;
aboveThreshold = blurredImage > imMean;

calc_mask = zeros(imSize);

checkedPixels = calc_mask;

scoreThreshold = 0.9;

% Loop over rows
%for i = 1:(imSize(1)/5)
for i = 490:510
    
    % Loop over cols
    for j = 1:imSize(2)
        currentI = i
        currentJ = j
        if ~checkedPixels(currentI,currentJ) && aboveThreshold(currentI,currentJ)
            
            [R_Mask, B_Mask, equalSeeds] = MIA_Grow(blurredImage, [currentI,currentJ], threshold, seed);
            
            feature = MIA_GetFeature(blurredImage, R_Mask, B_Mask);
            
            normFeature = feature ./ normCoeffs; 
            
            distances = compareToFeatVectors(normFeature, normFeatVectors);
            
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

