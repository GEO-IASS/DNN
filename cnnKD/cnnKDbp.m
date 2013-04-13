function net = cnnKDbp(net, y)
    
   
    %  error, square cost function, softmax?
    net.e = net.o - y;
    %  loss function: 
    net.L = 1/2* sum(net.e(:) .^ 2) / size(net.e, 2);

    % softmax derivative.
    for i = 1 : size(y, 2)
        net.od(:, i) = (eye(size(y, 1)) - repmat(y(:, i), 1, size(y, 1))) * net.o(:, i);
    end
    %% backprop deltas
    % net.od = net.e .* (net.o .* (1 - net.o));   %  output delta, y^ 's delta.
    
    %% backprop for hidden layer.
    net.hod = (net.ffW' * net.od ) .* (net.ho .* (1 - net.ho));
    net.fvd = (net.hfW' * net.hod);              %  feature vector delta, x's delta.
    
    % original perceptron.
    % net.fvd = (net.ffW' * net.od);
    
    sum_fvnum = 1;
    
    for ci = 1 : numel(net.comp)

         % n is # of layers.
        n = numel(net.comp{ci}.layers);
        
        tmp_fv = net.fv(sum_fvnum : (sum_fvnum + net.comp{ci}.fvnum - 1));
        tmp_fvd = net.fvd(sum_fvnum : (sum_fvnum + net.comp{ci}.fvnum - 1), :);
        sum_fvnum = sum_fvnum + net.comp{ci}.fvnum;
        
        if strcmp(net.comp{ci}.layers{n}.type, 'c')         %  only conv layers has sigm function
            % net.fvnum 
            tmp_fvd = tmp_fvd .* (tmp_fv .* (1 - tmp_fv));
        end

        %  reshape feature vector deltas into output map style
        sa = size(net.comp{ci}.layers{n}.a{1});

        % 1-D vector reshape as 2-D matrice, from 732 x 50 to 12 61x50.
        fvnum = sa(1);
        for j = 1 : numel(net.comp{ci}.layers{n}.a)
            % 
            net.comp{ci}.layers{n}.d{j} = reshape(tmp_fvd(((j - 1) * fvnum + 1 ) : j * fvnum, :), sa(1), sa(2));
        end

        % 
        for l = (n - 1) : -1 : 1
            if strcmp(net.comp{ci}.layers{l}.type, 'c')
                for j = 1 : numel(net.comp{ci}.layers{l}.a)
                    net.comp{ci}.layers{l}.d{j} = net.comp{ci}.layers{l}.a{j} .* (1 - net.comp{ci}.layers{l}.a{j}) ...
                        .* (expand(net.comp{ci}.layers{l + 1}.d{j}, [net.comp{ci}.layers{l + 1}.scale 1])...
                        / net.comp{ci}.layers{l + 1}.scale);
                end
            elseif strcmp(net.comp{ci}.layers{l}.type, 's')
                for i = 1 : numel(net.comp{ci}.layers{l}.a)
                    z = zeros(size(net.comp{ci}.layers{l}.a{1}));
                    for j = 1 : numel(net.comp{ci}.layers{l + 1}.a)
                         z = z + convn(net.comp{ci}.layers{l + 1}.d{j}, rot180(net.comp{ci}.layers{l + 1}.k{i}{j}), 'full');
                    end
                    net.comp{ci}.layers{l}.d{i} = z;
                end
            end
        end

        %%  calc gradients
        for l = 2 : n
            if strcmp(net.comp{ci}.layers{l}.type, 'c')
                for j = 1 : numel(net.comp{ci}.layers{l}.a)
                    for i = 1 : numel(net.comp{ci}.layers{l - 1}.a)
                        net.comp{ci}.layers{l}.dk{i}{j} = convn(flipall(net.comp{ci}.layers{l - 1}.a{i}), net.comp{ci}.layers{l}.d{j}, 'valid') / size(net.comp{ci}.layers{l}.d{j}, 2);
                    end
                    net.comp{ci}.layers{l}.db{j} = sum(net.comp{ci}.layers{l}.d{j}(:)) / size(net.comp{ci}.layers{l}.d{j}, 2);
                end
            end
        end
    
    end
    % for hidden layer.
    net.dffW = net.od * (net.ho)' / size(net.od, 2);
    net.dffb = mean(net.od, 2);
    
    net.dhfW = net.hod * (net.fv)' / size(net.hod, 2);
    net.dhfb = mean(net.hod, 2);

%   original perceptron.
%    net.dffW = net.od * (net.fv)' / size(net.od, 2);
%    net.dffb = mean(net.od, 2);
    
    function X = rot180(X)
        X = flipdim(flipdim(X, 1), 2);
    end
end
