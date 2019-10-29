%% MyMainScript

tic;
load('../data/barbara.mat');
input = imageOrig;
%input, std_space, std_intensity
[output, noise_image] = myBilateralFiltering(input,7.44, 2.22);
distance = sum(sum( ((output - input).^2)  ));
distance = sqrt(distance);
imshow([mat2gray(input), mat2gray(noise_image), mat2gray(output)]);
title('Input, Noisy Image and Bilateral Filtered Image')
daspect ([1 1 1]);  
axis tight;  
colorbar

% bestDistance=17045913600;
% best_std_space=1;
% best_std_intensity=1;
% fileID = fopen('hyperp1.txt', 'a');
% fprintf(fileID, '--------------------------------------------------\n');
% std_space_values = linspace(55.5,57.5,10) ;
% std_intensity_values =linspace(2.5,5,10);
% for i= std_space_values %insert the range of std_space
%     for j=std_intensity_values  %insert the range of std_intensity
%         output = myBilateralFiltering(input, i, j);
%          output1 = imrotate(output, 270);
%          output1 = flipdim(output1, 2);
%         distance = sum(sum( ((output1 - input).^2)  ));
%         if (distance < bestDistance)
%             best_std_space = i;
%             best_std_intensity = j;
%             bestDistance = distance;
%             
%             fprintf(fileID,'%f, %f, %f\n',i,j,distance);
%             
%         end
%     end
% end
% fclose(fileID);


toc;
