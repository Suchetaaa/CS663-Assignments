retina = imread('retina.png');
retinaMask = imread('retinaMask.png');
I_Image = retina;
I_mask = retinaMask;

% function O_Image = HE(I_Image, I_mask) 
% I_Image = imread(path_image);
O_Image = zeros(size(I_Image), 'uint8');
% I_mask = imread(path_mask);
for k = 1:3
    SIZE = size(I_Image(:,:,k));
    one_channel = I_Image(:, :, k);
    one_channel(I_mask == 0) = 0;
    zeros_mask = nnz(~I_mask);
    A = (cumsum(imhist(one_channel))) - zeros_mask;
    SUM = double(numel(one_channel) - zeros_mask);
    A = A/SUM;
    O_Image(:, :, k) = uint8((A(double(one_channel)+1))*255) ;      
    

end
cropped_image = O_Image(:, :, 1);
imshow(O_Image);