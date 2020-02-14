

%f1 and f2 contain feature col vectors
function [matches] = myMatchFeatures(f1, f2, threshold)
    
    %convert to row vectors
    f1=f1';
    f2=f2';
    
    %array matching indecides in f1 to indecies in f2
    matches = [[1:size(f1,1)];-1*ones(1,size(f1,1))];
    
    for i=1:size(f1,1)
        %initialize array to hold distances
        iMatches = cast([-1*ones(size(f2,1),1) [1:size(f2,1)]'], 'double');
        
        %record distance between f1(i) and f2(j) for each j
        for j=1:size(f2,1)
            iMatches(j,1) = sqEucDist(f1(i,:),f2(j,:));
        end
        
        % get the distance ratio of closest and second closest points
        sorted = sortrows(iMatches);
        ratio = sorted(1,1) / sorted(2,1);
        
        % if the ratio is below a threshold, include it
        if ratio < threshold
            matches(2,i) = sorted(1,2);
        else
            matches(2,i) = "NULL";
        end    
    end
    
    matches = matches';
end

function [d] = sqEucDist(v1, v2)
    t = int64(v1)-int64(v2);
    t = t.*t;
    d = sum(t);
end