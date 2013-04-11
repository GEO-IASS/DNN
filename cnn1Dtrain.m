function net = cnn1Dtrain(net, x, y, opts)

    % m is nrow of train_x.
    m = size(x, 2);
    % numbaches is # of batch.
    numbatches = m / opts.batchsize;
    
    % numbatches % 1 != 0, it's a real number.
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    % rL is mse.
    net.rL = [];
    
    % for each epoch, update parameters by gradient ascent.
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        % disp the start time.
        tic;
        
        % create a random permutation of [1..m].
        kk = randperm(m);
        % for each batch, calculate gradients and update parameters.
        for l = 1 : numbatches
            % obtain batch data w.r.t features and labels.
            batch_x = x(:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            batch_y = y(:, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            % feed-forward phase.
            net = cnn1Dff(net, batch_x);
            % back-propogation phase.
            net = cnn1Dbp(net, batch_y);
            % update parameters.
            net = cnn1Dapplygrads(net, opts);
            % update mse.
            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            % 0.99?
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
        end
        % disp the end time.
        toc;
    end
    
end
