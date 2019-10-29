% [output1, input] = myMeanShiftSegmentation('../data/baboonColor.png', 0.5, 0.1, 3, 30, 50);
% [output2, input] = myMeanShiftSegmentation('../data/baboonColor.png', 0.5, 0.1, 6, 30, 100);
% [output3, input] = myMeanShiftSegmentation('../data/baboonColor.png', 0.5, 0.1, 10, 30, 150);
% [output4, input] = myMeanShiftSegmentation('../data/baboonColor.png', 0.5, 0.1, 15, 30, 250);
% subplot(2, 2, 1), imshow(mat2gray(output1)); title('Sigma space = 3');
% subplot(2, 2, 2), imshow(mat2gray(output2)); title('Sigma space = 6');
% subplot(2, 2, 3), imshow(mat2gray(output3)); title('Sigma space = 10');
% subplot(2, 2, 4), imshow(mat2gray(output4)); title('Sigma space = 15');

function [segmented_image, input_image] = myMeanShiftSegmentation(path_input, resizing_factor, sigma_color, sigma_space, no_of_iter, no_of_nbs)
    input_image = im2double(imread(path_input));
    sigma = 0.5;
    smoothened_image = imfilter(input_image, fspecial('gaussian', 6*sigma, sigma));
    resized_image = imresize(smoothened_image, resizing_factor);
    [height, width, channels] = size(resized_image);
    intensities_image = reshape(resized_image, [height*width, 3]);
    width_vector = reshape(repmat([1:width], height, 1), width*height, 1);
    height_vector = repmat(transpose([1:height]), width, 1);
    vector = [intensities_image/sigma_color height_vector/sigma_space width_vector/sigma_space];

    reference_vector = vector;
    Z = vector;
    for i = 1:no_of_iter
        disp(i);
        [Idx, D] = knnsearch(reference_vector, reference_vector, 'k', no_of_nbs);
        for j = 1:height*width
            weights = exp(-(D(j, :).^2));
            weights = transpose(weights);
            weights_multiply = repmat(weights, 1, 3);
            denominator = sum(weights);
            numerator = sum(weights_multiply.*reference_vector(uint16(Idx(j, :)), 1:3));
            Z(j, 1:3) = numerator/denominator;
        end
        reference_vector = Z;
    end

    segmented_image = zeros(height, width, channels);
    for k = 1:height*width
        i = uint16(reference_vector(k, 4)*sigma_space);
        j = uint16(reference_vector(k, 5)*sigma_space);
        segmented_image(i, j, :) = reference_vector(k, 1:3);
    end
    segmented_image = imresize(segmented_image, 2);
end
    


