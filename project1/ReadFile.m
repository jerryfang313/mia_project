function [output_image_file,infoID,M] = ReadFile(input_image_file, input_calc_file)


% input/output folder designation
input_image_file = strcat('Input/', input_image_file);
input_calc_file = strcat('Input/', input_calc_file);

fid = fopen(input_calc_file);
tline = fgets(fid);
InfoID = [];
InfoX = [];
InfoY = [];
InfoR = [];

while ischar(tline)
    Info = strsplit(tline);
    InfoID = [InfoID; Info(1)];
    Info_coord = str2double(Info);
    InfoX = [InfoX; Info_coord(2)];
    InfoY = [InfoY; Info_coord(3)];
    InfoR = [InfoR; Info_coord(4)];
    tline = fgets(fid);
end


% Instead of remapping origin to bottom left, we can transform input to
% match with the image index?
% For example: in a 8 by 6 matrix. input (4,2) is [6,5] in matrix. In
% genreal, (x,y) is [size(I)-y x+1] 

infoID = infoID;
M = [InfoX InfoY InfoR];
output_image_file = imread(input_image_file);




