I1 = rgb2gray(imread('cars1.ppm'));
I2 = rgb2gray(imread('cars2.ppm'));

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

% Their version
indexPairs = matchFeatures(f1, f2)

% My garbage code
f1 = f1.Features(1:end,:); %row vecs
f2 = f2.Features(1:end,:); %row vecs
indexPairs = myMatchFeatures(f1, f2, .4)'
indexPairs = indexPairs( ~isnan(indexPairs(:,2)), : )

matchedPoints1 = vpts1(indexPairs(1:end, 1));
matchedPoints2 = vpts2(indexPairs(1:end, 2));

figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');