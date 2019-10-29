
%input = imread('/home/neharika/Downloads/assignment1/Q2/data/barbara.png');
%function output = myLinearContrastStretching(input)
input = double(imread('church.png'));
% input_one_channel = input(:, :, 1);
% imshow(input);
%input2 = typecast(input, float);
output = zeros(size(input), 'double');
Size = size(input);
k=0;
if (Size(1,2) == 3 )
    k = 3;
else 
    k = 1;
end
for i=1:k
    max_intensity = double(max(max(input(:,:,i))));
    min_intensity = double(min(min(input(:,:,i))));
 
    diff = double(max_intensity - min_intensity);
    Mapping = zeros(256, 1, 'double');
    for b = 1:256
        Mapping(b) = (255.0)*((b - 1) - min_intensity);
        Mapping(b) = Mapping(b)/diff;
    end
    output(:, :, i) = round(Mapping(double(input(:, :, i)) + 1));
end

output = uint8(output);
% imshow(output);
% input = uint8(input);

% myNumOfColors = 255;
% myColorScale = [ [0:1/(myNumOfColors-1):1],[0:1/(myNumOfColors-1):1],[0:1/(myNumOfColors-1):1] ];
% subplot(1,2,1);
imshow(input);
title('Input')
subplot(1,2,2);
imshow (output);
title('Output')
% colormap (myColorScale);
% colormap jet;
% daspect ([1 1 1]);
% axis tight;
% colorbar 