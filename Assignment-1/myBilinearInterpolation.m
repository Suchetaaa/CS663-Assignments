%input = imread('/home/neharika/Downloads/assignment1/Q1/data/barbaraSmall.png');

function output = myBilinearInterpolation(input)
m = size(input, 1);
n = size(input,2);
M = 3*m;
N = 2*n;
output = zeros(M,N); 

%Y = zeros(H,W);
ms = (m/M);
ns = (n/N);
    for i=1:M
      y = (ms * i) + (0.5 * (1 - 1/3.0));
        for j=1:N
           x = (ns * j) + (0.5 * (1 - 1/2.0));
      %// Any values out of acceptable range
          x(x < 1) = 1;
          x(x > m - 0.001) = m - 0.001;
          x1 = floor(x);
          x2 = x1 + 1;
          y(y < 1) = 1;
          y(y > n - 0.001) = n - 0.001;
          y1 = floor(y);
          y2 = y1 + 1;
      %// 4 Neighboring Pixels
          NP1 = input(y1,x1);
          NP2 = input(y1,x2);
          NP3 = input(y2,x1); 
          NP4 = input(y2,x2);
      %// 4 Pixels Weights
          PW1 = (y2-y)*(x2-x);
          PW2 = (y2-y)*(x-x1);
          PW3 = (x2-x)*(y-y1);
          PW4 = (y-y1)*(x-x1);
          output(i,j) = PW1 * NP1 + PW2 * NP2 + PW3 * NP3 + PW4 * NP4;
        end;
    end;
%imwrite(output, "Bilinear.png")
output = output(1:M-2, 1:N-1);
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]',[0:1/(myNumOfColors-1):1]',[0:1/(myNumOfColors-1):1]' ];
subplot(1,2,1);
imagesc(input);
title('Input')
subplot(1,2,2);
imagesc(output);
title('Output')
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar
end