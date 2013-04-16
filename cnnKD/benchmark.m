function [err, bad] = benchmark(gx, gy, tx, ty)

% 1-NN, Euclidean distance.
bad = [];
% Elapsed time is 41.482934 seconds. for 100 queries.
% Elapsed time is 25.979421 seconds. current vectorized version.
tic;
    

for i = 1 : size(ty, 2)
  %  res = sum((gx - repmat(tx(:, i), 1, size(gy, 2))) .^ 2, 1);
  %  disp(res);
  %  [~, I] = min(res);
    temp = 1e100;
    mini = -1;
    
    for j = 1 : size(gy, 2)
        d = distance(gx(:, j), tx(:, i));
        if(d < temp) 
            temp = d;
            mini = j;
        end
    end
    
    disp(['index=' num2str(i) ' ,min_pos=' num2str(mini) ]);
    if(any(gy(:, mini) ~= ty(:, i)))
        bad = [bad, mini];
    end;
end
    err = size(bad, 2) / size(ty, 2);
toc;
% 
% x = find(gy(4, :) == 1)
% size(x)
% for i = 1 : 20
% figure; spectrogram(gx(:, i));
% end
% y = kmeans(gx(:, x)', 5);


    function dis = distance(a, b)
        dis = sum((a - b) .^ 2);
    end
end