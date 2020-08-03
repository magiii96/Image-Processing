%load the image
img = imread('sample_image.jpg');
%convert to double and gray scale
img = double(rgb2gray(img))/255;
% Get its range so that displays can be consistent.
range = [min(img(:)) max(img(:))];
% Display the initial image
f1 = figure; imshow(img, range);

row = round(size(img,1)/2);
% Show the selected row
figure(f1); hold on; plot([1 size(img,2)], [row row], 'r-'); hold off
% Extract the row
x = img(row, :);
% Display the grey-level profile
figure; plot(x); title('Grey-level profile');

X = fft(x);
figure; plot(abs(X)); title('Amplitudes as a function of frequency');

figure;
mn = min(x); mx = max(x);
% Initialise. The starting point for the reconstruction is the
% "zero-frequency" or constant component held in X(1).
N = length(x);
reconstruction = X(1)/N;
p = 2*pi*(0:N-1)/N;
for k = 1:N/2
 % Compute the component for the frequency that gives k cycles in the
 % width of the image.
 a = X(k+1); % complex amplitude of this component
 phi = k*p; % phase array
 % Take advantage of the symmetry that results from x being real to
 % ignore the top half of X. Must therefore double the intermediate
 % components.
 if k < N/2; s = 2; else s = 1; end
 % This is the core equation for the Fourier transform: a single
 % component is a harmonic (sin or cosine) wave
 component = s*(real(a)*cos(phi) - imag(a)*sin(phi))/N;
 % and add the component to the reconstruction so far
 reconstruction = reconstruction + component;
 % Plot the results, but not for every iteration
 if ismember(k, [1:7 8:16:63 64:32:N/2])
 subplot(2,1,1);
 plot(component);
 axis([1 length(x) mn mx]);
 title(['Spatial frequency ' num2str(k) 'cycles across the image']);
 subplot(2,1,2);
 plot(reconstruction);
 axis([1 length(x) mn mx]);
 title('Reconstruction so far');
 pause;
 end
end
