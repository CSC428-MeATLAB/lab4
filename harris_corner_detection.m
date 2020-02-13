% Algorithm parameters
hsize = 9;
sigma = 2;
alpha = 0.06;
thresh = 0.2;

% Read in Image
img = checkerboard();
%img = imread('bikes1.ppm');
%img = rgb2gray(img);
% Display Original Image
figure;
imshow(img);

% Create the filters needed for the Harris algorithm
gauss = fspecial('gaussian',hsize,sigma);
Sx = fspecial('prewitt');
Sy = rot90(Sx);

% Apply the x and y gradient filter to the image
Ix = imfilter(img, Sx);
Iy = imfilter(img, Sy);

% Preallocate arrays
corners = zeros(size(Ix,1), size(Ix, 2));
MIx = zeros(size(Ix,1), size(Ix, 2));
MIxy = zeros(size(Ix,1), size(Ix, 2));
MIy = zeros(size(Ix,1), size(Ix, 2));

% Calculate the values in the second moment Matrix
for row=1:size(Ix,1)
    for col=1:size(Ix, 2)
        MIx(row, col) = Ix(row, col).* Ix(row, col);
        MIxy(row, col) = Ix(row, col).* Iy(row, col);
        MIy(row, col) = Iy(row, col).* Iy(row, col); 
    end
end

% Filter each value using the gaussian filter
filtered_MIx = imfilter(MIx, gauss);
filtered_MIxy = imfilter(MIxy, gauss);
filtered_MIy = imfilter(MIy, gauss);

% Prealocate the second moment matrix
M = zeros(2,2);

% Form the second matrix for each pixel in the image and Calculating 
% the Harris corner response function for each pixel
for row=1:size(filtered_MIx,1)
    for col=1:size(filtered_MIx, 2)
        M(1,1) = filtered_MIx(row, col).* filtered_MIx(row, col);
        M(1,2) = filtered_MIxy(row, col).* filtered_MIxy(row, col);
        M(2,1) = M(1,2);
        M(2,2) = filtered_MIy(row, col).* filtered_MIy(row, col);
        deta = det(M);
        tracea = trace(M);
        corners(row, col) = deta - alpha.*tracea.*tracea;
    end
end

% Preallocate array
thresh_corners = zeros(size(corners,1), size(corners, 2));

% Threshold values in the array to determine the corner points from the 
% Harris corner response function
for row=3:(size(corners,1)-3)
    for col=3:(size(corners, 2)-3)
        if corners(row, col) > thresh
            thresh_corners(row,col) = corners(row, col);
        end
    end
end

% Find Local Maximum
max_thresh = imregionalmax(thresh_corners);

% Convert original image to RGB
rgb_img = uint8(255 * mat2gray(img));
rgb_img = cat(3, rgb_img, rgb_img, rgb_img);

% Color the original image with the detected corners
for row=1:(size(corners, 1))
    for col=1:(size(corners, 2))
        if max_thresh(row, col) > thresh
            rgb_img(row, col, :) = [255, 0, 0];
        end
    end
end

% Display the image with detected corners
figure;
imshow(rgb_img);