%load image
imgz = imread('zebra.png');
imgc = imread('cheetah.png');
Fz = fftshift(imgz);
Fc = fftshift(imgc);
magz = abs(Fz);
phasecz = angle(Fz);
magc = abs(Fc);
phasec = angle(Fc);
plot(magz);
