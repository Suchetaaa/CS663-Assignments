function [q, error] = test(dataset, subject, picture_num)
%     dataset = 'att_faces';
%     subject = 10;
%     picture_num = 10;
    filename = strcat('../images/', dataset, '/s', num2str(subject), '/', num2str(picture_num), '.pgm');
    test_image_matrix = imread(filename);
    load('mean_X.mat');
    load('eigencoefficients.mat');
    load('eigen_vectors.mat');
    probe_mean = double(reshape(test_image_matrix, [numel(test_image_matrix), 1])) - X_mean;
    probe_coefficients = transpose(eigen_vectors) * probe_mean;
    diff = eigenfaces - probe_coefficients;
    diff = diff.^2;
    ssd = sum(diff, 1);
    [~, d] = min(ssd);
    error = ssd(d);
    match_subject = ceil(d/6);
    if (subject == match_subject)
        q = 'Matched';
    else
        q = 'Not matched';
    end
end
    
    
        