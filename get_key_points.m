function [key_points] = get_key_points(image)
    surf_points = detectSURFFeatures(image);
    key_points = zeros(2, surf_points.Count);
    for i = 1:surf_points.Count
        key_points(1:2, i) = surf_points(i).Location;
    end
end