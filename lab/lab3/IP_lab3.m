img = imread('moon.tif');
img_c = imread('cat.jpg');
imc_copy = img_c;
img_c = im2double(img_c);
img = double(img);
[row,col] = size(img);
K = 2;
%kmeans from matlab function
%for grayscale
F = reshape(img,[row*col,1]);  
[idx,centres] = my_kmeans(F,K);
img_k = reshape(idx,[row,col]);
figure();
imshow(img_k-1);
%for colorimage
F_C = reshape(img_c,size(img_c,1)*size(img_c,2),3);
r = F_C(:,1);
g = F_C(:,2);
b = F_C(:,3);
idx_c = my_kmeans([r g b],3);
imc = reshape(idx_c,[size(img_c,1),size(img_c,2)]);
imgc_kr= labeloverlay(imc_copy,imc);
figure();
imshow(imgc_kr);
%kmeans function by own

function [idx,centres]=my_kmeans(I,K)
%%%  k-means clustring with maximin algorithm to initialize the centroids
 %[idx, centres] = k_means(X, K) returned N x 1 vector idx contains the cluster indices of each point
%and the K clusters centroids locations in the K x dim matrix, centres.
%Dimitriadis Spyros  23/4/2017
[N dim] = size(I); % dataset dimensions


% initial cluster centres  PICK RANDOM POINTS
centres = zeros(K,dim);
for k=1:K
x = randi(N);
centres(k,:) =  I(x,:);  
end

% %call the function my_minimax to initialize the centroids
% [centres]=my_minimax(A,K);


% % fprintf('[0] Iteration: ')
% % centres % show cluster centres at iteration 0
maxiter = 100; % Maximum number of iterations
D = zeros(K, N); % KxN matrix for storing distances between cluster centres and observations
idx_prev=centres;
% Iterate ’maxiter’ times
for i = 1:maxiter
    % Compute Squared Euclidean distance
    % between each cluster centre and each observation
    for c = 1:K
        D(c,:) = sum(bsxfun(@minus, I, centres(c,:)).^2, 2); %Squared Euclidean distance
        % D(c,:) = kl_div(A, centres(c,:));   %myKullback-Leibler divergence
    end
    % Assign data to clusters
    [D, idx] = min(D); % find min dist. for each observation
    
    % Update cluster centres
    for c = 1:K
        centres(c, :) = mean(I(idx==c,:) );
    end
    
    %break the loop if the centres are not changed
    if idx_prev ==centres
        break
    end
    idx_prev = centres;
    
    % %     fprintf('[%d] Iteration: ', i)
    % %     centres % show cluster centres at iteration i
end

end


