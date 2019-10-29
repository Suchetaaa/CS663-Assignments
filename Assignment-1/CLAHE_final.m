image_input = imread('church.png');
nb_size = 10;
final_image = zeros(1200, 1800, 3, 'uint8');
chop_off = 100;
global nb_size chop_off;

% input_one_channel = image_input(:, :, 1);
% print = imhist(input_one_channel);

for i = 1:3
    input_one_channel = image_input(:, :, i);
    for j = (nb_size+1):(1200 -(nb_size+1))
        for k = (nb_size+1):(1800 - (nb_size+1))
            square = input_one_channel(j-nb_size:j+nb_size, k-nb_size:k+nb_size);
            pixel_value = input_one_channel(j, k);
            final_image(j, k, i) = clahe(square, pixel_value);
        end
    end
end

colormap gray
final_image = final_image*255;
imshow(final_image);

function p = clahe(square, pixel_value)
    chopped_cdf =  chop_hist(square, 10);
    p = chopped_cdf(pixel_value+1);
end

function chopped_cdf = chop_hist(square, chop_off)
sum = double(0);
hist_square = imhist(square);
    for i = 1:256
        if hist_square(i) > chop_off
            sum = sum + (hist_square(i) - chop_off);
            hist_square(i) = chop_off;
        end
    end
    hist_square = hist_square + (sum/numel(square));
    chopped_cdf = cumsum(hist_square)/double(numel(square));
end
    
    
    