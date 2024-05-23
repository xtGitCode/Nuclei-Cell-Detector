% user input image file
[file,path] = uigetfile('*');
filepath = fullfile(path,file);
im = imread(filepath);

% blur using Gaussian filter to remove noise
blur = imgaussfilt(im,0.5);

% brighten image
brighten = imlocalbrighten(blur,0.9);

% convert rgb to hsv colour space
img_hsv = rgb2hsv(brighten);

% Extract the Hue, Saturation, and Value channels
hue = img_hsv(:,:,1);
saturation = img_hsv(:,:,2);
value = img_hsv(:,:,3);

% Create a logical mask for green pixels
green_mask = (hue >= 0.08 & hue <= 0.9) & (saturation >= 0 & saturation <= 1) & (value >= 0.05 & value <= 1);
% Apply the mask to the original image
green_pixels = img_hsv .* repmat(green_mask,[1 1 3]);

% Apply the mask to the original image
img_gray = rgb2gray(green_pixels);
threshold = graythresh(img_gray);
binary = imbinarize(img_gray, threshold);

% remove noises (pixels less than 20)
im1 = bwareaopen(binary,20);

% separate small cells and big cells
im2 = im1 - bwareaopen(binary,150);
im3 = bwareaopen(binary,150);

% open big cells
se = strel('disk',4);
open = imopen(im3, se);

% smoothen edges for small cells
windowSize = 4; 
kernel = ones(5)/windowSize^2;
blurredImage = conv2(im2, kernel, 'same');
smoothen = blurredImage > 0.5;

% combine both result
outputIm = smoothen | open;

% watershed
% distance transform
D = -bwdist(~outputIm, 'euclidean');

% get local minima
mask = imextendedmin(D,1.1);
D2 = imimposemin(D,mask);

Ld2 = watershed(D2);
bw3 = outputIm;
bw3(Ld2 == 0) = 0;

% color cells
% Get connected components
CC = bwconncomp(bw3);

% Get label matrix
L = labelmatrix(CC);

% Generate randomized colormap
rng('shuffle'); 
num_labels = max(L(:));
cmap = rand(num_labels, 3);

% Create colored label matrix
RGB = label2rgb(L, cmap, 'k', 'shuffle');

% display images
montage({im, binary, RGB})

