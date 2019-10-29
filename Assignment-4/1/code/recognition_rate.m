function [ ] = recognition_rate(dataset, plot_num)
    k_values_ORL = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
    k_values_Yale = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000];

    subjects_ORL = 32;
    train_images_ORL = 6;
    subjects_yale = 38;
    train_images_yale = 40;
    subjects1 = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"];
    subjects2 = 15:39;
    subjects_vector = [subjects1, subjects2];
    if (strcmp('att_faces', dataset))
        k_values = k_values_ORL;
        subjects = subjects_ORL;
        train_images = train_images_ORL;
        max = 10;
    else
        k_values = k_values_Yale;
        subjects = subjects_yale;
        train_images = train_images_yale;
        max = 60;
        counter = 0;
    end
    matched = zeros(1, numel(k_values));

    for i = 1:numel(k_values)
        disp(i);
        if (strcmp(dataset, 'att_faces'))
            p = eigenspace(dataset, 92, 112, subjects, train_images, k_values(i));
        else
            p = eigenspace_yale(k_values(i), plot_num);
        end
        for j = 1:subjects
            if (strcmp(dataset, 'att_faces'))
                for l = train_images+1:max
                    [q, error] = test(dataset, j, l);
                    if (strcmp('Matched', q))
                        matched(1, i) = matched(1, i) + 1;
                    end
                end
            else
                folder_subject = strcat('../images/CroppedYale/yaleB', num2str(subjects_vector(1, j)));
                files_subjects = dir(folder_subject);
                load('eigencoefficients.mat');
                load('eigen_vectors.mat');
                load('mean_X');
                for b = train_images+1:max
                    [q, error] = test_yale(num2str(subjects_vector(1, j)), b, X_mean, eigen_vectors, eigenfaces);
                    counter = counter + 1;
                    if (strcmp('Matched', q))
                        matched(1, i) = matched(1, i) + 1;
                    end
                end
            end

         end
    end

    total_images = subjects*((max)-train_images);
    if (strcmp(dataset, 'att_faces'))
        matched = (matched/double(total_images))*100;
    else
        matched = (matched/double(counter))*1700;
    end

    figure;
    plot(k_values, matched);
    title('Recognition Rate vs. k');
    xlabel('k');
    ylabel('Recognition Rate');
    axis on;
end

            
    
    