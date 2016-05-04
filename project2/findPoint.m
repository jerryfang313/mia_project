% Find and extracts points on the brain to be used for registration 
% Takes four points (endpoints of minor and major axis) in each layer
%
% Input: matrix of the test image get from ReadXml
% Output: 3xn matrix. Row is [x y z]' and column is individual points

function [output] = findPoint(image)
rangeX = zeros(size(image,3),1);
rangeY= zeros(size(image,3),1);

%looping through each layer
for i = 60:size(image,3)-60 %discard first 60 and last 30 layers
    x = image(:,:,i); %extract 2D info from each layer
    %     y(y<0.00001) = 2;
    if max(max(x)) == 0 %skip if all elements of a layer are 0
        continue;
    else
        x(x<mean(mean(x)))=0; %set threshold
        c = find(x);
        rx = floor(max(c)/size(x,2))-floor(min(c)/size(x,2));
        rangeX(i) = rx;
        xrotate = imrotate(x,90); %rotate image by 90 degree
        d = find(xrotate);
        ry = floor(max(d)/size(x,1))-floor(min(d)/size(x,1));
        rangeY(i) = ry;
    end
end

% find the layer with largest brain length
x = max(rangeX); % magnitude of length
xindex = find(rangeX==x); %layers
xmed = floor(median(xindex)); % take the meadian of the layers

% find the layer with largest brain width
% y = max(rangeY); % madnitude of width
% yindex = find(rangeY==y);
% ymed = floor(median(yindex));
% layer = [x y xmed ymed];

%set a range of layer around the center
layer_min = ceil((xmed-40)/2)*2;
layer_max = ceil((xmed+40)/2)*2;

% sample every other two layers
range = layer_min:1:layer_max;

% extract points from layers to be used for registration
for j = 1:size(range,2)
    b = image(:,:,range(j));
    b(b<mean(mean(b)))=0; %set threshold
    
    c = find(b);
    x1 = floor(min(c)/size(image,1)); %get point 1
    y1 = floor(min(c)/size(image,2));
    x2 = floor(max(c)/size(image,1)); %get point 2
    y2 = floor(max(c)/size(image,2));
    
    brotate = imrotate(b,90); %rotate image by 90 degree
    d = find(brotate);
    
    x3 = floor(min(d)/size(image,1)); %get point 3
    y3 = floor(min(d)/size(image,2));
    x4 = floor(max(d)/size(image,1)); %get point 4
    y4 = floor(max(d)/size(image,2));
    
    A(j,:) = [x1 y1 x2 y2 x3 y3 x4 y4 range(j)];
end

%reformat A to 3xn matrix to be used in registration script
for m = 1:size(A,1)
    %x1,y1,range
    output(1,4*m-3) = A(m,1);
    output(2,4*m-3) = A(m,2);
    output(3,4*m-3) = A(m,9);
    %x2,y2,range
    output(1,4*m-2) = A(m,3);
    output(2,4*m-2) = A(m,4);
    output(3,4*m-2) = A(m,9);
    %x3,y3,range
    output(1,4*m-1) = A(m,5);
    output(2,4*m-1) = A(m,6);
    output(3,4*m-1) = A(m,9);
    %x4,y4,range
    output(1,4*m) = A(m,7);
    output(2,4*m) = A(m,8);
    output(3,4*m) = A(m,9);
    
end

end
