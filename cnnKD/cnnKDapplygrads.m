function net = cnnKDapplygrads(net, opts)

    % Update parameters of each layer of  each component.
    for ci = 1 : numel(net.comp) 
        for l = 2 : numel(net.comp{ci}.layers)
            if strcmp(net.comp{ci}.layers{l}.type, 'c')
                for j = 1 : numel(net.comp{ci}.layers{l}.a)
                    for ii = 1 : numel(net.comp{ci}.layers{l - 1}.a)
                        net.comp{ci}.layers{l}.k{ii}{j} = net.comp{ci}.layers{l}.k{ii}{j} - opts.alpha * net.comp{ci}.layers{l}.dk{ii}{j};
                    end
                    net.comp{ci}.layers{l}.b{j} = net.comp{ci}.layers{l}.b{j} - opts.alpha * net.comp{ci}.layers{l}.db{j};
                end
            end
        end
    end

    net.ffW = net.ffW - opts.alpha * net.dffW;
    net.ffb = net.ffb - opts.alpha * net.dffb;
    
    % for hidden layer.
    net.hfW = net.hfW - opts.alpha * net.dhfW;
    net.hfb = net.hfb - opts.alpha * net.dhfb;
end
