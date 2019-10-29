%% MyMainScript

tic;
%% Your code here
dataset = 'att_faces';
recognition_rate(dataset);
dataset = 'CroppedYale';
recognition_rate(dataset, 1);
dataset = 'CroppedYale';
recognition_rate(dataset, 2);
delete('eigen_vectors.mat');
delete('eigencoefficients.mat');
toc;
