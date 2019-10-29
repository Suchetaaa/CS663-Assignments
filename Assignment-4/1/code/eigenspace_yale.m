function eigenfaces = eigenspace_yale(k, plot_num)
    
    
    %X holds all the x vectors -- d x N matrix 
    dataset = 'CroppedYale';
    height = 192;
    breadth = 168;
    subjects1 = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"];
    subjects2 = 15:39;
    subjects = [subjects1, subjects2];
    train_images = 40;
    j = 1;
    X = zeros(height*breadth, numel(subjects)*train_images);
    for i=subjects
        disp(i);
        for a=3:train_images+2
            files = dir(strcat('../images/', dataset, '/yaleB', num2str(i)));
            filename = strcat('../images/', dataset, '/yaleB', num2str(i), '/', files(a, 1).name);
            image_matrix = imread(filename);
            X(:, j) = reshape(image_matrix, [numel(image_matrix), 1]);
            j = j + 1;
        end
    end
    

    X_mean = sum(X, 2)/double(numel(subjects)*train_images);
    X = X - X_mean;
    L = transpose(X)*X;
    [~, S, V] = svd(L);
    [~, permutation] = sort(diag(S), 'descend');
    S = S(permutation, permutation);
    V = V(:, permutation);
    eigen_vectors = X*V;
    if (plot_num == 1)
        eigen_vectors = eigen_vectors(:, 1:k);
    else
        eigen_vectors = eigen_vectors(:, 4:k+3);
    end
    mag_eig = sqrt(sum(eigen_vectors.^2, 1));
    eigen_vectors = bsxfun(@rdivide, eigen_vectors, mag_eig);
    eigenfaces = transpose(eigen_vectors) * X;
    save('eigencoefficients.mat', 'eigenfaces');
    save('mean_X.mat', 'X_mean');
    save('eigen_vectors.mat', 'eigen_vectors');
end


    
    


