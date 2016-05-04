% let V be some [row col layer] coordinate in reference image
% The register function returns [scale, tr, tc, tl, SSD] such that 
% [scale 0     0     tr;    Vr           Tr
%  0     scale 0     tc;    Vc     =     Tc
%  0     0     scale tl;    Vl           Tl
%  0     0     0     1;]    1            1
% Where vector T is the [row col layer] coordinate of corresponding pixel
% in otherImage.

function  [scale, tr, tc, tl, SSD] = register(referenceImage, otherImage, initscale, inittr, inittc, inittl)
eta = 1e-20;
scale = initscale;
tr = inittr;
tc = inittc;
tl = inittl;
N = numel(referenceImage);
[max_other] = size(otherImage);
[numr, numc, numl] = size(referenceImage);

prevC = 0;
for i = 1:numr
for j = 1:numc
for k = 1:numl
    transformed = scale*[i j k] + [tr tc tl];
    prevC = prevC + (referenceImage(i,j,k) - getat(otherImage, transformed, max_other))^2;
end
end
end
prevC = prevC / N;

disp(['prevC: ' num2str(prevC)]);
skip = 0;
for iter = 1:5
    if ~skip
        disp('not skip');
        eta = 1e-20;
        dCds = 0;
        dCdr = 0;
        dCdc = 0;
        dCdl = 0;
   
        for i = 1:size(referenceImage,1)
        for j = 1:size(referenceImage,2)
        for k = 1:size(referenceImage,3)
            transformed = scale*[i j k] + [tr tc tl];
            diff = referenceImage(i,j,k) - getat(otherImage, transformed, max_other);
            grad = getgradat(otherImage, transformed, max_other);
            dCds = dCds + -2/N*diff*grad' * [i j k]';
            dCdr = dCdr + -2/N*diff*grad' * [1 0 0]';
            dCdc = dCdc + -2/N*diff*grad' * [0 1 0]';
            dCdl = dCdl + -2/N*diff*grad' * [0 0 1]';
        end
        end
        end
    else
        disp('skip');
    end
   
   disp([num2str(dCds) '  ' num2str(dCdr) '  ' num2str(dCdc) '  ' num2str(dCdl)]);
   newScale = scale - eta*dCds;
   newr = tr - eta*dCdr;
   newc = tc - eta*dCdc;
   newl = tl - eta*dCdl;
   
    tempC = 0;
    for i = 1:numr
    for j = 1:numc
    for k = 1:numl
        transformed = newScale*[i j k] + [newr newc newl];
        tempC = tempC + (referenceImage(i,j,k) - getat(otherImage, transformed, max_other))^2;
    end
    end
    end
    tempC = tempC/N;
    disp(['tempC :' num2str(tempC)]);
    
    if tempC < prevC
        prevC = tempC;
        tr = newr;
        tc = newc;
        tl = newl;
        scale = newScale;
        skip = 0;
    else 
        eta = eta/2;
        skip = 1;
    end
end

SSD = prevC;
end

