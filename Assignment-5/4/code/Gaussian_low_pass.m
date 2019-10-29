function img_rec = Gaussian_low_pass(D)

im = imread('barbara256.png');
h = size(im, 1);
Arr = padarray(im, [h/2, h/2], 0, 'both');


Arr_fft = fft2(Arr);
Arr_fft_shift = fftshift(Arr_fft); 
Flog = log(abs(Arr_fft_shift) + 1);
Size = size(Flog);
%imshow(mat2gray(fspecial('gaussian',[10,10], 6)));
Notch = (fspecial('gaussian',Size, D));
% imagesc(Arr_fft_shift.*Notch); colormap(gray); 
% title('spectrum');
% impixelinfo
% 
img_rec_pad = ifft2(ifftshift(Arr_fft_shift.*Notch));
img_rec = img_rec_pad(h/2+1:3*h/2, h/2+1:3*h/2);
imshow(mat2gray(abs(img_rec)))

%imshow(mat2gray(log(abs(Arr_fft_shift.*Notch) + 1)));
end