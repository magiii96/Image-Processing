i1=imread('cheetah.png');
i1=rgb2gray(i1);
figure,

subplot(2,4,1);imshow(i1);title('cheetah');
f1=fft2(i1);
f1s = fftshift(fft2(i1));
magnitude1 = abs(f1);
magnitude1s = log(abs(f1s)+1);
subplot(2,4,2);imshow(magnitude1s,[]),title('cheetah magnitude');
phase1=angle(f1);
phase1s = angle(f1s);
subplot(2,4,3);imshow(phase1s,[]),title('cheetah phase');

i2=imread('zebra.png');
i2=rgb2gray(i2);

subplot(2,4,5);imshow(i2);title('Zebra');
f2 = fft2(i2);
f2s = fftshift(fft2(i2));
magnitude2 = abs(f2);
magnitude2s= abs(f2s);
magnitude2s = log(magnitude2s+1);
subplot(2,4,6);imshow(magnitude2s,[]),title('zebra magnitude');
phase2=angle(f2);
phase2s=angle(f2s);
subplot(2,4,7);imshow(phase2s,[]),title('zebra phase');

combine1 = magnitude1 .* (cos(phase2)+ 1i*sin(phase2));
combine1 = ifft2(combine1);
subplot(2,4,4);imshow(uint8(combine1)),title('Cheetah magnitude with Zebra phase');

combine2 = magnitude2 .* exp(1i*phase1);
combine2 = uint8(ifft2(combine2));
subplot(2,4,8);imshow(combine2,[]),title('Zebra magnitude with Cheetah phase');

