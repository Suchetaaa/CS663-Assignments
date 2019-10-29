%%%%%%%%%%%%%Make this into a function
%%%%%%%%%%%%%%%Also make the aspect ratio of the display images 1:1

function output = myShrinkImageByFactorD(input)
d=2.0;
final_shape_2 = (size(input))/d;
k=0;
result_2 = zeros((size(input))/d);
for i=1:final_shape_2(1,1),
  for j=1:final_shape_2(1,2),
    k = i*d-d+1; l=j*d-d+1;
    result_2(i,j) = input(k,l);
  end;
end;
d=3;
final_shape_3 = round((size(input))/d);


result_3 = zeros(final_shape_3);
for i=1:final_shape_3(1,1)
  for j=1:final_shape_3(1,2)
    k = i*d-d+1; l=j*d-d+1;
    result_3(i,j) = input(k,l);
  end;
end;

myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]',[0:1/(myNumOfColors-1):1]',[0:1/(myNumOfColors-1):1]' ];
%imwrite(result_2, jet, "ScaledBy2.png")
%imwrite(result_3, jet, "ScalesBy3.png")
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar

myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]',[0:1/(myNumOfColors-1):1]',[0:1/(myNumOfColors-1):1]' ];
subplot(2,2,1);
imagesc(input);
title('Input')
subplot(2,2,2);
imagesc(result_2);
%imtool(result_2 );
title('Output scaled by 2')
subplot(2,2,3);
imagesc(input);
title('Input')
subplot(2,2,4);
imagesc (result_3); 
title('Output scaled by 3')
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar
output = 0;
end