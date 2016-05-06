function [ x, y, r, labelmask ] = mcDetect( newInputImage )

%%%%% NOTES %%%%%
% 1) newInputImage must be read into Matlab with imread(), not getim()
% 2) Necessary files:
%       blur.m
%       compareToFeatVectors.m
%       MIA_CheckPoint.m
%       MIA_GetFeature.m
%       MIA_Grow.m
%       myHistEq.m
%       returnCalcification.m
%       training_results.mat
%       xy2rc.m

[x, y, r, labelmask] = returnCalcification(newInputImage);

end

