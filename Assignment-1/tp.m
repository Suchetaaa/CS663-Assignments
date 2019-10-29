% function CLAHE_Output = myCLAHE(path_input, window_size, chop_off)
    window_size = 21;
	image_input = imread('TEM.png');
	size_image = size(image_input);
    height = size_image(1, 1);
    width = size_image(1, 2);
    if size_image(1, 3) == 3 
        channels = 3;
    else 
        channels = 1;
    end
    % image_input = imresize(image_input, [height, width, channels]);
	nb_size = window_size/2;
	final_image = zeros(height, width ,channels, 'double');
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

	%CLAHE_Output = final_image;
	imshow(final_image);
	title('CLAHE output with window size', window_size, 'and chop off', chop_off);

	function chopped_cdf = chop_hist(square, chop_off)
	sum = double(0);
    chop_adaptive = chop_off * double(numel(square));
	hist_square = imhist(square);
	    for i = 1:256
	        if hist_square(i) > chop_adaptive
	            sum = sum + (hist_square(i) - chop_adaptive);
	            hist_square(i) = chop_adaptive;
	        end
	    end
	    hist_square = hist_square + (sum/numel(square));
	    chopped_cdf = cumsum(hist_square)/numel(square);
	end
%end