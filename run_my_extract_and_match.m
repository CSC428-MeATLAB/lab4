I1 = rgb2gray(imread('bikes1.ppm'));
I2 = rgb2gray(imread('bikes2.ppm'));

% Points are col vectors, found using SURF
points1 = get_key_points(I1);
points2 = get_key_points(I2);

% f1, f2 are col vectors of feature pts
f1 = my_extract_features_a(I1, points1);
f2 = my_extract_features_a(I2, points2);

% indexpairs is row vectors of matched indicies into points1 and points2
indexPairs = myMatchFeatures(f1, f2, .4);
indexPairs = indexPairs( ~isnan(indexPairs(:,2)), : );

% Convert indecies to row vectors of matched pts
matchedPoints1 = points1(:,indexPairs(1:end, 1))';
matchedPoints2 = points2(:,indexPairs(1:end, 2))';

% Plot matched points
figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');