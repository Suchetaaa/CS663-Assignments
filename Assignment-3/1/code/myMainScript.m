load('../data/boat.mat')
input = im2double(imageOrig);
input = input./255.0;
%imtool(input)
EigenImage_1 = zeros(size(input));
EigenImage_2 = zeros(size(input));
 min(min(input))
[dy, dx] = meshgrid(-1:1, -1:1);
Size = size(input); 
vector = zeros(Size(1,1), Size(1,2), 15);
% parameters
sig = 0.01;
sigma = 3;
k = 0.03;
threshold = 0.015;
x = 3;
%%%% derivative matrix Ix and Iy
input = imgaussfilt(input, sig);
%imtool(input)
I_x = conv2(input, dx, 'same');
I_y = conv2(input, dy, 'same');

I_x2 = I_x.*I_x;
I_y2 = I_y.*I_y;
I_xy = I_x.*I_y;

%%%%% weight convolution matrix 

dim = max(1, 5);
m = dim; n = dim;
[h1, h2] = meshgrid(-(m-1)/2 :(m-1)/2, -(n-1)/2 :(n-1)/2 );
 v = exp(-(1.0)*(h1.^2 + h2.^2)/(2*sigma^2));
 sum_weight = sum(sum(v));
 v = v./sum_weight;

 % structure tensor
 I_X2 = conv2(I_x2, v, 'same');
 I_Y2 = conv2(I_y2, v, 'same');
 I_XY = conv2(I_xy, v, 'same');
 
 % harris corner measure
 for i = 1:Size(1,1)
     for j = 1:Size(1,2)
         C = [1, I_X2(i,j)+ I_Y2(i,j), (I_X2(i,j))*(I_Y2(i,j)) - (I_XY(i,j).^2)];
         Roots = roots(C);
        EigenImage_1(i,j) = min(Roots);
        EigenImage_2(i,j) = max(Roots);
     end
 end
 R = I_X2.*I_Y2 - I_XY.*I_XY  - k*(I_X2.^2 + I_Y2.^2 + 2*I_X2.*I_Y2);
 
 output_Image = ordfilt2(R, x.^2, true(x));
 final_image = (R == output_Image) & (R > threshold);
 
 [row,col] = find(final_image);
 figure, colormap(jet(10)), imshow(mat2gray(input)), hold on,
 plot(col, row, 'r^', 'MarkerSize', 3.5)
 
imtool(mat2gray(final_image)) 
imtool((I_x))
imtool(I_y)
imtool(mat2gray(EigenImage_1))
imtool(mat2gray(EigenImage_2))
histogram(R)