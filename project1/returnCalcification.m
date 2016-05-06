function [ x, y, r, calc_mask ] = returnCalcification(newImage)

load training_results.mat

histEqImage = myHistEq(newImage, 0.05);
blurredImage = blur(histEqImage);

imSize = size(blurredImage);
x = 0;
y = 0;
r = 0;

resizedIm = reshape(blurredImage, 1, imSize(1) * imSize(2));

imMedian = median(resizedIm);

aboveThreshold = blurredImage > imMedian;

calc_mask = zeros(imSize);

checkedPixels = calc_mask;

scoreThreshold = 0.50;

row = 1;
col = 1;

threshold = 1;

sampleFreq = 100;

% Loop over rows
for i = 1:imSize(1)/sampleFreq
    currentI = i*sampleFreq;
    % Loop over cols
    for j = 1:imSize(2)/sampleFreq
        currentJ = j*sampleFreq;
        if ~checkedPixels(currentI,currentJ) && aboveThreshold(currentI,currentJ)
                        
            [R_Mask, B_Mask] = MIA_Grow(blurredImage, [currentI,currentJ], threshold);
            
            feature = MIA_GetFeature(blurredImage, R_Mask, B_Mask);
            
            normFeature = feature ./ normCoeffs; 
            
            distances = compareToFeatVectors(normFeature, normFeatVectors);
            
            score = 1 ./ (1 + distances);
            
            bestScore = max(score);
            
            checkedPixels(currentI,currentJ) = true;

            %{
            for k = 1:size(equalSeeds,1)
                checkedPixels(equalSeeds(k,1), equalSeeds(k,2)) = true;
            end
            %}
            
            if bestScore > scoreThreshold
                calc_mask = R_Mask; 
                scoreThreshold = bestScore
                row = currentI
                col = currentJ
            end
            
        end
    end
end

x = col;
y = size(calc_mask,1) - row;

maskSumX = sum(calc_mask, 1);
maskSumY = sum(calc_mask, 2);

i = 1;
row_temp = 0;
while row_temp == 0 && i ~= size(calc_mask, 1) + 1
    row_temp = maskSumX(i);
    i = i + 1;
end
minX = i - 1;

i = length(maskSumX);
row_temp = 0;
while row_temp == 0 && i ~= -1
    row_temp = maskSumX(i);
    i = i - 1;
end
maxX = i + 1;

i = 1;
col_temp = 0;
while col_temp == 0 && i ~= size(calc_mask, 2) + 1
    col_temp = maskSumY(i);
    i = i + 1;
end
minY = i - 1;

i = length(maskSumY);
col_temp = 0;
while col_temp == 0 && i ~= -1
    col_temp = maskSumY(i);
    i = i - 1;
end
maxY = i + 1;

r = 10 * max([maxX - col, col - minX, maxY - row, row - minY]);

if r > 50
    r = 50;
end



end

