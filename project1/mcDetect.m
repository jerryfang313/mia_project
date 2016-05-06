% newInputImage is the matrix obtained by calling the function imread on the new test
% image path
function [ x, y, r, labelmask ] = mcDetect( newInputImage )

[x, y, r, labelmask] = returnCalcification(newInputImage);

end

