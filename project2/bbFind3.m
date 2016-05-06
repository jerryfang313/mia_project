function [ leftbb, rightbb ] = bbFind3( newInputImage )
load atlas 
load brain1mat 
load brain2mat 
load brain3mat 
load brain4mat 
load brain5mat 
load brain6mat

disp(size(newInputImage))
newInputImage = newInputImage(1:246, 1:291, 1:236);
newInputImage(newInputImage < 0) = 0;
vals = reshape(newInputImage, [], 1, 1);
cap = prctile(vals, 99);
newInputImage(newInputImage > cap) = cap;
newInputImage = round(newInputImage * 255 / cap);

leftbb = zeros(size(newInputImage));
rightbb = zeros(size(newInputImage));
origBrains = {
    round(brain1); 
    round(brain2); 
    round(brain3); 
    round(brain4); 
    round(brain5); 
    round(brain6)};
clear brain1 brain2 brain3 brain4 brain5 brain6

bestMI = -realmax;
bestBrain = 0;
for iter = 1:numBrains
    MI = mutual(newInputImage, origBrains{iter});
    disp(['MI: ' num2str(MI)]);
    if MI > bestMI
        bestMI = MI;
        bestBrain = iter;
    end
end

disp(['Chose iteration ' num2str(bestBrain)]);

minLeft = leftMinRCL(bestBrain,:) - [1 1 1];
disp(['minLeft: ' num2str(minLeft)]);
% disp(['trueMinLeft: ' num2str(leftMinRCL(1,:))]);
maxLeft = leftMaxRCL(bestBrain,:) + [1 1 1];
disp(['maxLeft: ' num2str(maxLeft)]);
% disp(['trueMaxLeft: ' num2str(leftMaxRCL(1,:))]);
minRight = rightMinRCL(bestBrain,:) - [1 1 1];
disp(['minRight: ' num2str(minRight)]);
% disp(['trueMinRight: ' num2str(rightMinRCL(1,:))]);
maxRight = rightMaxRCL(bestBrain,:) + [1 1 1];
disp(['maxRight: ' num2str(maxRight)]);
% disp(['trueMaxRight: ' num2str(rightMaxRCL(1,:))]);

leftbb(minLeft(1):maxLeft(1), minLeft(2):maxLeft(2), minLeft(3):maxLeft(3)) = 1;
rightbb(minRight(1):maxRight(1), minRight(2):maxRight(2), minRight(3):maxRight(3)) = 1;
end

function [mi] = mutual(A, B)
    A = squeeze(reshape(A, [], 1, 1));
    B = squeeze(reshape(B, [], 1, 1));
    histA = hist(A, 0:255)/numel(A);
    histB = hist(B, 0:255)/numel(B);

    histA = histA(histA ~= 0);
    histB = histB(histB ~= 0);
    HA = -sum(histA .* log(histA));
    HB = -sum(histB .* log(histB));
    HAB = zeros(256, 256);
    for i = 1:numel(A);
        HAB(A(i) + 1, B(i) + 1) = HAB(A(i) + 1, B(i) + 1) + 1;
    end
    HAB = HAB / numel(A);
    HAB = squeeze(reshape(HAB, [], 1, 1));
    HAB = HAB(HAB ~= 0);
    HAB = -sum(HAB .* log(HAB));
    mi = HA + HB - HAB;
end
