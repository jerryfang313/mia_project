% let V be some [row col layer] coordinate in reference image
% The register function returns [scale, tr, tc, tl, SSD] such that 
% [scale 0     0     tr;    Vr           Tr
%  0     scale 0     tc;    Vc     =     Tc
%  0     0     scale tl;    Vl           Tl
%  0     0     0     1;]    1            1
% Where vector T is the [row col layer] coordinate of corresponding pixel
% in otherImage.

function  [scale, tr, tc, tl, SSD] = register(referenceImage, otherImage, initscale, inittr, inittc, inittl)


end

