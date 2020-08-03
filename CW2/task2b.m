%show the mixing gradient

%load the source image 
I_source = imread('tu.jpeg');

%load the target image
I_target = imread('sky.jpeg');
%change to the gray scale 
I_source = rgb2gray(I_source);
I_target = rgb2gray(I_target);
%get rows and columns of the image
[srows,scols] = size(I_source);
[trows,tcols] = size(I_target);


 %Mark out a region using a polygon
 mask = roipoly(I_source);
 mask = double(mask);
 
 [strows, stcols] = ginput(1);
 strows = round(strows);
 stcols = round(stcols);
 % get the coordinates of the first point of the selected region.
 firstpoint=[min(strows),min(stcols)];
 
 %Get the index of pixels in the unknown region
 [row_m, col_m] = find(mask);
 
 
 % r_range is the row indices of unknown pixels in background image
 r_range=strows+row_m-firstpoint(1);
 % c_range is the col indices of unknown pixels in background image
 c_range=stcols+col_m-firstpoint(2);

 %Initialize the unkonwn index of target image
 mask_2 = zeros(trows,tcols);
 
 mask_2(sub2ind(size(I_target), r_range, c_range))=1;

 %Label our unknow destination image

 source_I = double(I_source);
 target_I = double(I_target);
 
 %Get the index of pixels in the unknown region
 dest_i = find(mask_2);
 dest_num = size(dest_i,1);
 
 unknow_i = zeros(trows,tcols);
 %Label our unknow destination image
 for i = 1:dest_num
     unknow_i(dest_i(i)) = i;
 end
 
 
 %Initialize the vector b
 b = zeros(dest_num,1);
 
 %Initialize the matrix A
 A = zeros(dest_num);
 
 %Initialize the matrix index pi
 pi = 1;
 %use loop
 for c = 1:tcols
    for r = 1:trows
        if(mask_2(r,c) == 1)
            %since Np is the set of its 4-connected neighbors, 
            %then the |Np| is 4.
            A(pi,pi) = 4;
             
            %next step, we need check if the four neighbors belongs to the
            %selected region.
            
            % x is the corresponding row index in source image 
            x=r-strows+firstpoint(1);
            % y is the corresponding column index in source image 
            y=c-stcols+firstpoint(2);
            
            
            %Vpq = f^*_p - f^*_q if |f^*_p - f^*_q| > |g_p - g_q|
            %Vpq = gp - gq otherwise
            
            
            
            %The up neighbour 
            if(abs(target_I(r,c) -target_I(r-1,c))) > (abs(source_I(x,y) -source_I(x-1,y)))
                Vpq1 = target_I(r,c) -target_I(r-1,c);
            else
                Vpq1 = source_I(x,y) - source_I(x-1,y);
            end
            
            if(mask(r-1,c) == 1)
                A(pi, unknow_i(r-1,c)) = -1;
                b(pi) = b(pi) + Vpq1;
            else 
                b(pi) = b(pi) + target_I(r-1,c)+Vpq1;
            end
          
            %The down neighbour
            if(abs(target_I(r,c) -target_I(r+1,c))) > (abs(source_I(x,y) -source_I(x+1,y)))
                Vpq2 = target_I(r,c) -target_I(r+1,c);
            else
                Vpq2 = source_I(x,y) - source_I(x+1,y);
            end
            
            if(mask(r+1,c) == 1)
                A(pi, unknow_i(r+1,c)) = -1;
                b(pi) = b(pi) + Vpq2;
            else 
                b(pi) = b(pi) + target_I(r+1,c)+Vpq2;
            end
          
            %The left neighbour
           if(abs(target_I(r,c) -target_I(r,c-1))) > (abs(source_I(x,y) -source_I(x,y-1)))
                Vpq3 = target_I(r,c) -target_I(r,c-1);
            else
                Vpq3 = source_I(x,y) - source_I(x,y-1);
            end
            
            if(mask(r,c-1) == 1)
                A(pi, unknow_i(r,c-1)) = -1;
                b(pi) = b(pi) + Vpq3;
            else 
                b(pi) = b(pi) + target_I(r,c-1)+Vpq3; 
            end
          
            %The right neighbour
            if(abs(target_I(r,c) -target_I(r,c+1))) > (abs(source_I(x,y) -source_I(x,y+1)))
                Vpq4 = target_I(r,c) -target_I(r,c+1);
            else
                Vpq4 = source_I(x,y) - source_I(x,y+1);
            end
            
            if(mask(r,c+1) == 1)
                A(pi, unknow_i(r,c+1)) = -1;
                b(pi) = b(pi) + Vpq4;
            else 
                b(pi) = b(pi) + target_I(r,c+1)+Vpq4; 
            end
          pi = pi +1;
         
        end
     end
 end
 
 
 % Solve SLE: Ax = b
 x = A\b;
 % Show our result
 imgresult = target_I;
 
 for i = 1:dest_num
     imgresult(dest_i(i)) = x(i);
 end
 
 imgresult = uint8(imgresult);
 figure;
 imshow(imgresult),title('Result of Task2');
 