function [leftbb,rightbb] = bbFind2(newInputImage)
load brain1mat
load brain2mat
load brain3mat
load brain4mat
load brain5mat
load brain6mat
load atlas 

% set threshold on intensity
newInputImage(newInputImage < 0) = 0;
vals = reshape(newInputImage, [], 1, 1);
cap = prctile(vals, 99); % cap intensity 
newInputImage(newInputImage > cap) = cap;

%define bounding box as 0
leftbb = zeros(size(newInputImage));
rightbb = zeros(size(newInputImage));
bestSSD = realmax; %set a arbitrary SSD value

% compute points from the brain to be used for registration
[outNewImage] = findPoint(newInputImage);
[out1] = findPoint(brain1);
[out2] = findPoint(brain2);
[out3] = findPoint(brain3);
[out4] = findPoint(brain4);
[out5] = findPoint(brain5);
[out6] = findPoint(brain6);

out = {out1;out2;out3;out4;out5;out6};

%determine which training image produce the lowest SSD and therefore the
%best registration
for i = 1:size(out,1)
[R,P] = registrationFD(outNewImage,out{i});
Pmat = repmat(P,1,size(outNewImage,2));
[cost] = SSDCost(out{i},R*outNewImage+Pmat);
costMat(i,1) = cost;
end

minCost = min(costMat);
costindex = find(costMat==minCost);

% registration with the training image that has the lowest SSD cost
[R1,P1] = registrationFD(outNewImage,out{costindex});

% set the 3x4 bounding box
box(1,:) = leftMinRCL(costindex,:);
box(2,:) = leftMaxRCL(costindex,:);
box(3,:) = rightMinRCL(costindex,:);
box(4,:) = rightMaxRCL(costindex,:);
box = box';

% inverse transformation for B = R*A+P is A = R^T*(B-P)
Pf = repmat(P1,1,size(box,2));
newBox = R1'*(box-Pf);

%[leftminR leftmaxR rightminR rightmaxR
% leftminC leftmaxC rightminC rightmaxC
% leftminL leftmaxL rightminL rightmaxL]
leftbb(newBox(1,1):newBox(1,2), newBox(2,1):newBox(2,2), newBox(3,1):newBox(3,2)) = 1;
rightbb(newBox(1,3):newBox(1,4), newBox(2,3):newBox(2,4), newBox(3,3):newBox(3,4)) = 1;

%plot
figure 
subplot(2,2,1);
imagesc(newInputImage(:,:,125)); % sample at layer 125
title('Input image')

subplot(2,2,2);
imagesc(leftbb(:,:,125));
title('Left BB')

subplot(2,2,4);
imagesc(rightbb(:,:,125));
title('right BB')
end
