% let V be some [row col layer] coordinate in reference image
% The register function returns [scale, tr, tc, tl, SSD] such that 
% [scale 0     0     tr;    Vr           Tr
%  0     scale 0     tc;    Vc     =     Tc
%  0     0     scale tl;    Vl           Tl
%  0     0     0     1;]    1            1
% Where vector T is the [row col layer] coordinate of corresponding pixel
% in otherImage.

function  [scale, tr, tc, tl, SSD] = register(referenceImage, otherImage, initscale, inittr, inittc, inittl)

scale = initscale;
tr = inittr;
tc = inittc;
tl = inittl;
N = numel(referenceImage);
[maxr_other, maxc_other, maxl_other] = size(otherImage);
[numr, numc, numl] = size(referenceImage);

prevC = 0;
for i = 1:numr
    for j = 1:numc
        for k = 1:numl
            prevC = prevC + (referenceImage(i,j,k) - getat(otherImage, scale * [i j k] + [tr tc tl], maxr_other, maxc_other, maxl_other))^2;
        end
    end
end
prevC = prevC / N;

for iter = 1:10
   dCds = 0;
   dCdr = 0;
   dCdc = 0;
   dCdl = 0;
   
   for i = 1:size(referenceImage,1)
       for j = 1:size(referenceImage,2)
           for k = 1:size(referenceImage,3)
               dCds;
               dCdr;
               dCdc;
               dCdl;
               Bt(i,j,k);
           end
       end
   end
end

end

