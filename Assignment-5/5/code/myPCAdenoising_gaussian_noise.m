function output_image = myPCAdenoising_gaussian_noise()

im = imread('barbara256.png');
Size = size(im); 

im = im2uint8(im);
im = double(im);
im6 = im;
noise_var = 20.0;
im = im + randn(size(im))*20;
output_image = zeros(Size);
av_image = zeros(Size);

%  create window 31X31
window_size = 31;
for x = 1:Size(1,1)-6
    for y = 1:Size(1,2)-6
        x_start = x-(window_size-1)/2;
        x_end = x+(window_size-1)/2;
        y_start = y-(window_size-1)/2;
        y_end = y+(window_size-1)/2;
        
        if (x_start<1)
            x_start = 1;
            x_end = 1+window_size-1;
        end
        if (y_start<1)
            y_start = 1;
            y_end = 1+window_size-1;
        end
        if (x_end>Size(1,1))
            x_start = Size(1,1)-(window_size-1);
            x_end = Size(1,1);
        end
        if (y_end>Size(1,2))
            y_start = Size(1,2)-(window_size-1);
            y_end = Size(1,2);
        end
        
        im1 = im(x_start:x_end, y_start:y_end);
        a = x - x_start +1 ;
        b = y - y_start +1 ;
        im2 = im1(a:a+6, b:b+6);
        final_image = min_error_patch(im1,im2, noise_var);
        output_image(x:x+6, y:y+6) = output_image(x:x+6, y:y+6) + final_image;  
        av_image(x:x+6, y:y+6) = av_image(x:x+6, y:y+6) + ones(7,7);
    end
    x
end
output_image = rdivide(output_image, av_final);
a = output_image-im6;
sum_x = sum(sum(a.^2));
x = sum(sum(im6.^2));
a = sum_x/x

end
