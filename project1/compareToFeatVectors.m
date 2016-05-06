function distances = compareToFeatVectors(feature, trainingFeatures)
numFeatVectors = size(trainingFeatures, 2);
distances = zeros(1, numFeatVectors);


for i = 1:size(trainingFeatures, 2)

    diff = feature - trainingFeatures(:,i);
    
    distances(i) = sum(diff .* diff);
    
end

end

