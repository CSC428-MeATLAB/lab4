function [extracted_features] = my_extract_features_b(image, detected_pts)
    Sx = fspecial('sobel');
    Sy = Sx';
    Gx = imfilter(cast(image, 'double'), Sx);
    Gy = imfilter(cast(image, 'double'), Sy);
    magnitudes = (Gx.^2 + Gy.^2).^0.5;
    orientations = wrapTo2Pi(atan2(Gy, Gx));
    
    padded_magnitudes = padarray(magnitudes, [8 8], 0, 'both');
    padded_orientations = padarray(orientations, [8 8], 0, 'both');
    
    extracted_features = [];
    for pt = detected_pts
        x = floor(pt(2) + 8);
        y = floor(pt(1) + 8);
        window_magnitudes = padded_magnitudes(x-8:x+8, y-8:y+8);
        window_orientations = padded_orientations(x-8:x+8, y-8:y+8);
        descriptor = [];
        for i = 1:4:16
            for j = 1:4:16
                cell_magnitudes = reshape(window_magnitudes(i:i+3, j:j+3), [16 1]);
                cell_orientations = reshape(window_orientations(i:i+3, j:j+3), [16 1]);
                
                histogram = zeros(8, 1);
                for cell = 1:16
                    magnitude = cell_magnitudes(cell);
                    orientation = cell_orientations(cell);
                    bin = floor(orientation / (pi / 4)) + 1;
                    histogram(bin) = histogram(bin) + magnitude;
                end
                descriptor = [descriptor; histogram];
            end
        end
        extracted_features = [extracted_features descriptor];
    end
    
end