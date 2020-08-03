%% Some parameters to set - make sure that your code works at image borders!
patchSize = 11;
sigma = 20; %standard deviation (different for each image!) 
            %our estimate sigma.
h = 0.5;    %decay parameter
windowSize = 9;

%TODO - Read an image (note that we provide you with smaller ones for
%debug in the subfolder 'debug' int the 'image' folder);
%Also unless you are feeling adventurous, stick with non-colour
%images for now.
%NOTE: for each image, please also read its CORRESPONDING 'clean' or
%reference image. We will need this later to do some analysis
%NOTE2: the noise level is different for each image (it is 20, 10, and 5 as
%indicated in the image file names)

%load the image


%REPLACE THIS
imageNoisy = imread('images/alleyNoisy_sigma20.png');
%imageGray = imageNoisy;
imageGray = rgb2gray(imageNoisy);

imageReference = imread('images/alleyReference.png');
%imageReferenceGray = imageReference;
imageReferenceGray = rgb2gray(imageReference);

tic;
%TODO - Implement the non-local means function
filtered = nonLocalMeans(imageGray, sigma, h, patchSize, windowSize);
filteredint = uint8(filtered);

%filteredint = filtered;
toc

%% Let's show your results!

%Show the denoised image
figure('name', 'NL-Means Denoised Image');
imshow(filteredint);


%Show difference image
diff_image = abs(double(imageReferenceGray) - filtered);
figure('name', 'Difference Image');
imshow(diff_image ./ max(max((diff_image))));

%Print some statistics ((Peak) Signal-To-Noise Ratio)
disp('For Noisy Input');
[peakSNR, SNR] = psnr(imageGray, imageReferenceGray);
disp(['SNR: ', num2str(SNR, 10), '; PSNR: ', num2str(peakSNR, 10)]);

disp('For Denoised Result');
[peakSNR, SNR] = psnr(filteredint, imageReferenceGray);
disp(['SNR: ', num2str(SNR, 10), '; PSNR: ', num2str(peakSNR, 10)]);

%Feel free (if you like only :)) to use some other metrics (Root
%Mean-Square Error (RMSE), Structural Similarity Index (SSI) etc.)