%Compute the SSD cost of the intensity between two images to evulate the
%registration process
%Input: matrices of image 1 and image 2 
% Output: SSD cost value

function [cost] = SSDCost(img1,img2)

I_final = img2 - img1;
cost = sum(sum(sum(I_final.^2)));
cost = sqrt(cost);

end