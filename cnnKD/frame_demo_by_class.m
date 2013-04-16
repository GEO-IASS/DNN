function [] = frame_demo_by_class(data)

rng(15742);

labels = unique(data(:, 2));
pnum = 3;
figure;

page = round(size(labels, 1) / 3);

for i = 1 : size(labels, 1)
    
    indx = find(data(:, 2) == labels(i));
    % for j = 1 : pnum
    disp(['a=' num2str(round(i / page + 1)) ',b=' num2str(mod(i, page) + 1)]);
    figure(round(i / page + 1));
    subplot(page, 1, mod(i, page) + 1);
    
    plot(data(indx(3000:5000), 3));
    title(['label=' num2str(labels(i))]);
    % end
end


