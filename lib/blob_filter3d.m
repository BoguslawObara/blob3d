function imlog = blob_filter3d(im,s)
%% blob_filter3d - enhances 3D blob-like structures
%
%   INPUT:
%       im      - image
%       s       - sigma = [sigmax sigmay sigmaz]
%
%   OUTPUT:
%       imlog   - enhanced output image
%
%   AUTHOR:
%       Boguslaw Obara

%% 3D LoG
s = round(s);
[logx1,logx2] = log_filter1d(s(1));
[logy1,logy2] = log_filter1d(s(2));
[logz1,logz2] = log_filter1d(s(3));
%% convolving image with 3D LoG
imlog = convs(im,{logx1,logy2,logz2}) + ... 
        convs(im,{logx2,logy1,logz2}) + ...
        convs(im,{logx2,logy2,logz1});

%% use only hills, valleys are removed
imlog(imlog<0) = 0;

%% normalize
imlog = (imlog-min(imlog(:)))/(max(imlog(:))-min(imlog(:)));    

end

%% sepalable convolution
function c = convs(im,h)
    n = length(h);
    c = im;
    for k = 1:n,
        orient = ones(1,ndims(im));
        orient(k) = numel(h{k});
        kernel = reshape(h{k}, orient);
		c = imfilter(c,kernel,'same','symmetric');
    end
end