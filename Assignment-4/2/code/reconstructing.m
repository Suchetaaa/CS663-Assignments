function [ ] = reconstructing()
    k_values = [2, 10, 20, 50, 75, 100, 125, 150, 175];
    k2_values = 1:25;
    file_name = strcat('../images/yaleB29_P00A-025E+00.pgm');
    image_matrix = imread(file_name);
    imshow(image_matrix);
    X = zeros(192, 168, numel(k_values));
    Y = zeros(192, 168, numel(k2_values));

    load('mean_X.mat');
    load('eigencoefficients.mat');
    load('eigen_vectors.mat');

    figure;
    for i = 1:numel(k_values)
        probe_mean = double(reshape(image_matrix, [numel(image_matrix), 1])) - X_mean;
        eigen_vectors_k = eigen_vectors(:, k_values(i));
        probe_coefficients = transpose(eigen_vectors_k) * probe_mean;
        reconstructed_image = sum(transpose(probe_coefficients).*(eigen_vectors_k), 2);
        X(:, :, i) = reshape(reconstructed_image, 192, 168);
        subplot(2,5,i);
        imshow(mat2gray(X(:, :, i)));
        label = ['k = ', num2str(k_values(i))];
        title(label);
    end

    subplot(2, 5, 10);
    imshow(image_matrix);
    title('Original Image');

    for i = 1:25
        Y(:, :, i) = reshape(eigen_vectors(:, i), 192, 168);
    end

    figure;
    for i = 1:9
        subplot(3, 3, i);
        imshow(mat2gray(Y(:, :, i)));
        label = ['k = ', num2str(i)];
        title(label);
    end

    figure;
    for i = 10:25
        subplot(4, 4, i-9);
        imshow(mat2gray(Y(:, :, i)));
        label = ['k = ', num2str(i)];
        title(label);
    end
end