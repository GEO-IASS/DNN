function [dx, dy, dp] = data_trans(data)

% Interpolate to remove NaN.
data(:, 3) = inpaint_nans(data(:, 3));

labels = unique(data(:, 2));
% % normalize
% for i = 1 : size(labels, 1)
%     
%     tmp = data(data(:, 2) == labels(i), 3);
%     %disp(mean(tmp));
%     tmp = tmp - mean(tmp);
%     tmp = tmp / std(tmp);
%     
%     data(data(:, 2) == labels(i), 3) = tmp;
% end


frame = 256;
col = size(data, 1) - frame + 1;
step = 2;

dx = [];
dy = [];

numa = 0;
numb = 0;

for i = 1 : step : col
    
    if(~isnan(data(i : (i + frame - 1), 2:3)))
        dx = [dx, data(i : (i + frame - 1), 3)];
        if frame ~= sum(data(i : (i + frame - 1), 2) == data(i, 2))    
            dy = [dy, labels == 0];
            numa = numa + 1;
        else
            dy = [dy, labels == data(i, 2)];
            numb = numb + 1;
        end
    end
    
end

dx = [dx(:, (dy(2, :) == 1)), dx(:, (dy(3, :) == 1))];
dy = [dy(:, (dy(2, :) == 1)), dy(:, (dy(3, :) == 1))];

rnum = size(dx, 2);
pos = randperm(rnum);

dx = dx(:, pos);
dy = dy(:, pos);

% check statistics for each class.
for i = 1 : (rnum / 5) : rnum
    tmp = sum(dy(:, 1:i), 2);
    disp('data block dirstibution of class:')
    disp(num2str(tmp / sum(tmp)))
    disp(tmp)
    disp(sum(tmp))
end
% pure frame num=36407,mix frame num=638
disp(['pure frame num=' num2str(numb) ',mix frame num=' num2str(numa)])
