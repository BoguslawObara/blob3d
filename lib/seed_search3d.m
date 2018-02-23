function b = seed_search3d(im,ns,t)
%% seed_search3d - finding seeds
%
%   INPUT:
%       im      - LoG of blob channel
%       s       - blob size
%       t       - lowest intensity bound
%
%   OUTPUT:
%       b       - detected blob positions
%
%   AUTHOR:
%       Boguslaw Obara

%% regional max
% cube is 10 times faster - Matlab converts it into 1D line elements
% se = ones(2*ns+1);

% ellipsoid
ns = round(ns);
[xg,yg,zg] = meshgrid(-ns(1):ns(1),-ns(2):ns(2),-ns(3):ns(3));
se = ( (xg/ns(1)).^2 + (yg/ns(2)).^2 + (zg/ns(3)).^2 ) <= 1;

immax = imdilate(im,se);

idx = find(im==immax);
idx(im(idx)<t) = [];

[xc,yc,zc] = ind2sub(size(im),idx);
b = [xc yc zc];    

[~,idxs] = sort(im(idx),'descend');
b = b(idxs,:);    
b(:,4) = (1:size(b,1))';

end