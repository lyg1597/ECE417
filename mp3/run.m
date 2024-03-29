%% window size of 100
samples = 100;
T = 10000;
person_label = zeros(1, samples);
digit_label  = zeros(1, samples);

for i = 1:samples
    person_label(1, i) = floor((i-1)/25);
end

audio_data = [];
cep_100        = [];
cep_500        = [];
cep_10000        = [];
MFCC_100        = [];
MFCC_500        = [];
MFCC_10000        = [];

persons = ['A', 'B', 'C', 'D'];
utterance = ['a', 'b', 'c', 'd','e'];
for i = 1:4
   for j = 1:5
       for k = 1:5
           digit_label(1,(i-1)*25+(j-1)*5+k) = j; 
           [data, Fs]  = audioread(strcat('speechdata/', persons(i), num2str(j), utterance(k), '.wav'));
           audio_data  = cat(2, audio_data, imresize(data(:,1),[T,1]));
           cep_100  = cat(2, cep_100 ,     cepstrum(imresize(data(:,1),[T,1]), 12, 100, 10));
           cep_500  = cat(2, cep_500 ,     cepstrum(imresize(data(:,1),[T,1]), 12, 500, 50));
           cep_10000  = cat(2, cep_10000 , cepstrum(imresize(data(:,1),[T,1]), 12, 10000, 1000));
           MFCC_100  = cat(2, MFCC_100 ,    mfcc(imresize(data(:,1),[T,1]), 12, 'Nw',100,   'No', 10,   'Fs', Fs, 'R', [0 Fs/2]));
           MFCC_500  = cat(2, MFCC_500 ,    mfcc(imresize(data(:,1),[T,1]), 12, 'Nw',500,   'No', 50,   'Fs', Fs, 'R', [0 Fs/2]));
           MFCC_10000  = cat(2, MFCC_10000 ,mfcc(imresize(data(:,1),[T,1]), 12, 'Nw',10000, 'No', 1000, 'Fs', Fs, 'R', [0 Fs/2]));
       end
   end
end

%% Speech recongition cepstrum 1NN
disp('Cepstrum');
disp('Speech Recognition');
disp('1NN');

result = zeros(5,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(audio_data(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      audio_data(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(cep_100(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      cep_100(:,    (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(cep_500(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      cep_500(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(cep_10000(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      cep_10000(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speech cepstrum 1NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speech recongition cepstrum 1NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;

%% Speech recongition MFCC 1NN
disp('MFCC');
disp('Speech Recognition');
disp('1NN');

result = zeros(5,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(audio_data(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      audio_data(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(MFCC_100(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      MFCC_100(:,    (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(MFCC_500(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      MFCC_500(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(MFCC_10000(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      MFCC_10000(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 1);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speech MFCC 1NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speech recongition MFCC 1NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;

%% Speech recongition cepstrum 5NN
disp('Cepstrum');
disp('Speech Recognition');
disp('5NN');

result = zeros(5,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(audio_data(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      audio_data(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(cep_100(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      cep_100(:,    (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(cep_500(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      cep_500(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(cep_10000(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      cep_10000(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speech cepstrum 5NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speech recongition cepstrum 5NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;

%% Speech recongition MFCC 5NN
disp('MFCC');
disp('Speech Recognition');
disp('5NN');

result = zeros(5,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(audio_data(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      audio_data(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(MFCC_100(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      MFCC_100(:,    (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(MFCC_500(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      MFCC_500(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:5
                temp = 0;
                for k = 1:4
                    temp = temp + knn(MFCC_10000(:, person_label ~= k-1), digit_label(1, person_label ~= k-1), ...
                                      MFCC_10000(:, (k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5),    ...
                                      digit_label(1,(k-1) * 25 + 1 + (j-1) * 5:(k-1) * 25 + (j-1) * 5 + 5), 5);
                end
                temp = temp/4*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speech MFCC 5NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speech recongition MFCC 5NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;

%% Speaker recongition cepstrum 1NN
disp('Cepstrum');
disp('Speaker Recognition');
disp('1NN');

result = zeros(4,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(audio_data(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      audio_data(:, (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(cep_100(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      cep_100(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(cep_500(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      cep_500(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(cep_10000(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      cep_10000(:,  (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speaker cepstrum 1NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speaker recongition cepstrum 1NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;

%% Speaker recongition MFCC 1NN
disp('MFCC');
disp('Speaker Recognition');
disp('1NN');

result = zeros(4,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(audio_data(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      audio_data(:, (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(MFCC_100(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      MFCC_100(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(MFCC_500(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      MFCC_500(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(MFCC_10000(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      MFCC_10000(:,  (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 1);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speaker MFCC 1NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speaker recongition MFCC 1NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;

%% Speaker recongition cepstrum 5NN
disp('Cepstrum');
disp('Speaker Recognition');
disp('5NN');

result = zeros(4,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(audio_data(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      audio_data(:, (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(cep_100(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      cep_100(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(cep_500(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      cep_500(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(cep_10000(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      cep_10000(:,  (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speaker cepstrum 5NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speaker recongition cepstrum 5NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;

%% Speaker recongition MFCC 5NN
disp('MFCC');
disp('Speaker Recognition');
disp('5NN');

result = zeros(4,4);

window_size = [0, 100, 500, 10000];
for i = 1:4
    switch window_size(1,i)
        case 0
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(audio_data(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      audio_data(:, (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 100
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(MFCC_100(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      MFCC_100(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        case 500
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(MFCC_500(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      MFCC_500(:,    (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
        otherwise
            for j = 1:4
                temp = 0;
                for k = 1:5
                    temp = temp + knn(MFCC_10000(:, digit_label ~= k), person_label(1, digit_label ~= k), ...
                                      MFCC_10000(:,  (person_label == j-1 & digit_label == k)),         ...
                                      person_label(1,(person_label == j-1 & digit_label == k)), 5);
                end
                temp = temp/5*100;
                result(j,i) = temp;
            end
    end
end
average = mean(result);
result = cat(1, result, average);
disp(result);
figure('Name','speaker MFCC 5NN');
plot(result(5,:))
xlabel('window size');
ylabel('accurcy/%');
title('Speaker recongition MFCC 5NN');
ax = gca;
ax.XTick=[1,2,3,4];
ax.XTickLabel ={'Raw','W=100','W=500','W=10000'};
grid on;