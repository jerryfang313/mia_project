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
for i = 1:numBrains
    leftBox = ReadXml(leftBoxNames{i});
    rightBox = ReadXml(rightBoxNames{i});
    
    brain = ReadXml(brainNames{i});
end
