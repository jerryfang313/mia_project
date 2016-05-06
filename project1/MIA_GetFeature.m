% [outVector] = MIA_GetFeature(inImage, R_Mask, B_Mask);
% Args:	inImage: an MxN input image
% 		R_Mask: an MxN mask image for the region, as output from MIA_Grow above
% 		B_Mask: an MxN mask image for the boundary, as output from MIA_Grow above
% 
% Out:  outVector: a Vx1 vector describing V features of the region/boundary

function [outVector] = MIA_GetFeature(inImage, R_Mask, B_Mask)
    numFeatures = 17;
    outVector = zeros(numFeatures, 1);
    
    index = 1;
    region = inImage(R_Mask == 1);
    background = inImage(B_Mask == 1);
    min_col = floor(find(R_Mask, 1)/size(inImage,1)) + 1;
    max_col = floor(find(R_Mask, 1, 'last')/size(inImage,1)) + 1;
    min_row = floor(find(R_Mask', 1)/size(inImage,2)) + 1;
    max_row = floor(find(R_Mask', 1, 'last')/size(inImage,2)) + 1;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Mean intensity of region
    region_mean = mean(region);
    outVector(index) = region_mean;
    index = index + 1;
    
    % Max intensity of region
    region_max = max(region);
    outVector(index) = region_max;
    index = index + 1;

    % Min intensity of region
    region_min = min(region);
    outVector(index) = region_min;
    index = index + 1;
    
    % Range intensity of region
    region_range = region_max - region_min;
    outVector(index) = region_range;
    index = index + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Mean intensity of background
    background_mean = mean(background);
    outVector(index) = background_mean;
    index = index + 1;
    
    % Max intensity of background
    background_max = max(background);
    outVector(index) = background_max;
    index = index + 1;

    % Min intensity of background
    background_min = min(background);
    outVector(index) = background_min;
    index = index + 1;
    
    % Intensity range of background
    background_range = background_max - background_min;
    outVector(index) = background_range;
    index = index + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Region contrast
    if (region_mean + background_mean) ~= 0
        contrast = (region_mean - background_mean) / (region_mean + background_mean);
    else
        contrast = 0;
    end
    outVector(index) = contrast;
    index = index + 1;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Region area
    region_area = sum(sum(R_Mask));
    outVector(index) = region_area;
    index = index + 1;
    
    % Region width
    region_width = max_col - min_col + 1;
    outVector(index) = region_width;
    index = index + 1;
    
    % Region height
    region_height = max_row - min_row + 1;
    outVector(index) = region_height;
    index = index + 1;
    
    % Normalized row position
    mean_row = max_row - min_row;
    norm_mean_row = mean_row/size(inImage,1);
    outVector(index) = norm_mean_row;
    index = index + 1;
    
    % Normalized col position
    mean_col = max_col - min_col;
    norm_mean_col = mean_col/size(inImage,2);
    outVector(index) = norm_mean_col;
    index = index + 1;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

    % Compactness
    compactness = 1 - 4 * pi * region_area / sum(sum(B_Mask));
    outVector(index) = compactness;
    index = index + 1;
    
    % Centroid
    sumX = 0;
    sumY = 0;
    for i = 1:size(inImage,1)
        for j =1:size(inImage,2)
            if R_Mask(i,j)
                sumX = sumX + i;
                sumY = sumY + j;
            end
        end
    end
    centroidX = sumX / double(region_area);
    centroidY = sumY / double(region_area);
    outVector(index) = centroidX;
    index = index + 1;
    outVector(index) = centroidY;
    index = index + 1;
    
end
