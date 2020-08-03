function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(row, col,...
    patchSize, searchWindowSize,image)

% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsRows(1) = -1;
% offsetsCols(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset
%store the distance 

%create the array for rows,cols and distances. And we know we should return
%all the rows,cols and distances in the search window.
offsetsRows = zeros(searchWindowSize ^ 2, 1);
offsetsCols = zeros(searchWindowSize ^ 2, 1);
distances = zeros(searchWindowSize ^ 2, 1);


%REPLACE THIS


%suppose our patchsize is 3, then we will get a 3*3 patch window. If our
%patchsize is 2(even number), we still get a 3*3 patch window.
patw = floor(patchSize/2);
%create a patch size window(reference patch or template) for the pixel centered in the input of (row,col)
%centerpat = image(row -patw:row +patw,col-patw:col+patw,:);
centerpat = image(row -patw:row +patw,col-patw:col+patw);



%create a search window with searchWindowsize * searchWindowsize
i = 1;
 for k = -floor(searchWindowSize/2):floor(searchWindowSize/2)
     for w = -floor(searchWindowSize/2):floor(searchWindowSize/2)
             %store the coordinates of our offset
             offsetsRows(i) = k;
             offsetsCols(i) = w;
             %create a patch size window for every pixel in the search
             %window
             %pixelpat = image(row + k - patw:row + k + patw, col + w - patw:col + w + patw,:);
             pixelpat = image(row + k - patw:row + k + patw, col + w - patw:col + w + patw);
             %compute the distance between the pixel centered in the search
             %and every pixel in the search window.
             %distances(i) = sum(sum(sum((centerpat - pixelpat).^2)));
             distances(i) = sum(sum((pixelpat - centerpat).^2));
             i = i + 1;
     end
 end
end