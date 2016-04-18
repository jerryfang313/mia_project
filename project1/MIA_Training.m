


[calc_specs, images, names] = MIA_ReadTraining('truth/calc_info.txt', 'calcification/');

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



