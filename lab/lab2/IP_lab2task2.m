%load the image
img = imread('noise.jpeg');
figure;
imshow(img);
%convert to double and gray scale
img = double(rgb2gray(img))/255;
% Display the initial image
f1 = figure;
imshow(img);
[r,c]=size(img);
F_SP = zeros(r,c);
%filter in greyimage
for i=2:r-1
    for j =2:c-1
        flt =[img(i-1,j-1),img(i-1,j),img(i-1,j+1),img(i,j-1),img(i,j),img(i,j+1),img(i+1,j-1),img(i+1,j),img(i+1,j+1)];
F_SP(i,j)=median(flt);
    end
end
%figure;
%imshow(F_SP,[]);


%fliter in color image
img_color = imread('noise.jpeg');
redChannel = img_color(:,:,1); % Red channel
greenChannel = img_color(:,:,2); % Green channel
blueChannel = img_color(:,:,3); % Blue channel
redChannel = double(redChannel)/255;
greenChannel = double(greenChannel)/255;
blueChannel = double(blueChannel)/255;

F_R = zeros(r,c);
for i=2:r-1
    for j =2:c-1
        flt =[redChannel(i-1,j-1),redChannel(i-1,j),redChannel(i-1,j+1),redChannel(i,j-1),redChannel(i,j),redChannel(i,j+1),redChannel(i+1,j-1),redChannel(i+1,j),redChannel(i+1,j+1)];
F_R(i,j)=median(flt);
    end
end

F_G = zeros(r,c);
for i=2:r-1
    for j =2:c-1
        flt =[greenChannel(i-1,j-1),greenChannel(i-1,j),greenChannel(i-1,j+1),greenChannel(i,j-1),greenChannel(i,j),greenChannel(i,j+1),greenChannel(i+1,j-1),greenChannel(i+1,j),greenChannel(i+1,j+1)];
F_G(i,j)=median(flt);
    end
end

F_B = zeros(r,c);
for i=2:r-1
    for j =2:c-1
        flt =[blueChannel(i-1,j-1),blueChannel(i-1,j),blueChannel(i-1,j+1),blueChannel(i,j-1),blueChannel(i,j),blueChannel(i,j+1),blueChannel(i+1,j-1),blueChannel(i+1,j),blueChannel(i+1,j+1)];
F_B(i,j)=median(flt);
    end
end

recombinedRGBImage = cat(3, F_R, F_G, F_B);

%figure;
%imshow(recombinedRGBImage);

%Adaptive filter

%black & white
F_AVar= zeros(r,c);
F_AA = zeros(r,c);

for i=2:r-1
    for j =2:c-1
        flt = [img(i-1,j-1) img(i-1,j) img(i-1,j+1) img(i,j-1) img(i,j) img(i,j+1) img(i+1,j-1) img(i+1,j) img(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AVar(i,j) = std(flt(:));
    end
end

for i=2:r-1
    for j =2:c-1
        flt = [img(i-1,j-1) img(i-1,j) img(i-1,j+1) img(i,j-1) img(i,j) img(i,j+1) img(i+1,j-1) img(i+1,j) img(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AA(i,j)=meanf+((varf-(mean(F_AVar(:)))^2)/varf)*(img(i,j)-meanf);    
    end
end

figure;
imshow(F_AA);


%color
F_AVar= zeros(r,c);
F_AR = zeros(r,c);

for i=2:r-1
    for j =2:c-1
        flt = [redChannel(i-1,j-1) redChannel(i-1,j) redChannel(i-1,j+1) redChannel(i,j-1) redChannel(i,j) redChannel(i,j+1) redChannel(i+1,j-1) redChannel(i+1,j) redChannel(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AVar(i,j) = std(flt(:));
    end
end

for i=2:r-1
    for j =2:c-1
        flt = [redChannel(i-1,j-1) redChannel(i-1,j) redChannel(i-1,j+1) redChannel(i,j-1) redChannel(i,j) redChannel(i,j+1) redChannel(i+1,j-1) redChannel(i+1,j) redChannel(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AR(i,j)=meanf+((varf-mean(F_AVar(:))^2)/varf)*(redChannel(i,j)-meanf);    
    end
end

F_AVar= zeros(r,c);
F_AG = zeros(r,c);

for i=2:r-1
    for j =2:c-1
        flt = [greenChannel(i-1,j-1) greenChannel(i-1,j) greenChannel(i-1,j+1) greenChannel(i,j-1) greenChannel(i,j) greenChannel(i,j+1) greenChannel(i+1,j-1) greenChannel(i+1,j) greenChannel(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AVar(i,j) = std(flt(:));
    end
end

for i=2:r-1
    for j =2:c-1
        flt = [greenChannel(i-1,j-1) greenChannel(i-1,j) greenChannel(i-1,j+1) greenChannel(i,j-1) greenChannel(i,j) greenChannel(i,j+1) greenChannel(i+1,j-1) greenChannel(i+1,j) greenChannel(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AG(i,j)=meanf+((varf-mean(F_AVar(:))^2)/varf)*(greenChannel(i,j)-meanf);    
    end
end


F_AVar= zeros(r,c);
F_AB = zeros(r,c);

for i=2:r-1
    for j =2:c-1
        flt = [blueChannel(i-1,j-1) blueChannel(i-1,j) blueChannel(i-1,j+1) blueChannel(i,j-1) blueChannel(i,j) blueChannel(i,j+1) blueChannel(i+1,j-1) blueChannel(i+1,j) blueChannel(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AVar(i,j) = std(flt(:));
    end
end

for i=2:r-1
    for j =2:c-1
        flt = [blueChannel(i-1,j-1) blueChannel(i-1,j) blueChannel(i-1,j+1) blueChannel(i,j-1) blueChannel(i,j) blueChannel(i,j+1) blueChannel(i+1,j-1) blueChannel(i+1,j) blueChannel(i+1,j+1)];
        meanf = mean(flt(:));
        varf = var(flt(:));
        F_AB(i,j)=meanf+((varf-mean(F_AVar(:))^2)/varf)*(blueChannel(i,j)-meanf);    
    end
end

A_image = cat(3, F_AR, F_AG, F_AB);
figure;
imshow(A_image);



