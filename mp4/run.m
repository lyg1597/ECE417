function run( data_dir )
%RUN Summary of this function goes here
%   Detailed explanation goes here
    training_image = zeros(6300,40);
    training_speech = zeros(10000,60);
    trainimg_label = zeros(1,40);
    trainspeech_label = zeros(1,60);
    testing_image = zeros(6300,40);
    testing_speech = zeros(10000,40);
    testimg_label = zeros(1,40);
    testspeech_label = zeros(1,60);
    
    % read training image
    for i=1:40
        label = double('A')+idivide(int32(i-1),int32(10),'floor');
        trainimg_label(1,i)=char(label);
        idx = mod(i-1,10)+1;
        filename=[data_dir,'/trainimg/',char(label),num2str(idx),'.jpg'];
        training_image(:,i)=reshape(double(rgb2gray(imread(filename))),[6300,1]);
    end
    
    % read testing image
    for i=1:40
        label = double('A')+idivide(int32(i-1),int32(10),'floor');
        testimg_label(1,i)=char(label);
        idx = mod(i-1,10)+1+10;
        filename=[data_dir,'/testimg/',char(label),num2str(idx),'.jpg'];
        testing_image(:,i)=reshape(double(rgb2gray(imread(filename))),[6300,1]);
    end

    % read training sound
    for i=1:60
        label = double('A')+idivide(int32(i-1),int32(15),'floor');
        trainspeech_label(1,i) = char(label);
        idx = mod(i-1,15)+1;
        filename=[data_dir,'/trainspeech/',char(label),num2str(idx),'.wav'];
        training_speech(:,i)=imresize(audioread(filename),[10000,1]);
    end
    
    % read testing sound
    for i=1:40
        label = double('A')+idivide(int32(i-1),int32(10),'floor');
        testspeech_label(1,i) = char(label);
        idx = mod(i-1,10)+1;
        filename=[data_dir,'/testspeech/',char(label),num2str(idx),'.wav'];
        testing_speech(:,i)=imresize(audioread(filename),[10000,1]);
    end

    %calculate image and audio features
    [pca,~]=feature_pca([training_image,testing_image],0.95);
    pca_train=pca(:,1:40);
    pca_test=pca(:,41:80);
    feature_CC_train=feature_cepstrum(training_speech,12,500,50);
    feature_CC_test=feature_cepstrum(testing_speech,12,500,50);
    
    %gmm classifer for sound
    gmm_1=gmm_train(transpose(feature_CC_train(:,1:330)),2);
    gmm_2=gmm_train(transpose(feature_CC_train(:,331:660)),2);
    gmm_3=gmm_train(transpose(feature_CC_train(:,661:990)),2);
    gmm_4=gmm_train(transpose(feature_CC_train(:,991:1320)),2);
    testspeech_prob=zeros(40,4);
    for i=1:40
        %prob=[mvnpdf(feature_CC_test),mvnpdf(),mvnpdf(),mvnpdf()];
        res=zeros(1,4);
        sidx=(i-1)*22+1;
        eidx=i*22;
        %res(1,1)=mean(gmm_1.weight(1,1).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_1.mu(:,1)),diag(gmm_1.sigma(:,1)))+gmm_1.weight(1,2).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_1.mu(:,2)),diag(gmm_1.sigma(:,2))));
        %res(1,2)=mean(gmm_2.weight(1,1).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_2.mu(:,1)),diag(gmm_2.sigma(:,1)))+gmm_2.weight(1,2).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_2.mu(:,2)),diag(gmm_2.sigma(:,2))));
        %res(1,3)=mean(gmm_3.weight(1,1).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_3.mu(:,1)),diag(gmm_3.sigma(:,1)))+gmm_3.weight(1,2).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_3.mu(:,2)),diag(gmm_3.sigma(:,2))));
        %res(1,4)=mean(gmm_4.weight(1,1).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_4.mu(:,1)),diag(gmm_4.sigma(:,1)))+gmm_4.weight(1,2).*mvnpdf(transpose(feature_CC_test(:,sidx:eidx)),transpose(gmm_4.mu(:,2)),diag(gmm_4.sigma(:,2))));
        res(1,1)=gmm_eval(transpose(feature_CC_test(:,sidx:eidx)),gmm_1);
        res(1,2)=gmm_eval(transpose(feature_CC_test(:,sidx:eidx)),gmm_2);
        res(1,3)=gmm_eval(transpose(feature_CC_test(:,sidx:eidx)),gmm_3);
        res(1,4)=gmm_eval(transpose(feature_CC_test(:,sidx:eidx)),gmm_4);
        testspeech_prob(i,:)=res;
    end
    
    %knn classifer for image
    testimg_prob=zeros(40,4);
    for i=1:40
        [prob,~]=knn(pca_test(:,i),pca_train);
        testimg_prob(i,:)=prob;
    end
    
    %av raw probability
    avr_prob=zeros(400,4);
    for j=1:40
        for k=1:10
            avr_prob((j-1)*10+k,:)=testspeech_prob(j,:).*testimg_prob(fix((j-1)/10)*10+k,:);
        end
    end
    
    %av weighted probability
    avw_prob=zeros(400,4,9);
    for i=1:9
        tmpa=testspeech_prob.^(i/10);
        tmpv=testimg_prob.^((10-i)/10);
        for j=1:40
            for k=1:10
                avw_prob((j-1)*10+k,:,i)=tmpa(j,:).*tmpv(fix((j-1)/10)*10+k,:);
            end
        end
    end
    
    %calculate speech accuracy
    speech_res = zeros(40,1);
    for i=1:40
        [~,speech_res(i,1)]=max(testspeech_prob(i,:));
    end
    speech_acc = zeros(5,1);
    for i=1:40
        if speech_res(i,:)==fix((i-1)/10)+1
            speech_acc(fix((i-1)/10)+1,:)=speech_acc(fix((i-1)/10)+1,:)+1;
        end
    end
    speech_acc=speech_acc./10;  
    speech_acc(5,1)=sum(speech_acc)/4;
    
    %calculate image accurcy
    image_res = zeros(40,1);
    for i=1:40
        [~,image_res(i,1)]=max(testimg_prob(i,:));
    end   
    image_acc = zeros(5,1);
    for i=1:40
        if image_res(i,:)==fix((i-1)/10)+1
            image_acc(fix((i-1)/10)+1,:)=image_acc(fix((i-1)/10)+1,:)+1;
        end
    end
    image_acc=image_acc./10;  
    image_acc(5,1)=sum(image_acc)/4;
    
    %calculate raw av accurcy
    avr_res = zeros(400,1);
    avr_acc = zeros(5,1);
    for i=1:400
        [~,avr_res(i,1)]=max(avr_prob(i,:));
    end
    for i=1:400
        if avr_res(i,:)==fix((i-1)/100)+1
            avr_acc(fix((i-1)/100)+1,:)=avr_acc(fix((i-1)/100)+1,:)+1;
        end
    end
    avr_acc=avr_acc./100;
    avr_acc(5,1)=sum(avr_acc)/4;
    
    %calculate weighted av accurcy
    avw_res = zeros(400,9);
    avw_acc = zeros(5,9);
    for j=1:9
        for i=1:400
            [~,avw_res(i,j)]=max(avw_prob(i,:,j));
        end
    end
    for j=1:9
        for i = 1:400
            if avw_res(i,j)==fix((i-1)/100)+1
                avw_acc(fix((i-1)/100)+1,j)=avw_acc(fix((i-1)/100)+1,j)+1;
            end
        end
        avw_acc(:,j)=avw_acc(:,j)./100;
        avw_acc(5,j)=sum(avw_acc(:,j))/4;
    end
    fprintf('\n--------- Person ID Accuracy: Audio -----------\n');
    disp(array2table(speech_acc, 'VariableNames', {'Acc'}, 'RowNames', {'A','B','C', 'D', 'Avg'}));   % Acc = [5 x 9] matrix of accuracies
    fprintf('--------------------\n'); 
    
    fprintf('\n--------- Person ID Accuracy: Visual -----------\n');
    disp(array2table(image_acc, 'VariableNames', {'Acc'}, 'RowNames', {'A','B','C', 'D', 'Avg'}));   % Acc = [5 x 9] matrix of accuracies
    fprintf('--------------------\n'); 
    
    fprintf('\n--------- Person ID Accuracy: Raw Audio + Visual -----------\n');
    disp(array2table(avr_acc, 'VariableNames', {'Acc'}, 'RowNames', {'A','B','C', 'D', 'Avg'}));   % Acc = [5 x 9] matrix of accuracies
    fprintf('--------------------\n'); 
    
    fprintf('\n--------- Person ID Accuracy: Weighted Audio + Visual -----------\n');
    disp(array2table(avw_acc, 'VariableNames', {'w_01', 'w_02', 'w_03', 'w_04' , 'w_05', 'w_06', 'w_07', 'w_08', 'w_09'}, 'RowNames', {'A','B','C', 'D', 'Avg'}));   % Acc = [5 x 9] matrix of accuracies
    fprintf('--------------------\n'); 
    
end
