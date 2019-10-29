function final_image = min_error_patch(im,im2)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% we have a 31X31 window and a center point of a 7X7 patch under 
% observation we find the minimum error patches
    
% im = imread('barbara256.png');
% im = im2uint8(im);
% im = double(im);
% a = 32;
% b = 32;
noise_var = 0.25;
%im2 = im(a:a+6, b:b+6);
error_mat = zeros(25,25);
for x = 1:25
    for y = 1:25
        x_end = x+6;
        y_end = y+6;
        
        im3  = im(x:x_end, y:y_end);
        
        error_mat(x,y) = sum(sum((im2-im3).^2));
    end
end

A = reshape(error_mat, [625, 1]);
[B,permutation] = sort(A, 'ascend');
list = zeros(201,2);
for i = 2:201
    list(i,1) = mod(permutation(i),25);
    if (mod(permutation(i),25) == 0)
        list(i,2) = floor(permutation(i)/25);
    else
        list(i,2) = floor(permutation(i)/25)+1;
    end
    if (list(i,1) == 0)
        list(i,1) = 25;
    end
end
P = zeros(49,200);
for i =2:201
    x  = list(i,1);
    y  = list(i,2);
    x_end = x+6;
    y_end = y+6;
    im3  = im(x:x_end, y:y_end);
    A_col = reshape(im3, 49,1);
    P(:,i-1) = A_col;
end
im_eval = P*(P.');
[V, D] = eig(im_eval);
coeff_matrix = (V.')*P;
coeff_denoised = zeros(size(coeff_matrix));
coeff_bar = max(0,(sum(coeff_matrix.^2, 2))/200.0-(noise_var).^2);
for k = 1:49
    coeff_bar(k,1) = coeff_bar(k,1)/(coeff_bar(k,1) + noise_var.^2);
end
for j = 1:49
    coeff_denoised(j,:) = coeff_matrix(j,:)*coeff_bar(j,1);
end
im4 = V*coeff_denoised;
final_image = zeros(7,7);
k = 1;
x = 1;
y=1;
for k = 1:200
        Reform_mat = reshape(im4(:,k), 7,7);
        k = k+1;
        final_image(x:x+6, y:y+6)= final_image(x:x+6, y:y+6)+ Reform_mat; 
end
final_image = final_image/200;
end


