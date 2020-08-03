%local color change.
%load the source image 
I_source = imread('tu2.jpeg');



%load the target image
I_target = I_source;

%Mark out a region using a polygon
mask = roipoly(I_source);

 
%seperate rgb channel of the color image.
I_source1 = I_source(:,:,1);
I_source2 = I_source(:,:,2);
I_source3 = I_source(:,:,3);
%change the color of image
I_sourcec1 = I_source(:,:,1) * 3.2;
I_sourcec2 = I_source(:,:,2) * 0.5;
I_sourcec3 = I_source(:,:,3) * 0.1;


imgresult = I_target;
imgresult(:,:,1) = importinggradient(I_sourcec1,I_source1,mask);
imgresult(:,:,2) = importinggradient(I_sourcec2,I_source2,mask);
imgresult(:,:,3) = importinggradient(I_sourcec3,I_source3,mask);

figure;
imshow(imgresult),title('Result of Task4');


function imgresult = importinggradient(I_source,I_target,Omega)

%get rows and columns of the image
[rows,cols] = size(I_target);

I_source = double(I_source);
%Get the known sclar function f^*.
knownf = double(I_target);
 
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
            Vpq1 = I_source(r,c) - I_source(r-1,c);
            %Our neighbors belong to the selection region.
            if(Omega(r-1,c) == 1)
                A(pi, unknow_i(r-1,c)) = -1;
                b(pi) = b(pi) + Vpq1;
            %Our neighbors does not belong to the selection region, which
            %means the neighbor belong to the boundary. 
            else 
                %bpi = sum of known scalar function f + sum of Vpq.
                %but for task1, our Vpq is zero.
                b(pi) = b(pi) + knownf(r-1,c)+Vpq1;
            end
          
            %The down neighbour
            Vpq2 = I_source(r,c) - I_source(r+1,c);
            if(Omega(r+1,c) == 1)
                A(pi, unknow_i(r+1,c)) = -1;
                b(pi) = b(pi) + Vpq2;
            else 
                b(pi) = b(pi) + knownf(r+1,c)+Vpq2;
            end
          
            %The left neighbour 
            Vpq3 = I_source(r,c) - I_source(r,c-1);
            if(Omega(r,c-1) == 1)
                A(pi, unknow_i(r,c-1)) = -1;
                b(pi) = b(pi) + Vpq3;
            else 
                b(pi) = b(pi) + knownf(r,c-1)+Vpq3; 
            end
          
            %The right neighbour
            Vpq4 = I_source(r,c) - I_source(r,c+1);
            if(Omega(r,c+1) == 1)
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

end




 