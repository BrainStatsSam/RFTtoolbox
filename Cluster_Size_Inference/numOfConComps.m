function [number_of_clusters, occurences, sizes] = numOfConComps(data, thresh, connectivity_criterion)
% NUMOFCONCOMPS(data, thresh, connectivity_criterion) calculates the number
% of connected components in an array that lie above a threshold.
%--------------------------------------------------------------------------
% REQUIRES the image processing toolbox for Matlab, specifically the
% function bwconncomp.m .
%--------------------------------------------------------------------------
% ARGUMENTS
% data      a 2 or 3 dimensional array of real values.
% thresh    a threshold
% connectivity_criterion    To Add!
%--------------------------------------------------------------------------
% OUTPUT
% number_of_clusters    The number of connected components above the
%                       threshold thresh
% occurences
% sizes
%--------------------------------------------------------------------------
% EXAMPLES
% thresh = 1;
% sims = randn(10,10)
% [number_of_clusters, occurences, sizes] = numOfConComps(sims, thresh);
% sims > thresh
% sizes
%--------------------------------------------------------------------------
% AUTHORS: Tom Maullin, Sam Davenport (05/02/2018)
s = size(data);
ones_and_zeros = zeros(s);
D = length(s);
ones_and_zeros(data > thresh) = 1;

%If we're in the 2d case only look at components connected vertically
%and horizontally (i.e. no diagonals!)
if D == 2
    if nargin < 3
        connectivity_criterion = 4;
    end
    if sum(connectivity_criterion == [4,8]) ~= 1
        error('In 2D the connectivity criterion must be 4 or 8')
    end
    conComponents = bwconncomp(ones_and_zeros, connectivity_criterion);
elseif D == 3
    if nargin < 3
        connectivity_criterion = 18;
    end
    if sum(connectivity_criterion == [6,18,26]) ~= 1
        error('In 3D the connectivity criterion must be 6, 18 or 26')
    end
    conComponents = bwconncomp(ones_and_zeros, connectivity_criterion);
else
    error('The dimension must be 2 or 3.');
end

%Return the true number of connected components/clusters.
number_of_clusters = conComponents.NumObjects;

if nargout > 1
    %Get a list of sizes of the clusters.
    sizeArray = cellfun(@(x) numel(x), conComponents.PixelIdxList);
    
    %Get the number of occurences for each cluster size. e.g. occurences(k)
    %is the number of times we observed clusters of size sizes(k).
    [occurences, sizes] = hist(sizeArray, unique(sizeArray));
end

end