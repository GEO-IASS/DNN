function cnn = test_example_CNNKD(gen_x, gen_y, test_x, test_y)

% gen_x = repmat(sin(0.1:0.1:25.6), 10000, 1)';
% gen_y = repmat([0 1]', 1, 10000);

%/Users/rt77789/code/R

% tri_matrix = load('/Users/rt77789/code/R/tri_matrix.data');
% sin_matrix = load('/Users/rt77789/code/R/sin_matrix.data');
% 
% [row, col] = size(tri_matrix);
% 
% gen_x = [tri_matrix(:, 1:(col-1)); sin_matrix(:, 1:(col-1))]';
% tri_y = zeros(2, row);
% sin_y = zeros(2, row);
% 
% for i = 1:row
%     tri_y(tri_matrix(i, col), i) = 1;
%     sin_y(sin_matrix(i, col), i) = 1;
% end
% 
% gen_y = [tri_y, sin_y];
% rnum = size(gen_x, 2);
% pos = randperm(rnum);
% gen_x = gen_x(:, pos);
% gen_y = gen_y(:, pos);


%% ex1 Train a 6c-2s-12c-2s Convolutional neural network 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error
rng(0)

comp.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 3, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
    
    %% more layers.
   % struct('type', 'c', 'outputmaps', 32, 'kernelsize', 4) %convolution layer
   % struct('type', 's', 'scale', 2) %sub sampling layer
   % struct('type', 'c', 'outputmaps', 64, 'kernelsize', 4) %convolution layer
   % struct('type', 's', 'scale', 2) %subsampling layer
};

frame = 256;
comps = [];

for i = 1 : (size(gen_x, 1) / frame)
    comps = [comps, cnnKDsetup1D(comp, gen_x( ((i-1)*frame + 1) : i*frame, :))];
end

cnn = cnnKDsetupKD(comps, gen_y);

opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 100;

cnn = cnnKDtrain(cnn, gen_x, gen_y, opts);


[er, bad] = cnnKDtest(cnn, test_x, test_y);

disp(['test error=' num2str(er)]);

%plot mean squared error
%figure; 
%plot(cnn.rL);
% hold on;
% for i = 1 : numel(cnn.layers{2}.a)
%     plot(cnn.layers{2}.a{i}(:,1)); 
% end
% hold off;
% figure;
% hold on;
% for i = 1 : numel(cnn.layers{4}.a)
%     plot(cnn.layers{4}.a{i}(:,1)); 
% end
% hold off;

% 6 x 2 x 13 x 2, epoch=1, error = 0.0116
% 

%assert(er<0.12, 'Too big error');


