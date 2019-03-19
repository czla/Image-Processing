% Description:  this script smoothes the given image with 'pepper&salt'
%               noise and segment the apple area afterwards.
% Author:       zlchen
% Date:         3/14/2019
% Email:        zlchen@tongji.edu.cn
clc;clear;

src = imread('apple_noise.jpg');                % load image
subplot(231);
imshow(src);
title('source image');

src_gray = rgb2gray(src);                       % convert to gray image
subplot(232);
imshow(src_gray);
title('gray image');

src_gray=medfilt2(src_gray,[4 4]);              % use median filter to remove 'pepper&salt' noise
mask = src_gray;                                % mask defination
[rows, cols] = size(src_gray);

% generate the mask for apple area
for i = 1:rows
    for j = 1:cols
        if(src_gray(i,j) > 215 || src_gray(i,j) < 10)
            mask(i,j) = 0;
        else
            mask(i,j) = 255;
        end
    end
end
subplot(233);
imshow(mask);
title('apple area mask');

cc = bwconncomp(mask);                          % find connected component
stats = regionprops(cc, 'Area','Centroid');     % compute property of connected component
centroid = cat(1,stats.Centroid);               % convert centroid to matrix

% filter the apple area based on 'Area' and 'Centroid'
idx = find([stats.Area] > 100 & centroid(:,1) < 170 & centroid(:,2) < 160); 
bw = ismember(labelmatrix(cc), idx);  
subplot(236);
imshow(bw);
title('target connected component');

% fill the hole
se = strel('square',3);
bw2 = imclose(bw, se);
bw_filled=bwfill(bw2,'hole');
subplot(235);
imshow(bw_filled);
title('final mask');

% get the smoothed source color image
src_smooth = cat(3,medfilt2(src(:,:,1),[4 4]),medfilt2(src(:,:,2),[4 4]),medfilt2(src(:,:,3),[4 4]));
subplot(234);
imshow(src_smooth);
title('source smooth image');

% show the result image
res = src_smooth .* uint8(cat(3,bw_filled,bw_filled,bw_filled));
subplot(236);
imshow(res);
title('result image');