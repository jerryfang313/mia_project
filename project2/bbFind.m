function [ leftbb, rightbb ] = bbFind( newInputImage )
tic;
load atlas 
load brain1mat 
load brain2mat 
load brain3mat 
load brain4mat 
load brain5mat 
load brain6mat

newInputImage(newInputImage < 0) = 0;
vals = reshape(newInputImage, [], 1, 1);
cap = prctile(vals, 99);
newInputImage(newInputImage > cap) = cap;
newInputImage = newInputImage * 255 / cap;
[newShrunk, ~, ~, ~] = shrinkImage(newInputImage, shrinkFactor);

leftbb = zeros(size(newInputImage));
rightbb = zeros(size(newInputImage));
origBrains = {brain1; brain2; brain3; brain4; brain5; brain6};
clear brain1 brain2 brain3 brain4 brain5 brain6

bestSSD = realmax;
bestIter = 0;

for iter = 1:numBrains-1
    scale = 1;
    tr = 0;
    tc = 0;
    tl = 0;
    
    disp(['registering shrunk brain ' num2str(iter)]);
    [scale, tr, tc, tl, SSD] = register(newShrunk, shrunkBrains{iter}, scale, tr, tc, tl);
    disp(['SSD: ' num2str(SSD)]);
    if (SSD < bestSSD)
        bestIter = iter;
        bestSSD = SSD;
        bestscale = scale;
        besttr = tr * 4;
        besttc = tc * 4;
        besttl = tl * 4;
    end
end

disp(['Chose iteration ' num2str(bestIter)]);

minLeft = round([leftMinRCL(bestIter,:) - [tr tc tl]] / scale);
maxLeft = round([leftMaxRCL(bestIter,:) - [tr tc tl]] / scale);
minRight = round([rightMinRCL(bestIter,:) - [tr tc tl]] / scale);
maxRight = round([rightMaxRCL(bestIter,:) - [tr tc tl]] / scale);

leftbb(minLeft(1):maxLeft(1), minLeft(2):maxLeft(2), minLeft(3):maxLeft(3)) = 1;
rightbb(minRight(1):maxRight(1), minRight(2):maxRight(2), minRight(3):maxRight(3)) = 1;
toc;
end

