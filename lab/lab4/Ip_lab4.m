%load the image
img = imread('IMG_0071.PNG');
inputimg = imread('IMG_0070.JPG');
figure();
%convert to double and gray scale
img = rgb2gray(img);
inputimg =  rgb2gray(inputimg);
subplot(2,1,1)
imshow(img)
[x, y] = size(img);
[x2, y2] = size(inputimg);

newimg = uint8(zeros(x,y));
frequency = 1:256;
n = 0:255;
fcum = zeros(1,length(n));
h = zeros(1,length(n));
count = 0;
ccount = 0;

for i = 1:256
    for j = 1:x
        for k = 1:y
            if img(j, k) == i-1
                count = count + 1;
            end
        end
    end
    ccount = ccount+count;
    fcum(i) = ccount;
    frequency(i) = count;
    count = 0;
    h(i) = ((fcum(i)- 1)/(x*y - 1)) * 255;
end



for s = 1:256
    for w = 1:x
        for z = 1:y
            if img(w,z) == s-1
                newimg(w,z) = h(s);
            end
        end
    end
end
 
subplot(2,1,2);
imshow(newimg);



%plot(n, frequency);
%plot(n,h);
%grid on;
%ylabel('number of pixel with such intensity')
%xlabel('intensity')
%title('Histogram of the image')

%figure();
%plot(n, fcum);


%task3
%normalize cdf
nfcum = zeros(1,length(n));
nfcum = fcum/262144;

ih = zeros(1,length(n));
ifrequency = 1:256;
ifcum = zeros(1,length(n));
icount = 0;
iccount = 0;
for i = 1:256
    for j = 1:x2
        for k = 1:y2
            if inputimg(j, k) == i-1
                icount = icount + 1;
            end
        end
    end
    iccount = iccount+icount;
    ifcum(i) = iccount;
    ifrequency(i) = icount;
    icount = 0;
    ih(i) = ((ifcum(i)- 1)/(x*y - 1)) * 255;
end

infcum = zeros(1,length(n));
infcum = ifcum/166500;
outfcum = zeros(1,length(n));

outvalue = zeros(1,length(n));
for i = 1:256
    if infcum(i) > nfcum(i)
        outvalue(i) = ((fcum(i)- 1)/(x*y - 1)) * 255;
    end
    outvalue(i) = ((ifcum(i)- 1)/(x2*y2 - 1)) * 255;
    
end

ninputimg = uint8(zeros(x2,y2));
for s = 1:256
    for w = 1:x2
        for z = 1:y2
            if inputimg(w,z) == s-1
                ninputimg(w,z) = outvalue(s);
            end
        end
    end
end
 
figure();
subplot(2,2,1);
imshow(inputimg);
subplot(2,2,2);
imshow(img);
subplot(2,2,3);
imshow(ninputimg);



