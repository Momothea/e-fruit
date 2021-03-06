function [result] = classifyImage(image)
%CLASSIFYIMAGE Summary of this function goes here
%   Detailed explanation goes here

% chargement CNN
global mynet;

% C'est la fonction classifyRunner qui se charge de charger le CNN
% if isempty(mynet)
%     disp("Chargement CNN dans classifyImage...");
%     mynet = coder.loadDeepLearningNetwork('fruitnet.mat', 'netTransfer');
% end

try
    img = imread(image);
    imgresz = imresize(img,[227 227]);
    
    [pred,score] = classify(mynet,imgresz);
    classes = mynet.Layers(end).Classes;
    
    % Select the top five predictions
    % https://fr.mathworks.com/help/deeplearning/ug/classify-images-from-webcam-using-deep-learning.html
    [~,idx] = sort(score,'descend');
    idx = idx(1:1:5);
    scoreTop = score(idx);
    classNamesTop = string(classes(idx));
    
    % préallocation array de struct
    result = repmat(struct("categorie","","score",0.0), numel(classNamesTop), 1);
    
    for i = 1:numel(classNamesTop)
        s = struct("categorie",classNamesTop(i,:),"score",scoreTop(i));
        result(i) = s;
    end
    
    result = jsonencode(result);
catch ME
    % erreur input ?
    warning('%s: %s', ME.identifier, ME.message);
    result = sprintf("ERROR %s", ME.message);
end

end



