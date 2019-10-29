 function [q, false_negative, false_positive, error] = false_pn(threshold)
    %threshold = 42000;
    false_positive = 0;
    false_negative = 0;
    train_images = 6;
    load('mean_X.mat');
    load('eigencoefficients.mat');
    load('eigen_vectors.mat');
    for sub = 1:40
        for i = train_images+1:10
            filename = strcat('../images/att_faces/s', num2str(sub), '/', num2str(i), '.pgm');
            test_image_matrix = imread(filename);
            probe_mean = double(reshape(test_image_matrix, [numel(test_image_matrix), 1])) - X_mean;
            probe_coefficients = transpose(eigen_vectors) * probe_mean;
            diff = eigenfaces - probe_coefficients;
            diff = diff.^2;
            ssd = sum(diff, 1);
            [~, d] = min(ssd);
            ssd = ssd/170.0;
            error = ssd(d);
            match_subject = ceil(d/6);
            if (error >= threshold)
                if (sub == match_subject && sub <= 32)
                    q = 'Not available';
                    false_negative = false_negative + 1;
                end
            end
            if (error < threshold && sub > 32)
                false_positive = false_positive + 1;
            end
        end
    end
 end