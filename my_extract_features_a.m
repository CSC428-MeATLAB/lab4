function [extracted_features] = my_extract_features_a(image, detected_pts)
    padded_image = padarray(image, [2 2], 0, 'both');
    extracted_features = zeros(25, size(detected_pts, 2));
    for i = 1:size(detected_pts, 2)
        y = floor(detected_pts(1, i)) + 2;
        x = floor(detected_pts(2, i)) + 2;
        descriptor = reshape(padded_image(x-2:x+2, y-2:y+2), [25 1]);
        extracted_features(1:25, i) = descriptor;
    end
end