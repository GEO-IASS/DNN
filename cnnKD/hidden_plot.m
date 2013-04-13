function hidden_plot(net)

% Plot all hidden layers for different component.

for ci = 1 : numel(net.comp)
    
    for layer = [2 4]
        figure; 
        hold on;
        for i = 1 : numel(net.comp{ci}.layers{layer}.a)
            last = size(net.comp{ci}.layers{layer}.a{i}, 2);
            plot(net.comp{ci}.layers{layer}.a{i}(:, last)); 
        end
        title(['comp = ' num2str(ci) ', layer=' num2str(layer)]);
        hold off;
    end
end
