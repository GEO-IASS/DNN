function [] = frame_plot_by_class(dx, dy, num)

[row, col] = size(dx);

rng(15742);

platte = rand(3, size(dy, 1));
label = [];


for i = 1 : num
    label = [label, find(dy(:, i) == 1)];
    if(label(end) == 2)
        plot(dx(1:256, i), 'color', platte(:, label(end)));
        
        hold on;
    end
end