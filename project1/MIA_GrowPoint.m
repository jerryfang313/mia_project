% Function description
% Recursively grow a region around a point with provided indices in an
% image
%
% Inputs:
% inImage the MxN image that constains the point
% pt 1x2 matrix constaining the x and y coordinates of the point to grow an
% image from
% R_Mask the MxN binary image that represents the region grow at any given
% moment
% B_Mask the MxN binary image that represents the boundary of the region
% lowerBound the lowest intensity value still regarded as being in the
% region
% upperBound the highest intensity value still regarded as being in the
% region

function [R_Mask, B_Mask] = MIA_GrowPoint(inImage, pt, R_Mask, B_Mask, lowerBound, upperBound)

pt_x = pt(1);
pt_y = pt(2);

R_Mask(pt_x, pt_y) = true;

% Loop through rows
for i = 1:3
    
    % Loop through columns
    for j = 1:3
        
        % Calculate index relative to current point
        newPt_x = pt_x + (i - 2);
        newPt_y = pt_y + (j - 2);
        
        % Confirm new index is in the image
        if ptInImage(newPt_x, newPt_y, size(inImage)) && ~R_Mask(newPt_x, newPt_y)
            
            % Compare intensity to bounds
            if (lowerBound <= inImage(newPt_x, newPt_y)) && (inImage(newPt_x, newPt_y) <= upperBound)
                
                % Do not recall function on self
                % TODO: there may be way to avoid this conditional
                if (i ~= 2 || j~= 2)
                    [R_Mask, B_Mask] = MIA_GrowPoint(inImage, [newPt_x, newPt_y], R_Mask, B_Mask, lowerBound, upperBound);
                end
            else
                B_Mask(newPt_x, newPt_y) = true;
            end
        end
    end
end

end

function validIndex = ptInImage(newPt_x, newPt_y, sizeImage)

validIndex = (newPt_x > 0) && (newPt_x <= sizeImage(1)) && (newPt_y > 0) && (newPt_y <= sizeImage(2));

end