[reference_image,map] = imread('retinaRef.png');
input_image = imread('retina.png');
reference_mask = imread('retinaRefMask.png');
input_image_mask = imread('retinaMask.png');
[length, width, channels] = size(input_image);
zeros_ref = nnz(~reference_mask);
zeros_input = nnz(~input_image_mask);
final_image = zeros(length, width, channels, 'uint8');

for i = 1:3
    reference_one_channel = reference_image(:, :, i);
    reference_one_channel(reference_mask == 0) = 0;
    cdf_reference_one_channel = (cumsum(imhist(reference_one_channel))-zeros_ref)/(numel(reference_one_channel) - zeros_ref);
    input_one_channel = input_image(:, :, i);
    input_one_channel(input_image_mask == 0) = 0;
    cdf_input_one_channel = (cumsum(imhist(input_one_channel)) - (zeros_input))/(numel(input_one_channel) - zeros_input);
    Mapping = zeros(256, 1, 'uint8');
    for k = 1:256 
        Mapping(k) = inv(cdf_input_one_channel(k), cdf_reference_one_channel);
    end 
    output_one_channel = Mapping(double(input_one_channel) + 1);
    final_image(:, :, i) = output_one_channel;
end
imshow(final_image);

function p = inv (cdf_reference, cdf_input_a)
    [~, index] = min(abs(cdf_input_a - cdf_reference));
    p = index - 1;
end







    


   