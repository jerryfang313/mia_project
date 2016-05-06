function [range, xindex, yindex] = findCenter(image)
rangeX = zeros(size(image,3),1);
rangeY= zeros(size(image,3),1);

%looping through each layer
for i = 60:size(image,3)-30
     x = image(:,:,i); %extract 2D info from each layer
%     y(y<0.00001) = 2;
    if max(max(x)) == 0 %skip if all elements of a layer are 0
        continue;
    else
        x(x<mean(mean(x)))=0; %set threshold
        c = find(x);
        rx = floor(max(c)/size(image,1))-floor(min(c)/size(image,1));
        rangeX(i) = rx;
        xrotate = imrotate(x,90); %rotate image by 90 degree
        d = find(xrotate);
        ry = floor(max(d)/size(image,2))-floor(min(d)/size(image,2));
        rangeY(i) = ry;
    end
end
     
    x = max(rangeX);
    xindex = find(rangeX==x);
    y = max(rangeY);
    yindex = find(rangeY==y);
    layer = max(x,y);
    range = [x y layer];
    
    
end
