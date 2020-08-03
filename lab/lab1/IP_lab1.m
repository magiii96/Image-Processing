%task1
I = imread('cat.jpg') %read image
% Extract color channels.
redChannel = I(:,:,1); % Red channel
greenChannel = I(:,:,2); % Green channel
blueChannel = I(:,:,3); % Blue channel
allBlack = zeros(size(I, 1), size(I, 2), 'uint8');
just_red = cat(3, redChannel, allBlack, allBlack);
just_green = cat(3, allBlack, greenChannel, allBlack);
just_blue = cat(3, allBlack, allBlack, blueChannel);
% Display them all.
subplot(3, 3, 2);
imshow(I);
fontSize = 20;
title('Original RGB Image', 'FontSize', fontSize)
subplot(3, 3, 4);
imshow(just_red);
title('Red Channel', 'FontSize', fontSize)
subplot(3, 3, 5);
imshow(just_green)
title('Green Channel', 'FontSize', fontSize)
subplot(3, 3, 6);
imshow(just_blue);
title('Blue Channel', 'FontSize', fontSize)
subplot(3, 3, 8);
togrey = 0.299 * redChannel+ 0.587 * greenChannel + 0.114 * blueChannel;
figure;
imshow(togrey);

%task2
r_flip = redChannel';
g_flip = greenChannel';
b_flip = blueChannel';
I_flip = cat(3,r_flip,g_flip,b_flip);
figure;
imshow(I_flip);

%task3
I1=I(1:size(I,1)/2,1:size(I,2)/2,:);
I2=I(size(I,1)/2+1:size(I,1),1:size(I,2)/2,:);
I3=I(1:size(I,1)/2,size(I,2)/2+1:size(I,2),:);
I4=I(size(I,1)/2+1:size(I,1),size(I,2)/2+1:size(I,2),:);
figure;
subplot(2, 3, 2);
imshow(I1);
subplot(2, 3, 3);
imshow(I3);
subplot(2, 3, 5);
imshow(I2);
subplot(2, 3, 6);
imshow(I4);

%task4
J = imresize(I, 0.5, 'nearest');
figure;
imshow(J);

img = imread('bird.jpg');
n = 2; % n can only be integer
[row_size, col_size] = size(img(:, :, 1));

% getting rid of extra rows and columns that won't be counted in averaging:
I = img(1:n*floor(row_size / n), 1:n*floor(col_size / n), :);
[r, ~] = size(I(:, :, 1));

% separating and re-ordering the three colors of image in a way ...
% that averaging could be done with a single 'mean' command:
R = reshape(permute(reshape(I(:, :, 1), r, n, []), [2, 1, 3]), n*n, [], 1);
G = reshape(permute(reshape(I(:, :, 2), r, n, []), [2, 1, 3]), n*n, [], 1);
B = reshape(permute(reshape(I(:, :, 3), r, n, []), [2, 1, 3]), n*n, [], 1);

% averaging and reshaping the colors back to the image form:
R_avg = reshape(mean(R), r / n, []);
G_avg = reshape(mean(G), r / n, []);
B_avg = reshape(mean(B), r / n, []);

% concatenating the three colors together:
scaled_img = cat(3, R_avg, G_avg, B_avg); 

% casting the result to the class of original image
scaled_img = cast(scaled_img, 'like', img); 

figure;
imshow(img);
imshow(scaled_img);
