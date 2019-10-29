function img_rec = ideal_low_pass(D)
im = imread('barbara256.png');
h = size(im, 1);

Arr = padarray(im, [h/2, h/2], 0, 'both');
%imtool(mat2gray(Arr))
Arr_fft = fft2(Arr);
Arr_fft_shift = fftshift(Arr_fft); 
Flog = log(abs(Arr_fft_shift) + 1);
Size = size(Flog);
Notch = zeros(Size);
x_0 = (Size(1,1)-1)/2;
y_0 = (Size(1,2)-1)/2;
for x = 1:Size(1,1)
    for y = 1:Size(1,2)
        if ((x_0-x).^2 + (y_0-y).^2 <= D.^2)
            Notch(y,x) = 1;
        end
    end
end
% imagesc(Arr_fft_shift.*Notch); colormap(gray); 
% title('spectrum');
% impixelinfo
% 
img_rec_pad = ifft2(ifftshift(Arr_fft_shift.*Notch));
img_rec = img_rec_pad(h/2+1:3*h/2, h/2+1:3*h/2);
%imshow(mat2gray(abs(img_rec)))
%mshow(mat2gray(log(abs(Arr_fft_shift.*Notch) + 1)));
end