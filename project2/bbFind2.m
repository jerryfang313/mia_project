% main program. Locate and place left and right bounding boxes to the thalamus.

% Input: matrix of test image. get from ReadXml
% Output: leftbb - matrix of the left bb with size equal to test image
%         rightbb - matrix of the right bb with size equal to test image
%         box - 3x4 matrix. original bounding box location. get from matrix atlas 
%         newBox - 3x4 matrix. new set of values generated from inverse
%                  transformation
%
% The output of the box is formatted as 
%[leftminR leftmaxR rightminR rightmaxR
% leftminC leftmaxC rightminC rightmaxC
% leftminL leftmaxL rightminL rightmaxL]


function [leftbb,rightbb,box,newBox] = bbFind2(newInputImage)
tic
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
oldleftbb = zeros(size(newInputImage));
oldrightbb = zeros(size(newInputImage));
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

%Set layer to integer values
newBox(:,1) = floor(newBox(:,1));
newBox(:,2) = ceil(newBox(:,2));
newBox(:,3) = floor(newBox(:,3));
newBox(:,4) = ceil(newBox(:,4));

% Output bounding box

leftbb(newBox(1,1):newBox(1,2), newBox(2,1):newBox(2,2),newBox(3,1):newBox(3,2)) = 1;
rightbb(newBox(1,3):newBox(1,4),newBox(2,3):newBox(2,4),newBox(3,3):newBox(3,4)) = 1;
oldleftbb(box(1,1):box(1,2), box(2,1):box(2,2), box(3,1):box(3,2)) = 2;
oldrightbb(box(1,3):box(1,4), box(2,3):box(2,4), box(3,3):box(3,4)) = 2;

%plot
figure 
subplot(2,3,1);
imagesc(newInputImage(:,:,119)); % sample layer
title('Input image')

subplot(2,3,2);
imagesc(leftbb(:,:,119));
hold on
j = imagesc(oldleftbb(:,:,119));
set(j,'AlphaData',.5 );
title('Left BB');

subplot(2,3,3);
imagesc(leftbb(:,:,119));
hold on
m = imagesc(oldleftbb(:,:,119));
set(m,'AlphaData',.5 );
axis([min(box(2,1),newBox(2,1))-5 max(box(2,2),newBox(2,2))+5 min(box(1,1),newBox(1,1))-5  max(box(1,2),newBox(1,2))+5]);
title('Left BB closeup');

subplot(2,3,5);
imagesc(rightbb(:,:,119));
hold on
k = imagesc(oldrightbb(:,:,119));
set(k,'AlphaData',.5 );
title('Right BB')

subplot(2,3,6);
imagesc(rightbb(:,:,119));
hold on
n = imagesc(oldrightbb(:,:,119));
set(n,'AlphaData',.5 );
axis([min(box(2,3),newBox(2,3))-5 max(box(2,4),newBox(2,4))+5 min(box(1,3),newBox(1,3))-5  max(box(1,4),newBox(1,4))+5]);
title('Right BB closeup');


toc

end
