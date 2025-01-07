% %Training and Validation 
% DatasetPath = 'C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\trainFolder';
% %Reading images from ECG images
% images = imageDatastore(DatasetPath,"IncludeSubfolders",true,'LabelSource','foldernames');
% 
% %Splitting Dataset
% numTrainFiles = 54349;
% [TrainImages, ValImages] = splitEachLabel(images,numTrainFiles,'randomize')
% 
% net = alexnet; %importing pretrained alexnet
% layersTransfer = net.Layers(1:end-3); %Preserving all layers except last 3
% numClasses = 5; %Number of output classes
% 
% %Defining Layers of the Alexnet
% layers = [layersTransfer
%      fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
%      softmaxLayer
%      classificationLayer
% 
%  ];
% 
% %Training Options
% options = trainingOptions("sgdm", ...
%      'MiniBatchSize',256, ...
%      'MaxEpochs',30, ...
%      'InitialLearnRate',1e-4, ...
%      'Shuffle','every-epoch', ...
%      'ValidationData',ValImages, ...
%      'ValidationFrequency',10, ...
%      'Verbose',false, ...
%      'Plots','training-progress' ...
%      );
% 
% %Training time
% Cardionet = trainNetwork(TrainImages,layers,options);
% save('Cardionet.mat', 'Cardionet');
% 
% %classifying images
% netstruct = load("Cardionet.mat",'Cardionet')
% Cardionet = netstruct.Cardionet;
% 
% %Validation Accuracy
% YPred = classify(Cardionet,ValImages);
% YValidation = ValImages.Labels;
% val_accuracy = sum(YPred == YValidation)/numel(YValidation)
% % 
% % %ConfusionMatrix
% plotconfusion(YValidation,YPred)
Net transfer gave the best prediction so we stic with net transfer

%Test Accuracy
DatasetPath ='C:\Users\nadjei\OneDrive - Clemson University\Documents\MATLAB\DSP_project\testFolder'
TestImages = imageDatastore(DatasetPath,"IncludeSubfolders",true,'LabelSource','foldernames');

% Prepare the test data (assuming the input size is 227x227)
dsTest = augmentedImageDatastore([227 227], TestImages);

% % Classify the test images
 YPred = classify(Cardionet, TestImages);
% 
% % Extract the true labels
 YTest = TestImages.Labels;
Calculating Performance Metrics
%Accuracy
accuracy = sum(YPred == YTest) / numel(YTest);
disp(['Accuracy: ', num2str(accuracy)]);

% Plot the confusion matrix
figure;
confusionchart(YTest, YPred);

%Precision, Recall, and F1 Score
cm = confusionmat(YTest, YPred);

classes = unique(YTest);
numClasses = numel(classes);

%Initialize variables
precision = zeros(numClasses,1);
recall = zeros(numClasses,1);
F1score = zeros(numClasses,1);

%calculation
for i = 1:numClasses
    TP = cm(i,i); %True Positives
    FP = sum(cm(:,i))-TP; %False Positives
    FN = sum(cm(i,:))-TP; %False Negatives
    TN = sum(cm(:))-TP -FP-FN;% True Negatives

    precision(i) = TP/(TP + FP);
    recall(i) = TP/(TP + FN);
    F1score(i) = 2*(precision(i)*recall(i)) / (precision(i) + recall(i));
end 

%Display results
disp(table(classes, precision, recall, F1score))



