function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)

%REPLACE THIS
%get the rows and colums and 3 channels in the original image.

image = double(image);
%[r,c,dim] = size(image); %color image
[r,c] = size(image); %gray image

%use function padarray to do image padding for the edge

%padding our image to avoid the filter out of the range.
padsize = floor(windowSize/2) + floor(patchSize/2);
padimg = padarray(image, [padsize,padsize],'replicate','both');

%F_img = zeros(r,c,dim);
F_img = zeros(r,c);
%loop over the whole picture.
for i = 1:r
    for j = 1:c
         flt = 0;
         weight = zeros(windowSize*windowSize,1);
         %for every pixel in the img get the distance and correspoding
         %coordiantes in the search window
         [offsetsRows,offsetsCols,distances] = templateMatchingNaive(i+padsize,j+padsize,patchSize,windowSize,padimg);
         %get the weight of our pixel in the search window
         for a = 1:windowSize*windowSize
            weight(a) = computeWeighting(distances(a),h,sigma,patchSize);
            %flt = flt + padimg(offsetsRows(a)+i+padsize,offsetsCols(a)+j+padsize,:) .* weight(a);
            flt = flt + padimg(offsetsRows(a)+i+padsize,offsetsCols(a)+j+padsize) .* weight(a);
         end
         sumw = sum(weight);
         %normalize the weight
         F_img(i,j) = flt/sumw;
         %F_img(i,j,:) = flt/sumw;
    end
end
result = F_img;
end