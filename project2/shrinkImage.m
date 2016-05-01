function [ shrunk , lostRows, lostCols, lostLays] = shrinkImage( inputImage, shrinkFactor )
origRows = size(inputImage,1);
origCols = size(inputImage,2);
origLays = size(inputImage,3);

lostRows = mod(origRows, shrinkFactor);
lostCols = mod(origCols, shrinkFactor);
lostLays = mod(origLays, shrinkFactor);

shrunk = zeros(floor(size(inputImage)/shrinkFactor));
for i = 1:size(shrunk,1)
    for j = 1:size(shrunk,2)
        for k = 1:size(shrunk, 3)
            beginRow = (i-1) * shrinkFactor + 1;
            beginCol = (j-1) * shrinkFactor + 1;
            beginLay = (k-1) * shrinkFactor + 1;
            endRow = i * shrinkFactor;
            endCol = j * shrinkFactor;
            endLay = k * srhinkFactor;
            shrunk(i,j,k) = mean(mean(mean(inputImage(beginRow:endRow, beginCol:endCol, beginLay:endLay))));
        end
    end
end

end

