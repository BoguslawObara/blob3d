function b = blob_detector3d(im,s,t)
%%  blob_detector3d
%   
%   REFERENCE:
%       B. Obara and A. Jabeen and N. Fernandez and P. P. Laissue,
%       A novel method for quantified, superresolved, three-dimensional 
%       colocalisation of isotropic, fluorescent particles,
%       Histochemistry and Cell Biology, 139, 3, 391-402, 2013 
%
%   INPUT:
%       imn     - image
%       s       - blob size[pixels] = 
%                   ns[microns]*[1/resolutionx 1/resolutiony 1/resolutionz]
%       t       - lowest intensity bound,
%
%   OUTPUT:
%       np      - detected blob positions
%                   b(:,1) -> x
%                   b(:,2) -> y
%                   b(:,3) -> z
%                   b(:,4) -> average intensity of blob volumes
%                   b(:,5) -> average LoG intensity of blob volumes
%
%   AUTHOR:
%       Boguslaw Obara

%% LoG
imlog = blob_filter3d(im,s);

%% finding seeds
b = seed_search3d(imlog,s,t);

%% filtering
dt = mask_descriptor3d(im,imlog,b,s);
b = stat_descriptor3d(im,b,dt,1.1*s);

%% average intensity values          
b(:,5) = dt(b(:,4),1);
b(:,6) = dt(b(:,4),2);
b(:,4) = []; % remove indices

end