%show the importing gradient

%load the source image 
I_source = imread('tu3.jpg');
%load the target image
I_target = imread('moon.jpg');

%change to the gray scale 
I_source = rgb2gray(I_source);
I_target = rgb2gray(I_target);

%get rows and columns of the image
[srows,scols] = size(I_source);
[trows,tcols] = size(I_target);

%Mark out a selection region using a polygon, denote by Ω Omega .
Omega = roipoly(I_source);
Omega = double(Omega);

%Select the area in the target where you want to clone the source image.
[target_y,target_x,p] = impixel(I_target);
target_x = round(target_x);
target_y = round(target_y);

%Get the index of pixels in the seletct region
[row_o, col_o] = find(Omega);
% get the coordinates of the first point of the selected region.
startpoint=[min(row_o),min(col_o)];
%Initialize the 
Omega_2 = zeros(trows,tcols);

% r_range is the row indices of unknown pixels in target image
r_range=target_x+row_o-startpoint(1);
% c_range is the col indices of unknown pixels in target image
c_range=target_y+col_o-startpoint(2);

%set all the unknow pixel in the selection region to be 1.
Omega_2(sub2ind(size(I_target), r_range, c_range))=1;


%Label our unknow destination image
source_I = double(I_source);

%Get the known sclar function f^*.
knownf = double(I_target);
 
%Get the index of pixels in the selection region omega
Omega_i = find(Omega_2);
%Get the number of pixel in the selection region denote by the |Ω|
Omega_num = size(Omega_i,1);

%initialize unknow scalar function f 
unknow_i = zeros(trows,tcols);

%d let f be an unknown scalar function defined over the interior of Ω
for i = 1:Omega_num
    unknow_i(Omega_i(i)) = i;
end
 
%Initialize the vector b
b = zeros(Omega_num,1);
 
%Initialize the sparse matrix A
A = sparse(Omega_num,Omega_num);
 
%Initialize the matrix index pi
pi = 1;

%use loop
for c = 1:tcols
   for r = 1:trows
       %If the pixel belong to the seletion region Omega.
       if(Omega_2(r,c) == 1)
            %Next step, we need check if the four neighbors belongs to the
            %selected region.
            %pj belong to the Npi and Omega.
            
            %bpi = sum of known scalar function f + sum of Vpq.
            %In the importing gradient, for all<p,q>,our Vpq = gp-gq.
            %We loop over the cols and rows of target image.
            %To get the vector field V, 
            %We need to find the corresponding pixel in the source image.
            source_x = r-target_x+startpoint(1);
            source_y = c-target_y+startpoint(2);
           
            %The up neighbour 
            Vpq1 = source_I(source_x,source_y) - source_I(source_x-1,source_y);
            %Our neighbors belong to the selection region.
            if(Omega_2(r-1,c) == 1)
                A(pi, unknow_i(r-1,c)) = -1;
                b(pi) = b(pi) + Vpq1;
            %Our neighbors does not belong to the selection region, which
            %means the neighbor belong to the boundary. 
            else 
                b(pi) = b(pi) + knownf(r-1,c) + Vpq1;
            end
          
            %The down neighbour
            Vpq2 = source_I(source_x,source_y) - source_I(source_x+1,source_y);
            if(Omega_2(r+1,c) == 1)
                A(pi, unknow_i(r+1,c)) = -1;
                b(pi) = b(pi) + Vpq2;
            else 
                b(pi) = b(pi) + knownf(r+1,c) + Vpq2;
            end
          
            %The left neighbour  
            Vpq3 = source_I(source_x,source_y) - source_I(source_x,source_y-1);
            if(Omega_2(r,c-1) == 1)
                A(pi, unknow_i(r,c-1)) = -1;
                b(pi) = b(pi) + Vpq3;
            else 
                b(pi) = b(pi) + knownf(r,c-1) + Vpq3; 
            end
          
            %The right neighbour
            Vpq4 = source_I(source_x,source_y) - source_I(source_x,source_y+1);
            if(Omega_2(r,c+1) == 1)
                A(pi, unknow_i(r,c+1)) = -1;
                b(pi) = b(pi) + Vpq4;
            else 
                b(pi) = b(pi) + knownf(r,c+1)+Vpq4; 
            end
            %since Np is the set of its 4-connected neighbors, and all the
            %neighbors is inside the boundary in this case.
            %Then the |Np| is 4.
            A(pi,pi) = 4;
          pi = pi +1;
         
      end
   end
end

 
% Solve SLE: Ax = b
x = A\b;
% Show our result
imgresult = knownf;
 
for i = 1:Omega_num
    imgresult(Omega_i(i)) = x(i);
end
 
imgresult = uint8(imgresult);
figure;
imshow(imgresult);
title('Result of Task2a-importing gradient Seamless cloning');
 