function hidden_plot(net)

% Plot all hidden layers for different component.

for ci = 1 : numel(net.comp)
    
    for layer = [2]
        
       % hold on;
        for i = 1 : numel(net.comp{ci}.layers{layer}.a)
            last = size(net.comp{ci}.layers{layer}.a{i}, 2);
            figure; 
            plot(net.comp{ci}.layers{layer}.a{i}(:, last)); 
            title(['comp = ' num2str(ci) ', layer=' num2str(layer) ',i=' num2str(i)]);
        end
        
       % hold off;
    end
end
