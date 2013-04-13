function net = cnnKDff(net, x)

    % For each component, convolute and sub-sample.
    for ci = 1 : numel(net.comp)
       
        % n is the number of layer.
        n = numel(net.comp{ci}.layers);
        % first layer is the training data, z = (W[][] * a + b), f(z) is new a.
        % 256 x 50,
        
        net.comp{ci}.layers{1}.a{1} = x(((ci - 1) * net.frame + 1) : ci*net.frame, :);

        % first layer regardes as a single filter map.
        inputmaps = 1;

        for l = 2 : n   %  for each layer, l starts at 2.
            if strcmp(net.comp{ci}.layers{l}.type, 'c')
                %  !!below can probably be handled by insane matrix operations
                for j = 1 : net.comp{ci}.layers{l}.outputmaps   %  for each output map
                    %  create temp output map.
                    %  calculate the size of image of next layer:
                    %  256 x 50 -> 256-5+1 -> 252 x 50.
                    z = zeros(size(net.comp{ci}.layers{l - 1}.a{1}) - [net.comp{ci}.layers{l}.kernelsize - 1 0]);
                    % disp(['z size=' num2str(size(z))])
                    for i = 1 : inputmaps   %  for each input map, all maps connected layer l node j.
                        %  convolve with corresponding kernel and add to temp output map
                        %     disp(['a{i} size=' num2str(size(net.layers{l - 1}.a{i}))])
                        z = z + convn(net.comp{ci}.layers{l - 1}.a{i}, net.comp{ci}.layers{l}.k{i}{j}, 'valid');
                    end
                    %  add bias, pass through nonlinearity, 256 x 50.
                    net.comp{ci}.layers{l}.a{j} = sigm(z + net.comp{ci}.layers{l}.b{j});
                end
                %  set number of input maps to this layers number of outputmaps
                inputmaps = net.comp{ci}.layers{l}.outputmaps;
            elseif strcmp(net.comp{ci}.layers{l}.type, 's')
                %  downsample
                for j = 1 : inputmaps
                    % average of pixel values of sub-frame with length 5.
                    % disp(['a{j} size=' num2str(size(net.layers{l - 1}.a{j}))])
                    z = convn(net.comp{ci}.layers{l - 1}.a{j}, ones(net.comp{ci}.layers{l}.scale, 1) / net.comp{ci}.layers{l}.scale, 'valid');   %  !! replace with variable
                    % disp(['z size=' num2str(size(z))])

                    % sub-sample by scale.
                    net.comp{ci}.layers{l}.a{j} = z(1 : net.comp{ci}.layers{l}.scale : end, :);
                    %disp(['new a{j} size=' num2str(size(net.layers{l}.a{j}))])
                end
                %   sub-sampling layer doesn't change inputmaps/outputmaps.
            end
        end
    end

    %  concatenate all end layer feature maps into vector
    net.fv = [];
    % All components' all layers output maps concatenate together as a
    % vector.
    for ci = 1 : numel(net.comp)
        n = numel(net.comp{ci}.layers);
        % Totally, net.comp{ci}.fvnum.
        for j = 1 : numel(net.comp{ci}.layers{n}.a)
            sa = size(net.comp{ci}.layers{n}.a{j});
            % () x 50
            net.fv = [net.fv; reshape(net.comp{ci}.layers{n}.a{j}, sa(1), sa(2))];
        end
    end
    
    %disp(['net.fv size=' num2str(size(net.fv))])
    %  feedforward into output perceptrons

    % add a hidden layer at last, instead of original perceptron.
    net.ho = sigm(net.hfW * net.fv + repmat(net.hfb, 1, size(net.fv, 2)));

    % softmax calculation.
    tmpsv = exp(net.ffW * net.ho + repmat(net.ffb, 1, size(net.ho, 2)));
    % disp(size(net.ffW * net.ho + repmat(net.ffb, 1, size(net.ho, 2))));
    %disp(tmpsv);
    % sum by col, yes, 1 means sum by col.
    % bsxfun(@rdivide, a, b)
    net.o = bsxfun(@rdivide, tmpsv, sum(tmpsv, 1));
    %disp(size(net.o));
    % disp(size(net.o));
    % disp(['sum of softmax' num2str(sum(tmpsv, 2))]);
    %   original perceptron.
    %    net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)));

end
