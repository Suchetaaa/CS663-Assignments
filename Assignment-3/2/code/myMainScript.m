
[output, input] = myMeanShiftSegmentation('../data/baboonColor.png', 0.5, 0.1, 10, 30, 250);
subplot(1, 2, 1), imshow((input)); title('Input Image');
subplot(1, 2, 2), imshow(mat2gray(output)); title('Segmented Image');
