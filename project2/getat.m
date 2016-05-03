function [ val ] = getat( image, coords, maxDim)
coords = round(coords);
r = coords(1);
c = coords(2);
l = coords(3);

maxr = maxDim(1);
maxc = maxDim(2);
maxl = maxDim(3);

if r < 1 || r > maxr || c < 1 || c > maxc || l < 1 || l > maxl
    val = 0;
else 
    val = image(r,c,l);
end
end

