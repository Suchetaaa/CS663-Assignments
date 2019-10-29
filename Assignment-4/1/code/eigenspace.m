function eigenfaces = eigenspace(dataset, height, breadth, subjects, train_images, k)
    
    
    %X holds all the x vectors -- d x N matrix
    X = zeros(height*breadth, subjects*train_images); 

    j = 1;
    for i=1:subjects
        for a=1:train_images
            filename = strcat('../images/', dataset, '/s', num2str(i), '/', num2str(a), '.pgm');
            image_matrix = imread(filename);
            imshow(image_matrix);
            X(:, j) = reshape(image_matrix, [numel(image_matrix), 1]);
            j = j + 1;
        end
    end

    X_mean = sum(X, 2)/double(subjects*train_images);
    X = X - X_mean;
    L = transpose(X)*X;
    [V, D] = eig(L);
    [~, permutation] = sort(diag(D), 'descend');
    D = D(permutation, permutation);
    V = V(:, permutation);
    eigen_vectors = X * V;
    eigen_vectors = eigen_vectors(:, 1:k);
    squared_eig = eigen_vectors.^2;
    mag_eig = sqrt(sum(squared_eig, 1));
    eigen_vectors = eigen_vectors./mag_eig;
    eigenfaces = transpose(eigen_vectors) * X;
    save('eigencoefficients.mat', 'eigenfaces');
    save('mean_X.mat', 'X_mean');
    save('eigen_vectors.mat', 'eigen_vectors');
    %Multiply alphas(eigenfaces) with corresponding eigenvectors
end


    
    


