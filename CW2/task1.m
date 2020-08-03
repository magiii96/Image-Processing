%Blurring intepolation 
%load the  image 
I = imread('tu2.jpeg');

%change to the gray scale 
I_gray = rgb2gray(I);
%get rows and columns of the image
[rows,cols] = size(I_gray);

%Mark out a selection region using a polygon, denote by Ω Omega .
Omega = roipoly(I_gray);
Omega = double(Omega);

%Get the known sclar function f^*.
knownf = double(I_gray);
 
%Get the index of pixels in the selection region omega
Omega_i = find(Omega);
%Get the number of pixel in the selection region denote by the |Ω|
Omega_num = size(Omega_i,1);

%initialize unknow scalar function f 
unknow_i = zeros(rows,cols);
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
for c = 1:cols
   for r = 1:rows
       %If the pixel belong to the seletion region Omega.
       if(Omega(r,c) == 1)
            %Next step, we need check if the four neighbors belongs to the
            %selected region.
            
            %pj belong to the Npi and Omega 
            
            %The up neighbour 
            %Our neighbors belong to the selection region.
            if(Omega(r-1,c) == 1)
                A(pi, unknow_i(r-1,c)) = -1;
            %Our neighbors does not belong to the selection region, which
            %means the neighbor belong to the boundary. 
            else 
                %bpi = sum of known scalar function f + sum of Vpq.
                %but for task1, our Vpq is zero.
                b(pi) = b(pi) + knownf(r-1,c);
            end
          
            %The down neighbour
            if(Omega(r+1,c) == 1)
                A(pi, unknow_i(r+1,c)) = -1;
            else 
                b(pi) = b(pi) + knownf(r+1,c);
            end
          
            %The left neighbour  
            if(Omega(r,c-1) == 1)
                A(pi, unknow_i(r,c-1)) = -1;
            else 
                b(pi) = b(pi) + knownf(r,c-1); 
            end
          
            %The right neighbour
            if(Omega(r,c+1) == 1)
                A(pi, unknow_i(r,c+1)) = -1;
            else 
                b(pi) = b(pi) + knownf(r,c+1); 
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
imshow(imgresult),title('Result of Task1 - blurring interpolation');
 