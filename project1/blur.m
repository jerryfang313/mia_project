% Program desctipion
% Add mask to the image. The mask is chosen to smooth the image after the
% enhancement with histogram equalization
function [outImage] = blur(inImage)

  mask = repmat(1/9, 3, 3);
  outImage = conv2(inImage,mask,'same');
end