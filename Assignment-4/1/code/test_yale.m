function [q, error] = test_yale(subject, picture_num, X_mean, eigen_vectors, eigenfaces)
%     subject = '11';
%     picture_num = 61;
    filename = strcat('../images/CroppedYale/yaleB', subject);
    files = dir(filename);
    filename_image = strcat('../images/CroppedYale/yaleB', subject, '/', files(picture_num+2, 1).name);
    test_image_matrix = imread(filename_image);
    probe_mean = double(reshape(test_image_matrix, [numel(test_image_matrix), 1])) - X_mean;
    probe_coefficients = transpose(eigen_vectors) * probe_mean;
    diff = eigenfaces - probe_coefficients;
    diff = diff.^2;
    ssd = sum(diff, 1);
    [~, d] = min(ssd);
    error = ssd(d);
    match_subject = ceil(d/40);
    if (match_subject >= 14)
        match_subject = match_subject + 1;
    end
    subject = str2num(subject);
    if (subject == match_subject)
        q = 'Matched';
    else
        q = 'Not matched';
    end
end
    
    
        