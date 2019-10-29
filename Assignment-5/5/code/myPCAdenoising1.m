function final_image = myPCAdenoising1()

input = imread('barbara256.png');
im = im2uint8(input);
im = double(im);
noise_var = 20.0;
im4 = im;
size_1 = size(input);
im1 = im + randn(size(im))*noise_var;
%imtool(mat2gray(im));
imtool(mat2gray(im1));
% PART A
siz = 250*250;
P = zeros(49,siz);
av_final = zeros(size_1);
i = 1;
for x=1:250
    for y=1:250
        x_end = x+6;
        y_end = y+6;
        A_i = im1(x:x_end, y:y_end);
        av_final(x:x_end, y:y_end) = av_final(x:x_end, y:y_end) + ones(7,7); 
        A_col = reshape(A_i, 49,1);
        P(:,i) = A_col;
        i = i+1;
    end
end

im_eval = P*(P.');
[V, D] = eig(im_eval);
coeff_matrix = (V.')*P;
coeff_denoised = zeros(size(coeff_matrix));
coeff_bar = max(0,(sum(coeff_matrix.^2, 2))/62500.0-(noise_var).^2);
for k = 1:49
    coeff_bar(k,1) = coeff_bar(k,1)/(coeff_bar(k,1) + noise_var.^2);
end
for j = 1:49
    coeff_denoised(j,:) = coeff_matrix(j,:)*coeff_bar(j,1);
end

im2 = V*coeff_denoised;
final_image = zeros(size_1);
k = 1;
for x = 1:250
    for y = 1:250
        Reform_mat = reshape(im2(:,k), 7,7);
        k = k+1;
        final_image(x:x+6, y:y+6)= final_image(x:x+6, y:y+6)+ Reform_mat; 
    end
end

% for x = 1:256
%     for y = 1:256
%         x_1 = max(1, x-6);
%         y_1 = max(1, y-6);
%         x_diff =  x +1 - x_1;
%         y_diff =  y +1 - y_1 ;
%         z = x_diff*y_diff;
%         if (z ==0)
%             z
%         end
%         
%         final_image(x,y) = final_image(x,y)/;
%         
%     end
% end
final_image = rdivide(final_image, av_final);

imtool(mat2gray(final_image))


end

