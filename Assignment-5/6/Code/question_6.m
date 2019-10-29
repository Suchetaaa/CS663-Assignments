function [row, col] = question_6(translation_in_x, translation_in_y, noise_var)
%     translation_in_x = -30;
%     translation_in_y = 70;
%     noise_var = 0;
    I = zeros(300,300);
    I(50:99,50:119) = ones(50,70);
    I = I*255;
    I = I + randn(size(I))*noise_var;
    J = zeros(300,300);
    J(50+translation_in_x:99+translation_in_x,50+translation_in_y:119+translation_in_y) = ones(50,70);
    J = J*255;
    J = J + randn(size(J))*noise_var;
    J_f = fft2(J);
    I_f = fft2(I);
    a = (J_f.*conj(I_f));
    b = (J_f.*I_f);
    cross_power = a;
    inverse = ifft2(cross_power);
    val = max(max(inverse));
    [row, col] = find(inverse==val);
    T = ((J_f.*conj(I_f))./(abs(I_f.*J_f)));
    image = (log(abs(T) + 1));
    imshow(image);
    
end


