function [R_Mask, B_Mask, numToCheck, toCheck] = MIA_CheckPoint(inImage, pt, numToCheck, toCheck, R_Mask, B_Mask, lower, upper)

pt_row = pt(1);
pt_col = pt(2);

mask = [true, true, true;
        true, 0, true;
        true, true, true];

if ptInImage(pt_row, pt_col, size(inImage)) && ~R_Mask(pt_row, pt_col)

    if withinRange(inImage(pt_row, pt_col), lower, upper)
        %display('in range')
        R_Mask(pt_row, pt_col) = true;
        
        %{
        if inImage(pt_row, pt_col) == seed
           equalSeeds = [equalSeeds; pt_row, pt_col]; 
        end
        %}
        
        for i = 1:3
            for j = 1:3               
                if mask(i,j)
                    %display('adding');
                    imageRow = (pt_row - 2) + i;
                    imageCol = (pt_col - 2) + j;
                    numToCheck = numToCheck + 1;
                    toCheck(numToCheck,:) = [imageRow, imageCol];
                end
            end
        end
    else
        B_Mask(pt_row, pt_col) = true;
    end
end
       
end

function validIndex = ptInImage(row, col, imageSize)

validIndex = (row > 0) && (row <= imageSize(1)) && (col > 0) && (col <= imageSize(2));

end

function inRegion = withinRange(intensity, lower, upper)

inRegion = (lower <= intensity) && (intensity <= upper);

end