%task1
img = imread('einsteIn.png');


img = double(rgb2gray(img))/255;
[r, c] = size(img);
% Display the original color image.
figure();
subplot(2, 2, 1);
imshow(img);
title('Subplot 1');
%convert to double and gray scale


% Extract the individual red, green, and blue color channels.
%redChannel = img(:, :, 1);
%greenChannel = img(:, :, 2);
%blueChannel = img(:, :, 3);


F_img = zeros(r,c);
%median filter in greyimage
for i=2:r-1
    for j =2:c-1
        flt =[img(i-1,j-1),img(i-1,j),img(i-1,j+1),img(i,j-1),img(i,j),img(i,j+1),img(i+1,j-1),img(i+1,j),img(i+1,j+1)];
        F_img(i,j)=median(flt);
    end
end

subplot(2, 2, 2);
imshow(F_img,[]);
title('Subplot 2');



a = -floor(7/2):1:floor(7/2);
b = floor(7/2):-1:-floor(7/2);

[X,Y] = meshgrid(a,b);


Gfiltered = Gauss(X,Y,0.5);
Gfiltered = Gfiltered(:).';
gsum = sum(Gfiltered);
Gfiltered = Gfiltered(:).'/gsum;

Gfiltered1 = Gauss(X,Y,1.0);
Gfiltered1 = Gfiltered1(:).';
gsum1 = sum(Gfiltered1);
Gfiltered1 = Gfiltered1(:).'/gsum1;


F_7img = zeros(r,c);

%7*7 filter

for i=1+floor(7/2):r-floor(7/2)
    for j =1+floor(7/2):c-floor(7/2)
        flt7 = [];
        for k = -floor(7/2):floor(7/2)
            for w = -floor(7/2):floor(7/2)
                flt7 = [flt7;img(i+k,j+w)];
            end
        end
      F_7img(i,j)=dot(flt7,Gfiltered);
     end
end

F_71img = zeros(r,c);
for i=1+floor(7/2):r-floor(7/2)
    for j =1+floor(7/2):c-floor(7/2)
        flt7 = [];
        for k = -floor(7/2):floor(7/2)
            for w = -floor(7/2):floor(7/2)
                flt7 = [flt7 img(i+w,j+k)];
            end
        end
      F_71img(i,j)=dot(flt7,Gfiltered1);
     end
end

subplot(2, 2, 3);
imshow(F_7img,[]);
title('7*7 Gaussian with sigma = 0.5');

subplot(2, 2, 4);
imshow(F_71img,[]);
title('7*7 Gaussian with sigma = 1.0');






function Gaussian_filtered = Gauss(x,y, sigma)
Gaussian_filtered = exp(-(x^2+y^2)/(2*sigma^2)) / (sigma^2*2*pi); 
end






