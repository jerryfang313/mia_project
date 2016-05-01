% input_XYZ and output_XYZ are 3xN matrix of coordinates


function [ output_XYZ ] = transformXYZ(input_XYZ, scale_factor, thetaX, thetaY, thetaZ )
Rz = [cos(thetaZ) -sin(thetaZ) 0; 
    sin(thetaZ) cos(thetaZ) 0; 
    0 0 1];
Ry = [cos(thetaY) 0 sin(thetaY);
    0 1 0;
    -sin(thetaY) 0 cos(thetaY)];
Rx = [1 0 0;
    0 cos(thetaX) -sin(thetaX);
    0 sin(thetaX) cos(thetaX)];
output_XYZ = scale_factor * Rz * Ry * Rx * input_XYZ;
end

