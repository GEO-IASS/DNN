
function net = cnn1Dsetup(net, x, y)
    inputmaps = 1;
    % mapsize is 28 x 28 when input is 2D-image, time frame (100) when input
    % is 1D-time series. row -> frame length, col -> # of records. 
    mapsize = size(x, 1);
    % 
    
    for l = 1 : numel(net.layers)   %  layer
        if strcmp(net.layers{l}.type, 's')
            mapsize = mapsize / net.layers{l}.scale;

            % mapsize must be a integer, so scale is selected carefully.
            disp(['l=' num2str(l) ', mapsize=' num2str(mapsize)])
            
            assert(all(floor(mapsize)==mapsize), ['Layer ' num2str(l) ' size must be integer. Actual: ' num2str(mapsize)]);
            for j = 1 : inputmaps
                net.layers{l}.b{j} = 0;
            end
        end
        if strcmp(net.layers{l}.type, 'c')
            mapsize = mapsize - net.layers{l}.kernelsize + 1;
            fan_out = net.layers{l}.outputmaps * net.layers{l}.kernelsize; % 1D-time series, so square is not necessary.
           
            disp(['l=' num2str(l) ',mapsize=' num2str(mapsize) ]);
            for j = 1 : net.layers{l}.outputmaps  %  output map
                fan_in = inputmaps * net.layers{l}.kernelsize; % 1D-time series, so square is not necessary.
                for i = 1 : inputmaps  %  input map
                    % make sure it's correct.
                    net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize, 1) - 0.5) * 2 * sqrt(6 / (fan_in + fan_out));
                end
                net.layers{l}.b{j} = 0;
            end
            inputmaps = net.layers{l}.outputmaps;
        end
    end
    % 'onum' is the number of labels, that's why it is calculated using size(y, 1). If you have 20 labels so the output of the network will be 20 neurons.
    % 'fvnum' is the number of output neurons at the last layer, the layer just before the output layer.
    % 'ffb' is the biases of the output neurons.
    % 'ffW' is the weights between the last layer and the output neurons. Note that the last layer is fully connected to the output layer, that's why the size of the weights is (onum * fvnum)
    fvnum = mapsize * inputmaps;
    
    onum = size(y, 1);
%     add a hidden layer at last, instead of original perceptron.
    hvnum = fvnum;
    net.hfb = zeros(hvnum, 1);
    net.hfW = (rand(hvnum, fvnum) - 0.5) * 2 * sqrt(6 / (hvnum + fvnum));
    
    disp(['fvum=' num2str(fvnum) ',mapsize=' num2str(mapsize) ',inputmaps=' num2str(inputmaps)])

    net.ffb = zeros(onum, 1);
    net.ffW = (rand(onum, hvnum) - 0.5) * 2 * sqrt(6 / (onum + hvnum));

%   original perceptron.
%     disp(['fvum=' num2str(fvnum) ',mapsize=' num2str(mapsize) ',inputmaps=' num2str(inputmaps)])
% 
%     net.ffb = zeros(onum, 1);
%     net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));
    
end
