function [dx, dy] = subdata_trans(data_num)
% file_list = '';
% 

% subject 2 is female, others are male.
subjects = [1];
sub_num = size(subjects, 2);

per_num = round(data_num / sub_num);

dx = [];
dy = [];

for i = 1 : sub_num
    
    flist = strcat(strcat('/Users/rt77789/code/data/PAMAP2_Dataset/PAMAP2_Dataset/Protocol/subject10'  ,num2str(subjects(i))), '.dat.gyro');
    
    disp(flist);
    data = load(flist);
    data(:, 3);
    [gx, gy] = data_trans(data);
    
    gx = gx(:, 1:per_num);
    gy = gy(:, 1:per_num);
    
    dx = [dx, gx];
    dy = [dy, gy];
    gx = nan;
    gy = nan;
end

pos = randperm(size(dx, 2));

dx = dx(:, pos);
dy = dy(:, pos);