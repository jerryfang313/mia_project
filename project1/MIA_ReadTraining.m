% function MIA_ReadTraining
% Arguments:
% infoPath: string with full path name to the calc_info.txt file
% imageDir: string containing full path to directory with image files
%           Note: must have terminal '/' character
%
% Return:
% calc_specs: Cx4 array for C calcifications
%             Column 1 is image index (starting at 1)
%             Column 2 is x coordinate of calc
%             Column 3 is y coordinate of calc
%             Column 4 is radius of calc
% names:  an 1xI cell array of string names correspoding to the filename
%         of each image
% images: 1xIx cell array of I images

function [calc_specs, images, names] = MIA_ReadTraining(infoPath, imageDir)
    FID = fopen(infoPath);
    C = textscan(FID, 'Filename Ab x y radius');
    C = textscan(FID, '%s %d %d %d');
    X = C{2};
    Y = C{3};
    R = C{4};
    fclose(FID); 
    
    oldPath = '';
    imageNum = 0;
    calc_specs = zeros(size(C{1},1), 4);
    
    for i = 1:size(C{1}, 1)
        newPath = [imageDir C{1}{i} '.pgm'];
        if ~strcmp(oldPath, newPath)
            imageNum = imageNum + 1;
            oldPath = newPath;
            names{imageNum} = C{1}{i};
            temp = imread(newPath);
            for j = 1:512
                if mean(temp(:,j)) - mean(temp(:,1025-j)) > 20
                    images{imageNum} = temp;
                    break;
                else if mean(temp(:,j)) - mean(temp(:,1025-j)) < -20
                    images{imageNum} = fliplr(temp);
                    break;
                end
            end
        end
        calc_specs(i,:) = [imageNum X(i) Y(i) R(i)];
    end
    
end
