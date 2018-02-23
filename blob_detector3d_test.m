%% clear
clc; clear all; close all;

%% path
addpath('./lib')

%% load image
im = imread3d('./im/arabidopsis.tif');

%% normalize
im = double(im); im = (im-min(im(:)))/(max(im(:))-min(im(:)));

%% blob detection
rx = 0.1387; % pixel/micron resolution for x
ry = 0.1387; % pixel/micron resolution for x
rz = 1; % pixel/micron resolution for x
s = 2; % blob size in microns
s = [s/rx s/ry s/rz]; % blob size in pixels for x and y and z
t = 0.10; % threshold level

b = blob_detector3d(im,s,t);

%% plot max
imm = max(im,[],3);

%% plot
figure; 
imagesc(imm); colormap gray; colormap gray; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;

%% plot
bp = round(b(:,1:2));
bp(bp<1) = 1;
bp(bp>size(imm,1),1) = size(imm,1);
bp(bp>size(imm,2),2) = size(imm,2);
immask = false(size(imm));
immask(sub2ind(size(immask),bp(:,1),bp(:,2))) = 1;

se = strel('disk',3);
immask = imdilate(immask,se);

imr = imm; img = imm; imb = imm;
imr(immask) = 1; img(immask) = 0; imb(immask) = 0;
imrgb = zeros(size(imm,1),size(imm,2),3);
imrgb(:,:,1) = imr; imrgb(:,:,2) = img; imrgb(:,:,3) = img;

figure; 
imagesc(imrgb); colormap gray; colormap jet; 
set(gca,'ytick',[]); set(gca,'xtick',[]); axis image; axis tight;