function out = image_blend

% Load images
imgA = double(imresize(rgb2gray(imread('apple1.jpg')),1))/256;
imgB = double(imresize(rgb2gray(imread('orange1.jpg')),1))/256;

% Find the Gaussian pyramid for both images
GPA = gPyramid(imgA, 10);
GPB = gPyramid(imgB, 10);

% Now based on the Gaussian pyramid, find the Laplacian pyramid for both
% images
LPA = lPyramid(imgA, GPA, 10);
LPB = lPyramid(imgB, GPB, 10);

% Create the mask filter
[rows, cols] = size(imgA);

mask = zeros(rows,cols);
mask(1:rows, 1:cols/2.0) = 1;

%%% This uses the same mask throughout the pyramid but you could
%%%% alternatively create a Gaussian Pyramid of the mask
%%%%%%%

blurh = fspecial('gauss',30,15);

mask = imfilter(mask, blurh, 'replicate');

%%%%%%%%%


% Now apply the multiresolution spline to get the output image
outimage = applySpline(LPA, LPB, mask);

imshow(outimage);

end


%%%% FUNCTIONS GO HERE%%%%%%

%%%%%%%%
% Function to expand the pyramid
%%%%%%%%

function output = expand(lp)

levels = length(lp);
output = lp{levels};

for i = levels:-1:2
    [tr_0, tc_0] = size(lp{i-1});
    output = lp{i-1} + imresize(output, [tr_0, tc_0]);
end

end

%%%%%%%%
% Function to apply the multiresolution spline blending
%%%%%%%%

function output = applySpline(lsa,lsb, mask)

for i = 1:length(lsa)
    [tr, tc] = size(lsa{i});
    m_mask = imresize(mask, [tr,tc]);


%%%%%%%
%%% add YOUR code here: blend left and right images using mask.
%%% Use 'temp' to store and show results for each pyramid level

temp{i} = m_mask.*lsa{i} + (1-m_mask).*lsb{i};
      
%%%%%%%
%%%%%%%
     
  imshow(temp{i})
end

output = expand(temp);

end

%%%%%%%%%%%%%%%
% Function to calculate the Gaussian pyramid
%%%%%%%%%%%%%%%

function GPA = gPyramid(img, levels)

% Gaussian filter
H = [0.0025 0.0125 0.02 0.0125 0.0025;
    0.0125 0.0625 0.1 0.0625 0.0125;
    0.02 0.1 0.16 0.1 0.02;
    0.0125 0.0625 0.1 0.0625 0.0125;
    0.0025 0.0125 0.02 0.0125 0.0025];
    
% Apply the Gaussian to get the first level of the pyramid, then for each
% level resize the image to half and apply the Gaussian again
GPA{1} = applyFilter(img, H); 

for i = 2:levels
    temp = imresize(GPA{i-1}, 0.5);
    GPA{i} = applyFilter(temp, H);
end

end

%%%%%%%%%%%%%%
% Function to calculate the Laplacian pyramid
%%%%%%%%%%%%%%

function LPA = lPyramid(img, gpa, levels)

LPA{1} = img - gpa{1};
% Each level of the Laplacian pyramid is the difference between the
% corresponding level in the Gaussian pyramid and the resized next level in the
% Gaussian pyramid
for i = 1:levels-1

	  
    [tr_0, tc_0] = size(gpa{i});
     %%%%% YOUR code here to compute the levels of the laplacian pyramid.
    LPA{i+1} = gpa{i} - imresize(gpa{i+1},[tr_0, tc_0]);
      
end

end

%%%%%%%%%%%%%%
% Function to apply a filter on an image using Fourier transforms
%%%%%%%%%%%%%%

function result = applyFilter(img, H)
[rows, cols] = size(img);

H_fft = fft2(H,rows,cols);
img_fft = fft2(img, size(H_fft, 1), size(H_fft, 2));

% Perform filtering.
result = real(ifft2(H_fft.*img_fft));
% Crop to original size.
result = result(1:size(img, 1), 1:size(img, 2));

end
