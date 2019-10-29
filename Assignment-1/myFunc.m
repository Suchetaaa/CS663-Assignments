%Output = myLC('barbara.png');
HM = myAHE('TEM.png', 21);

function LC_Output = myLC(path_image)

	input = double(imread(path_image));
	output = zeros(size(input), 'double');
	Size = size(input);
	k=0;
	if (Size(1,2) == 3 )
	    k = 3;
	else 
	    k = 1;
	end
	for i = 1:k
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
	imshow(output);
	input = uint8(input);

	myNumOfColors = 255;
	myColorScale = [ [0:1/(myNumOfColors-1):1],[0:1/(myNumOfColors-1):1],[0:1/(myNumOfColors-1):1] ];
	subplot(1,2,1);
	imshow(input);
	title('Input')
	subplot(1,2,2);
	imshow (output);
	title('Output')
	colormap (myColorScale);
	colormap jet;
	daspect ([1 1 1]);
	axis tight;
	colorbar 

end

function HM_Image = myHM(path_reference, path_reference_mask, path_input, path_input_mask)
	[reference_image,map] = imread(path_reference);
	input_image = imread(path_input);
	reference_mask = imread(path_reference_mask);
	input_image_mask = imread(path_input_mask);
	[length, width, channels] = size(input_image);
	zeros_ref = nnz(~reference_mask);
	zeros_input = nnz(~input_image_mask);
	final_image = zeros(length, width, channels, 'uint8');

	for i = 1:3
	    reference_one_channel = reference_image(:, :, i);
	    reference_one_channel(reference_mask == 0) = 0;
	    cdf_reference_one_channel = (cumsum(imhist(reference_one_channel))-zeros_ref)/(numel(reference_one_channel) - zeros_ref);
	    input_one_channel = input_image(:, :, i);
	    input_one_channel(input_image_mask == 0) = 0;
	    cdf_input_one_channel = (cumsum(imhist(input_one_channel)) - (zeros_input))/(numel(input_one_channel) - zeros_input);
	    Mapping = zeros(256, 1, 'uint8');
	    for k = 1:256 
	        Mapping(k) = inv(cdf_input_one_channel(k), cdf_reference_one_channel);
	    end 
	    output_one_channel = Mapping(double(input_one_channel) + 1);
	    final_image(:, :, i) = output_one_channel;
	end

	HM_Image = final_image;
% 	imshow(final_image);
% 	title('Histogram Matched Image');

	function p = inv (cdf_reference, cdf_input_a)
	    [~, index] = min(abs(cdf_input_a - cdf_reference));
	    p = index - 1;
	end
end 

function HE_retina = myHE_Retina(path_input, path_input_mask)
	retina = imread(path_input);
	retinaMask = imread(path_input_mask);
	I_Image = retina;
	I_mask = retinaMask;

	% function O_Image = HE(I_Image, I_mask) 
	% I_Image = imread(path_image);
	O_Image = zeros(size(I_Image), 'uint8');
	% I_mask = imread(path_mask);
	for k = 1:3
	    SIZE = size(I_Image(:,:,k));
	    one_channel = I_Image(:, :, k);
	    one_channel(I_mask == 0) = 0;
	    zeros_mask = nnz(~I_mask);
	    A = (cumsum(imhist(one_channel))) - zeros_mask;
	    SUM = double(numel(one_channel) - zeros_mask);
	    A = A/SUM;
	    O_Image(:, :, k) = uint8((A(double(one_channel)+1))*255) ;      
	    

	end
	HE_retina = O_Image;
% 	imshow(HE_retina);
% 	title('Histogram Equalisation on Retina');

end

function AHE_Output = myAHE(path_input, window_size)

	I_Image = imread(path_input);
	N = window_size;
	SIZE = size(I_Image(:,:,1));
	c = size(size(I_Image));
	if (c(1,2) ~= 3  )
	    a = 1;
	else 
	    a = 3;
	end

	O_Image = zeros(size(I_Image), 'uint8');
	for k = 1:a
	    C = I_Image(:,:,k);
	    
	    for i = 1:SIZE(1,1)
	    % Creating the window for AHE
	        for j = 1:SIZE(1,2)
	            i_start = round(i - N/2) ;
	            i_end = round(i + N/2) ;
	            j_start = round(j - N/2);
	            j_end = round(j+ N/2);
	            if (i_start < 1)
	                    i_start = 1;
	            end
	            if (i_end > SIZE(1,1))
	                    i_end = SIZE(1,1);
	            end
	            if (j_start < 1)
	                j_start = 1;
	            end
	            if (j_end > SIZE(1,2))
	                j_end = SIZE(1,2);
	            end
	            
	            %%%% Applying the histogram equalisation of the 
	            S = C(i_start:i_end, j_start: j_end);
	            O_Image(i,j,k) = histogram_equalisation(S, I_Image(i,j,k)); 
	        
	        end
	    end
	end

	function output_pixel = histogram_equalisation(I_Matrix, pixel)
	        hist = 0:255;
	        A = histcounts(I_Matrix, hist);
	        B = A;
	        SUM = sum(A);
	        A = A/SUM;
	        A = round(255*cumsum(A));
	        output_pixel = A(1,pixel+1);    
	end

	AHE_Output = O_Image;
 	imshow(AHE_Output);
% 	title('Adaptive Histogram Equalisation with window size', N);
end 

function HE_output = myHE(path_input)

	I_Image = imread(path_input);
	HE_output = zeros(size(I_Image), 'uint8');
	for k = 1:3
	    SIZE = size(I_Image(:,:,k));
	    hist = 0:255;
	    A = histcounts(I_Image(:,:,k), hist);
	    
	    %B = A;
	    SUM = sum(A);
	    A = A/SUM;
	    A = round(255*cumsum(A));
	    for i = 1:SIZE(1,1)
	        for j = 1:SIZE(1,2)
	             HE_output(i,j,k) = A(1,I_Image(i,j,k)+1) ;      
	           
	        end
	    end 
	end

% 	imshow(HE_output);
% 	title('Histogram Equalisation');

end

function CLAHE_Output = myCLAHE(path_input, window_size, chop_off)

	image_input = imread(path_input);
	size_image = size(image_input);
    height = size_image(1, 1);
    width = size_image(1, 2);
    if size(1, 3) == 3 
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

	CLAHE_Output = final_image;
% 	imtool(final_image);
% 	title('CLAHE output with window size', window_size, 'and chop off', chop_off);

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
end

