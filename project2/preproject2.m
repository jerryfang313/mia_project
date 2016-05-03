leftBoxNames = {'boundingbox\1000901_tightbbox_left.xml';
    'boundingbox\1001701_tightbbox_left.xml';
    'boundingbox\1003101_tightbbox_left.xml';
    'boundingbox\2000101_tightbbox_left.xml';
    'boundingbox\2000301_tightbbox_left.xml';
    'boundingbox\2000501_tightbbox_left.xml';};

rightBoxNames = {'boundingbox\1000901_tightbbox_right.xml';
    'boundingbox\1001701_tightbbox_right.xml';
    'boundingbox\1003101_tightbbox_right.xml';
    'boundingbox\2000101_tightbbox_right.xml';
    'boundingbox\2000301_tightbbox_right.xml';
    'boundingbox\2000501_tightbbox_right.xml';};

brainNames = {'brain\1000901_MPRAGE.xml';
    'brain\1001701_MPRAGE.xml';
    'brain\1003101_MPRAGE.xml';
    'brain\2000101_MPRAGE.xml';
    'brain\2000301_MPRAGE.xml';
    'brain\2000501_MPRAGE.xml';};

numBrains = size(brainNames, 1);
randBrain = floor(rand(1) * numBrains + 1);
origBrains = cell(numBrains, 1);
shrunkBrains = cell(numBrains, 1);
shrinkFactor = 4;
lostRows = zeros(numBrains,1);
lostCols = zeros(numBrains,1);
lostLays = zeros(numBrains,1);
for i = 1:numBrains
    leftBox = ReadXml(leftBoxNames{i});
    leftMinCorner = find(leftBox, 1, 'first');
    leftMaxCorner = find(leftBox, 1, 'last');
    leftMinR;
    leftMinC;
    leftMinL;
    leftMaxR;
    leftMaxC;
    leftMaxL;
    
    rightBox = ReadXml(rightBoxNames{i});
    rightMinCorner = find(rightBox, 1, 'first');
    rightMaxCorner = find(rightBox, 1, 'last');
    rightMinR;
    rightMinC;
    rightMinL;
    rightMaxR;
    rightMaxC;
    rightMaxL;
    
    brain = ReadXml(brainNames{i});
    brain(brain < 0) = 0;
    val = reshape(brain, [], 1, 1);
    if (i == randBrain)
        figure;
        plot(1:100, prctile(val, 1:100));
    end
    brain(brain > prctile(val, 99)) = prctile(val, 99);
    brain = brain/max(max(max(brain))) * 255;
    origBrains{i} = brain;
    [shrunkBrains{i}, lostRows(i), lostCols(i), lostLays(i)] = shrinkImage(brain, shrinkFactor);
end

brain1 = origBrains{1};
brain2 = origBrains{2};
brain3 = origBrains{3};
brain4 = origBrains{4};
brain5 = origBrains{5};
brain6 = origBrains{6};

save('brain1mat.mat', 'brain1');
save('brain2mat.mat', 'brain2');
save('brain3mat.mat', 'brain3');
save('brain4mat.mat', 'brain4');
save('brain5mat.mat', 'brain5');
save('brain6mat.mat', 'brain6');
