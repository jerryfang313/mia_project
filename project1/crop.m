% Function description
% Crops the black strips of the image. In terms of matrix representation of
% the image, a column is to be discarded if zero (black pixel) appears more
% than (threshold)% of time in that column.

% Note: inpoints from txt file. outpoint new coordinate in outpoints file
% for inpoints. remove the word but keep it number id. use it to identify
% which row

% Inputs
% inImage: input image, mxn image matrix
% inPoints: Px2 matrix of P points’ x-y coordinates in the inImage 
%     (i.e. bottom left is origin)
% int_threshold: intensity threshold value. Any value before this is set to 0.
% threshold: occurance of 0 in a given column. If the occurance is greater 
%     than this value, discard the column.
% 
% Outputs
% outImage: output image
% outPoints: corrosponding x-y coordinates of each points from inImage.

function [outImage, outPoints] = crop(inImage, inPoints, int_threshold, threshold)

outImage = inImage;
delete_count_left = 0; % counter for deleted column on the left side
delete_count_right = 0; % counter for deleted column on the right side

% cropping from the left side
while 1
    x_left = outImage(:,1);
    
    % if a pixel is below certain intensity, assume it's black and set the value to zero
    x_left(x_left<int_threshold) = 0;
    
    % sum up occurance of the number 0
    countL = 0;
    for j_left = 1:size(x_left,1)
        if x_left(j_left) == 0
            countL = countL + 1;
        end
    end
    
    % determine if 0 appears more than set threshold
    z = countL/size(x_left,1);
    
    if z > threshold
        outImage(:,1)=[];
    else
        break;
    end
    delete_count_left = delete_count_left+1;
end

% cropping from the right side
while 1
    x_right = OutImage(:,size(OutImage,2));
    x_right(x_right<int_threshold) = 0;
    
    countR = 0;
    for j_right = 1:size(x_right,1)
        if x_right(j_right) == 0
            countR = countR+1;
        end
    end
    
    z_right = countR/size(x_right,1);
    
    if z_right > threshold
        OutImage(:,size(OutImage,2))=[];
    else
        break;
    end
    delete_count_right = delete_count_right+1;
end


