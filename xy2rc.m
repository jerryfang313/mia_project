% xy2rc converts the coordinates of a pixel from x,y to r,c format.
% i.e. the bottom left pixel in an image is defined as pixel (0,0) in
% xy-coordinates
%
% Input:
% I: input image matrix
% x: x coordinate of pixel
% y: y coordinate of pixel
%
% Output:
% r: the row coordinate of pixel
% c: the column coordinate of pixel

function [r, c] = xy2rc(I, x, y)
    x = floor(x);
    y = floor(y);
    rows = size(I, 1);
    cols = size(I, 2);
    c = x + 1;
    r = cols - y;
    if c > cols
        c = cols;
    end
    if c < 1
        c = 1;
    end
    if r > rows
        r = rows;
    end
    if r < 1
        r = 1;
    end
end