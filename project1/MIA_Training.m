% get path to truth file
waitfor(msgbox(['Please select ', 'calc_info_update.txt', ':']));
pause(0.25);
[FILE, PATH] = uigetfile('*', 'calc_info_update.txt');
calc_info_fullpath = [PATH FILE];
disp(['Opened ' 'calc_info.txt'])

% get path to calcification image directory
waitfor(msgbox(['Please select ', 'calcification image directory', ':']));
pause(0.25);
calc_image_dir = uigetdir('*', 'calcification image directory');
disp(['Opened ' 'calcification image directory'])

[calc_specs, images, names] = MIA_ReadTraining(calc_info_fullpath, [calc_image_dir '\']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure;
% subplot(4, 3, 1);
% for i = 1:11
%     subplot(4,3,i);
%     colormap('gray');
%     imagesc(images{i});
%     axis equal;
% end

rnum = floor(rand(1) * max(size(images)) +1)

figure;
colormap('gray');
imagesc(images{rnum});
axis equal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

histEqImages = cell(size(images));
for i = 1:11
    histEqImages{i} = myHistEq(images{i}, 0.05);
end

figure;
colormap('gray');
imagesc(histEqImages{rnum});
axis equal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure;
% subplot(4, 3, 1);
blurredImages = cell(size(images));
for i = 1:11
%     subplot(4,3,i);
%     colormap('gray');
    blurredImages{i} = blur(histEqImages{i});
    % colormap('gray');
    %imagesc(blurredImages{i});
    %axis equal;
end


figure;
colormap('gray');
imagesc(blurredImages{rnum});
axis equal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numFeatures = 17;
featVectors = NaN(numFeatures, size(calc_specs,1));

circledImages = cell(max(size(calc_specs)), 1);
allRMasks = cell(size(circledImages));
allBMasks = cell(size(circledImages));
figure;
subplot(4,4,1);
for i = 1:size(calc_specs, 1)
    circledImages{i} = imread([PATH names{calc_specs(i,1)} '_g.pgm']);
    cI = circledImages{i};
        
    im = blurredImages{calc_specs(i,1)};
    seed_row = calc_specs(i,3) + 1;
    seed_col = calc_specs(i,2) + 1;
    seed = [seed_row, seed_col];
    threshold = 1;

    [R_Mask, B_Mask] = MIA_Grow(im, seed, threshold);
    allRMasks{i} = R_Mask;
    allBMasks{i} = B_Mask;

    featVectors(:,i) = MIA_GetFeature(im, R_Mask, B_Mask);
    
    subplot(4,4,i);
    colormap('gray');
    cI(logical(R_Mask)) = 255;
    cI(logical(B_Mask)) = 0;
    imagesc(cI(seed_row-50:seed_row+50, seed_col-50:seed_col+50)); 
    axis equal;
end
normCoeffs = max(featVectors,[],2);
normFeatVectors = featVectors./repmat(normCoeffs,1,size(calc_specs,1));

save('training_results.mat', 'normCoeffs', 'normFeatVectors', 'calc_specs', 'images', 'histEqImages', 'blurredImages', 'allRMasks', 'allBMasks');