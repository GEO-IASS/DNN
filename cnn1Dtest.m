function [er, bad] = cnn1Dtest(net, x, y)
    %  feedforward
    net = cnn1Dff(net, x);
    disp(net.o(:, 1:10));
    [~, h] = max(net.o);
    
    disp(h(:, 1:10));
    [~, a] = max(y);
    disp(y(:, 1:10));
    bad = find(h ~= a);

    er = numel(bad) / size(y, 2);
end
