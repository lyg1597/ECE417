function run( data_dir )
%RUN Summary of this function goes here
%   Detailed explanation goes here
    training_image = zeros(6300,40);
    training_speech = zeros(10000,60);
    trainimg_label = zeros(1,40);
    trainspeech_label = zeros(1,60);
    for i=1:40
        label = double('A')+idivide(int32(i-1),int32(10),'floor');
        trainimg_label(1,i)=char(label);
        idx = mod(i-1,10)+1;
        filename=[data_dir,'/trainimg/',char(label),num2str(idx),'.jpg'];
        training_image(:,i)=reshape(double(rgb2gray(imread(filename))),[6300,1]);
    end

    for i=1:60
        label = double('A')+idivide(int32(i-1),int32(15),'floor');
        trainspeech_label(1,i) = char(label);
        idx = mod(i-1,15)+1;
        filename=[data_dir,'/trainspeech/',char(label),num2str(idx),'.wav'];
        training_speech(:,i)=imresize(audioread(filename),[10000,1]);
    end

    [pca,N]=feature_pca(training_image,0.95);
    feature_CC=feature_cepstrum(training_speech,12,500,50);
    gmm_train(feature_CC(:,1:330),2);
    
end
