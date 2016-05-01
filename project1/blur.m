% Program desctipion
% Add mask to the image. The mask is chosen to smooth the image after the
% enhancement with histogram equalization
function [outImage] = blur(inImage)

  mask = [1/8 1/8 1/8;1/8 0 1/8; 1/8 1/8 1/8];
  outImage = conv2(inImage,mask,'same');
end