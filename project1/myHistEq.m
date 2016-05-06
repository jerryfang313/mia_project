% myHistEq takes in an image. The bottom 'thresh' percentile of pixels 
% are set to intensity 0. The remaining pixels are histogram equalized.
% Output intensities are decimals between [0, 255].
%
% Inputs:
% I: an image matrix
% thresh: the percentile of pixels (expressed as a fractional decimal)
% below which all intensities are rounded to zero, and above which all
% intensities are equalized.

function O = myHistEq(I, thresh)
    Imax = max(max(I));
    Imin = min(min(I));
    %disp(['Original had ' num2str(sum(sum(I == 0))) ' zeros']);
    aboveThresh = I(I >= Imin + thresh*(Imax-Imin));
    pdf = histc(aboveThresh, (0:256)'); 
    cdf = cumsum(pdf);
%     map = floor(255.0/double(cdf(end))*cdf);
    map = 255.0/double(cdf(end))*cdf;
    O = zeros(size(I));
    for r = 1:size(I,1)
        for c = 1:size(I,2)
            if I(r,c) >= Imin + thresh*(Imax-Imin)
                O(r,c) = map(I(r,c) + 1);
            end
        end
    end
    %disp(['Corrected has ' num2str(sum(sum(O == 0))) 'zeros']);
end