input_matrix = rand(20);
[U, S, V] = mySVD_final(input_matrix);
ssd = input_matrix - (U*S*V');
disp('Error between the original and reconstructed image=');
disp(norm(ssd));