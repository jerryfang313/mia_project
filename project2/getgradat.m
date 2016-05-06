function [ grad ] = getgradat( image, coords, maxDim )
coords = round(coords);
r = coords(1);
c = coords(2);
l = coords(3);

grad = 1   * [  getat(image, [r+1, c, l], maxDim) - getat(image, [r, c, l], maxDim);
                getat(image, [r, c+1, l], maxDim) - getat(image, [r, c, l], maxDim);
                getat(image, [r, c, l+1], maxDim) - getat(image, [r, c, l], maxDim)];
end

