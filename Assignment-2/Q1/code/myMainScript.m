
[a, b, c, d] = Sharpening('../data/lionCrop.mat', 8, 1.1, 3);
subplot(2, 2, 1), imshow(a); title('Original Image before Linear Contrast');
subplot(2, 2, 2), imshow(b); title('Sharpened image before Linear Contrast');
subplot(2, 2, 3), imshow(c), colorbar; title('Original Image after Linear Contrast');
subplot(2, 2, 4), imshow(d), colorbar; title('Sharpened Image after Linear Contrast');

pause(10);
[a, b, c, d] = Sharpening('../data/superMoonCrop.mat', 7, 2, 2);
subplot(2, 2, 1), imshow(a); title('Original Image before Linear Contrast');
subplot(2, 2, 2), imshow(b); title('Sharpened image before Linear Contrast');
subplot(2, 2, 3), imshow(c), colorbar; title('Original Image after Linear Contrast');
subplot(2, 2, 4), imshow(d), colorbar; title('Sharpened Image after Linear Contrast');

function [image_original, final_image, image_LC, final_image_LC] = Sharpening(image_file, filter_size, standard_deviation, extent_of_sharpening)
    load(image_file);
    image_original = double(imageOrig);
    image = image_original;

    gaussian_filter = fspecial('gaussian', filter_size, standard_deviation);
    smoothened_image = imfilter(image, gaussian_filter);
    subtracted_image = (image_original - smoothened_image);
    final_image = image_original + extent_of_sharpening*subtracted_image; 
    
    image_LC = mat2gray(linearcontrast(image_original));
    final_image_LC = mat2gray(linearcontrast(final_image));
 
    
end
    
function output = linearcontrast(input)
        max_intensity = max(max(input));
        min_intensity = min(min(input));
        output = (input - min_intensity)*(255/(max_intensity - min_intensity));
end