function [ val ] = getat( image, coords, maxr, maxc, maxl)
coords = round(coords);
r = coords(1);
c = coords(2);
l = coords(3);

if r < 1 || r > maxr || c < 1 || c > maxc || l < 1 || l > maxl
    val = 0;
else 
    val = image(r,c,l);
end
end

