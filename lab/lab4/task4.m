
% Read image to be registered
A = rgb2gray(imread('IMG_0070.JPG')); 
% Display
figure, imshow(A);
% Interactively deﬁne coords of input quadrilateral
[a,b] = ginput(4); input_points = [a b];
% Read base reference image
figure, imshow(imread('IMG_0071.PNG'));
% Interactively deﬁne coords of basequadrilateral
[a,b] = ginput(4); base_points = [a b];
% Create projective transformation structure
t = cp2tform(input_points, base_points, 'projective');
% Apply projective transform
registered = imtransform(A,t);
% Interactively crop result
B = imcrop(registered);
figure, imshow(B)