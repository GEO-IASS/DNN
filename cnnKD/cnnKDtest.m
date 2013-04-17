function [er, bad] = cnnKDtest(net, x, y)
    % Seperate x and y into blocks, because in cnnKDff we have to allocate
    % a big matrice to do feed-forward propagation, that's memory comsuming.
    block_size = 1000;
    bad = [];
    
    
    
    for i = 1 : block_size : size(x, 2)
        upper = i + block_size - 1;
        if upper > size(x, 2)
            upper = size(x, 2);
        end
        tmp_x = x(:, i:upper);
        tmp_y = y(:, i:upper);
        
        net = cnnKDff(net, tmp_x);
        
        %disp(net.o);
        [~, h] = max(net.o);

        %disp(h);
        [~, a] = max(tmp_y);
        %disp(a);
        bad = [bad, find(h ~= a) + i - 1];        
       % er = numel(bad) / size(y, 2);   
    end
    er = numel(bad) / size(y, 2);
end
