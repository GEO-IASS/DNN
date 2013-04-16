function [gen_x, gen_y] = gen_tri_sin_data()
% Generate triangle and sin waveforms.

tri_matrix = load('/Users/rt77789/code/R/tri_matrix.data');
sin_matrix = load('/Users/rt77789/code/R/sin_matrix.data');

[row, col] = size(tri_matrix);

gen_x = [tri_matrix(:, 1:(col-1)); sin_matrix(:, 1:(col-1))]';
tri_y = zeros(2, row);
sin_y = zeros(2, row);

for i = 1:row
    tri_y(tri_matrix(i, col), i) = 1;
    sin_y(sin_matrix(i, col), i) = 1;
end

gen_y = [tri_y, sin_y];
rnum = size(gen_x, 2);
pos = randperm(rnum);

gen_x = gen_x(:, pos);
gen_y = gen_y(:, pos);

% Normalize

for i = 1 : size(gen_y, 2)
   gen_x(:, i) = gen_x(:, i) - mean(gen_x(:, i));
   gen_x(:, i) = gen_x(:, i) / std(gen_x(:, i));
end
