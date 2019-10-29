data = load('image_low_frequency_noise.mat');
A = data.Z;
h = size(A, 1);
imtool(mat2gray(A))
Arr = padarray(A, [h/2, h/2], 0, 'both');
Arr_fft = fft2(Arr);
Arr_fft_shift = fftshift(Arr_fft); 
Flog = log(abs(Arr_fft_shift) + 1);
imagesc(Flog); colormap(gray); 
title('magnitude spectrum');
impixelinfo
% impixelinfo(Flog)
% impixelinfo(hparent,himage);
% htool = impixelinfo(___);
% noisy_f = [247, 237; 267, 277]; % Observed
% viscircles(noisy_f, [8; 8]);

Notch = ones(5,5);
x_0 = 3;
y_0 = 3;
for x = x_0-2:x_0+2
    for y = y_0-2:y_0+2
        if ((x_0-x).^2 + (y_0-y).^2 <= 4)
            Notch(x,y) = 0;
        end
    end
end
notch_filter = ones(size(Flog));
x1 = 237;
y1 = 247;
x0 = 277;
y0 = 267;

notch_filter(x0-2:x0+2 , y0-2:y0+2) = Notch;
notch_filter(x1-2:x1+2 , y1-2:y1+2) = Notch;

% imagesc(Arr_fft_shift.*notch_filter); colormap(gray); 
% title('spectrum');
% impixelinfo

img_rec_pad = ifft2(ifftshift(Arr_fft_shift.*notch_filter));
img_rec = img_rec_pad(h/2+1:3*h/2, h/2+1:3*h/2);
imshow(mat2gray(img_rec))
