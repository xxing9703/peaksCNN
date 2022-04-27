digitDatasetPath = 'C:\Users\xxing\Documents\Github\NetID\pilot\25095EICs';
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

imds.ReadFcn = @customReadDatastoreImage;
size=64;
figure;
perm = randperm(25095,20);
for i = 1:4
    subplot(2,2,i);
    imshow(imds.Files{perm(i)});
end

labelCount = countEachLabel(imds);
numModelFiles = 0.8;
numTrainFiles = 0.7;
[imdsModel,imdsTest] = splitEachLabel(imds,numModelFiles,'randomize');
[imdsTrain,imdsValidation] = splitEachLabel(imdsModel,numTrainFiles,'randomize');


%%
layers = [
    imageInputLayer([size size 1])
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)

    fullyConnectedLayer(2)

    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',2, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)