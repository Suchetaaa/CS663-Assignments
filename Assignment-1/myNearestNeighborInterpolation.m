%%%%%%%%%%%%%Make this into a function
%%%%%%%%%%%%%%%Also make the aspect ratio of the display images 1:1

%input = imread('/home/neharika/Downloads/assignment1/Q1/data/barbaraSmall.png');
function output = myNearestNeighborInterpolation(input)


  m = size(input, 1);
  n = size(input,2);
  output = zeros(3*m-2, 2*n-1);
  for i = 1:(3*m-2),
    for j = 1:(2*n-1),
      if ((mod(i,3) == 1) && (mod(j,2) == 1))
        output(i,j) = input((i+2)/3, (j+1)/2);
      elseif ((mod(i,3) == 1) && (mod(j,2) == 0))
        output(i,j) = input((i+2)/3, (j)/2);
      elseif ((mod(i,3) == 2) && (mod(j,2) == 1))
        output(i,j) = input((i+1)/3, (j+1)/2);
      elseif ((mod(i,3) == 0) && (mod(j,2) == 1))
        output(i,j) = input((i+3)/3, (j+1)/2);
      elseif ((mod(i,3) == 2) && (mod(j,2) == 0))
        output(i,j) = input((i+1)/3, (j)/2);
      elseif ((mod(i,3) == 0) && (mod(j,2) == 0))
        output(i,j) = input((i+3)/3, (j)/2);
      end;
    end;
  end;




%input(1:10, 1:10)
%output(1:30, 1:20)

%output = nearest(input);

%sum(sum(output==output1(1:307, 1:205),1),2)
%output(:,:) = uint8((output(:,:)));
%imagesc(output)
%imshow(output)
%imshow(output1)

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

