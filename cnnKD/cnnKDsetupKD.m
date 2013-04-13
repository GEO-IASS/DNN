function net = cnnKDsetupKD(components, y)

net.comp = {};


comp_num = size(components, 2);

fvnum = 0;

% Add components to net.
for i = 1 : comp_num
    net.comp{i} = components(i);
    net.frame = components(i).frame;
    % Total variables are fed into MLP.
    fvnum = fvnum + components(i).fvnum;
end

% Setup for final MLP layers.

onum = size(y, 1);

hvnum = fvnum;

net.hfb = zeros(hvnum, 1);
net.hfW = (rand(hvnum, fvnum) - 0.5) * 2 * sqrt(6 / (hvnum + fvnum));

net.ffb = zeros(onum, 1);
net.ffW = (rand(onum, hvnum) - 0.5) * 2 * sqrt(6 / (onum + hvnum));

%
%     onum = size(y, 1);
% %     add a hidden layer at last, instead of original perceptron.
%     hvnum = fvnum;
%     net.hfb = zeros(hvnum, 1);
%     net.hfW = (rand(hvnum, fvnum) - 0.5) * 2 * sqrt(6 / (hvnum + fvnum));
%
%     disp(['fvum=' num2str(fvnum) ',mapsize=' num2str(mapsize) ',inputmaps=' num2str(inputmaps)])
%
%     net.ffb = zeros(onum, 1);
%     net.ffW = (rand(onum, hvnum) - 0.5) * 2 * sqrt(6 / (onum + hvnum));
