% Description:  this script finds the smallest apple in the given
%               picture.('apple.jpg')
% Author:       zlchen
% Date:         3/8/2019
% Email:        zlchen@tongji.edu.cn
clc;clear;

src = imread('apple.jpg');                      % load image
subplot(231);
imshow(src);
title('source image');

src_gray = rgb2gray(src);                       % convert to gray image
subplot(232);
imshow(src_gray);
title('gray image');

src_bw = (src_gray > 160) & (src_gray < 225);   % convert to binary image
subplot(233);
imshow(src_bw);
title('binary image');

cc = bwconncomp(src_bw);                        % find connected component
stats = regionprops(cc, 'Area','Centroid');     % compute property of connected component
centroid = cat(1,stats.Centroid);               % convert centroid to matrix

% filter the smallest apple area based on 'Area' and 'Centroid'
idx = find([stats.Area] > 80 & centroid(:,1) > 170 & centroid(:,1) < 270 & centroid(:,2) < 65); 
bw = ismember(labelmatrix(cc), idx);  
subplot(234);
imshow(bw);
title('target connected component');

% fill the hole
se = strel('square',7);
bw2 = imclose(bw, se);
bw_filled=bwfill(bw2,'hole');
subplot(235);
imshow(bw_filled);
title('target mask');

% show the result image
res = src .* uint8(cat(3,bw_filled,bw_filled,bw_filled));
subplot(236);
imshow(res);
title('result image');