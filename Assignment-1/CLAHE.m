image_input = imread('church.png');
dimensions = size(image_input);
a = size(dimensions);
test = a(1,2);
if test == 2 
    channels = 1;
else 
    channels = 3;
end
height = dimensions(1, 1);
width = dimensions(1, 2);
window_size = 151;
nb_size = window_size/2;
final_image = zeros(height, width ,channels, 'double');
chop_off = 0.2;
global nb_size chop_off;

for i = 1:channels
    input_one_channel = image_input(:, :, i);
    for j = (1):(height)
        for k = (1):(width)
            left = max(1, k-nb_size);
            right = min(width, k+nb_size);
            top = max(1, j-nb_size);
            bottom = min(height, j+nb_size);
            square = input_one_channel(top:bottom, left:right);
            sq_hist = imhist(square);
            chopped_cdf =  chop_hist(square, chop_off);
            pixel_value = input_one_channel(j, k);
            final_image(j, k, i) = chopped_cdf(pixel_value + 1);
        end
    end
end
imshow(final_image);

function chopped_cdf = chop_hist(square, chop_off)
sum = double(0);
chop_adapted = double(chop_off) * numel(square);
hist_square = imhist(square);
    for i = 1:256
        if hist_square(i) > chop_adapted
            sum = sum + (hist_square(i) - chop_adapted);
            hist_square(i) = chop_adapted;
        end
    end
    hist_square = hist_square + (sum/numel(square));
    chopped_cdf = cumsum(hist_square)/numel(square);
end
    
    
    