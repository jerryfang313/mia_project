% get path to truth file
waitfor(msgbox(['Please select ', 'calc_info.txt', ':']));
pause(0.25);
[FILE, PATH] = uigetfile('*', 'calc_info.txt');
calc_info_fullpath = [PATH FILE];
disp(['Opened ' 'calc_info.txt'])

% get path to calcification image directory
waitfor(msgbox(['Please select ', 'calcification image directory', ':']));
pause(0.25);
calc_image_dir = uigetdir('*', 'calcification image directory');
disp(['Opened ' 'calcification image directory'])

[calc_specs, images, names] = MIA_ReadTraining(calc_info_fullpath, [calc_image_dir '\']);

figure;
subplot(4, 3, 1);
for i = 1:11
    subplot(4,3,i);
    colormap('gray');
    imagesc(images{i});
    axis equal;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



numFeatures = 14;
featVectors = zeros(numFeatures, size(calc_specs,1));

for i = 4:size(calc_specs, 1)
    im = images{calc_specs(i,1)};
    [seed_row, seed_col] = xy2rc(im, calc_specs(i,2), calc_specs(i,3));
    seed = [seed_row, seed_col];
    threshold = 1;
    constrain = 0;
    param = '';
    thickness = 1;
        
    [R_Mask, B_Mask] = MIA_Grow(im, seed, threshold, constrain, param, thickness);

    featVectors(:,i) = MIA_GetFeature(im, R_Mask, B_Mask);
end
featVectors
normCoeffs = max(featVectors,[],2);
normFeatVectors = featVectors./repmat(normCoeffs,1,size(calc_specs,1));



