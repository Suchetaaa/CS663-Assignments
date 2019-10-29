function [output, noise_image] = myBilateralFiltering(input, std_space, std_intensity)
%load('../data/barbara.mat');
%input = imageOrig;
% input = uint(input);
% imshow(input);
input = im2double(input);

maxintensity = double(max(max(input)));
minintensity = double(min(min(input)));
var_noise = double(0.05*(maxintensity - minintensity));
noise_image = input + sqrt(var_noise)*randn(size(input));

%std_space =  5 ;   %%%%%%%add standard deviation pertaining to space   
%std_intensity =5 ;%%%%%%add standard deviation pertaining to intensity
windowsize = 10;
spatial_mask = double(zeros(2*windowsize + 1, 2*windowsize + 1));
% 
for i=1:size(spatial_mask,1) % Weighted Spacial mask using normal distribution 
    for j=1:size(spatial_mask,2)
        spatial_mask(i,j) = (0.3984/std_space) * exp((-(i-windowsize-1)^2-(j-windowsize-1)^2)/(2*(std_space^2)));            
    end
end
% 
% 
%imtool(spatial_mask)

output = zeros(size(input, 1), size(input, 2));
for i=1:size(input,1)
    for j=1:size(input,2)
        leftMargin = max(j-windowsize , 1);

        rightMargin = min (j+windowsize , size(input,2));
        topMargin = max(i-windowsize, 1);
        bottomMargin = min (i+windowsize, size(input,1));
        lookat = noise_image(leftMargin:rightMargin, topMargin:bottomMargin);
                
        intensity_mask = exp(-(lookat-noise_image(i,j)).^2/(2*std_intensity^2));
        spatial_mask(( ((windowsize + 1) - (j - leftMargin)):(windowsize + 1 + rightMargin - j)), ( ((windowsize + 1) - (i - topMargin)):(windowsize + 1 + bottomMargin - i)) );
        temp = intensity_mask .* spatial_mask(( ((windowsize + 1) - (j - leftMargin)):(windowsize + 1 + rightMargin - j)), ( ((windowsize + 1) - (i - topMargin)):(windowsize + 1 + bottomMargin - i)) );
        
        output(i,j) = sum(temp(:).*lookat(:))/sum(temp(:));
    end
end


end