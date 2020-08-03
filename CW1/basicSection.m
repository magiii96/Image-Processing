%% Some parameters to set - make sure that your code works at image borders!

% Row and column of the pixel for which we wish to find all similar patches 
% NOTE: For this section, we pick only one patch
row = 10;
col = 10;

% Patchsize - make sure your code works for different values
patchSize = 3;

% Search window size - make sure your code works for different values
searchWindowSize =11;


%% Implementation of work required in your basic section-------------------

% TODO - Load Image
img = imread('images/alleyNoisy_sigma20.png');
img = rgb2gray(img);
img = double(img);



% TODO - Template matching for naive SSD (i.e. just loop and sum)
[offsetsRows_naive, offsetsCols_naive, distances_naive] = templateMatchingNaive(row, col,...
    patchSize, searchWindowSize,img);



%% Let's print out your results--------------------------------------------

for i=1:length(offsetsRows_naive)
    disp(['offset rows: ', num2str(offsetsRows_naive(i)), '; offset cols: ',...
        num2str(offsetsCols_naive(i)), '; Naive Distance = ', num2str(distances_naive(i),10)]);
end
