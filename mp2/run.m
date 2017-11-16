function run(path)
%RUN Summary of this function goes here
%   Detailed explanation goes here

all_img=zeros(90,70,80);

for i=1:80
    if i<=20
        filename=[path,'/A',num2str(mod(i,21)),'.jpg'];
    elseif i>20 && i<=40
        filename=[path,'/B',num2str(mod(i-20,21)),'.jpg'];
    elseif i>40 && i<=60
        filename=[path,'/C',num2str(mod(i-40,21)),'.jpg'];
    else
        filename=[path,'/D',num2str(mod(i-60,21)),'.jpg'];
    end
    one_img=double(rgb2gray(imread(filename)));
    all_img(:,:,i)=one_img;
end
disp('========== extracting features ==========');
disp(' ');
raw_90_70=feature_raw_pixel(all_img,90,70);
raw_45_35=feature_raw_pixel(all_img,45,35);
raw_22_17=feature_raw_pixel(all_img,22,17);
raw_9_7=feature_raw_pixel(all_img,9,7);
[pca_95_90_70,N]=feature_pca_2(raw_90_70,0.95);
rand_90_70=feature_random(raw_90_70,N);

disp('========== calculating knn-1 ==========');
disp(' ');
mp2_test('raw',90,70,1,raw_90_70);
mp2_test('raw',45,35,1,raw_45_35);
mp2_test('raw',22,17,1,raw_22_17);
mp2_test('raw',9,7,1,raw_9_7);
mp2_test('95% PCA',70,90,1,pca_95_90_70);
mp2_test('ramdom',70,90,1,rand_90_70);

disp('========== calculating knn-5 ==========');
disp(' ');
mp2_test('raw',90,70,5,raw_90_70);
mp2_test('raw',45,35,5,raw_45_35);
mp2_test('raw',22,17,5,raw_22_17);
mp2_test('raw',9,7,5,raw_9_7);
mp2_test('95% PCA',70,90,5,pca_95_90_70);
mp2_test('ramdom',70,90,5,rand_90_70);

disp('========== extra credit ==========');
disp('========== pca with energy 90% ==========');
disp(' ');
[pca_90_90_70,~]=feature_pca_2(raw_90_70,0.90);
mp2_test('90% PCA',70,90,1,pca_90_90_70);
mp2_test('90% PCA',70,90,5,pca_90_90_70);
disp('========== pca with energy 98% ==========');
disp(' ');
[pca_98_90_70,~]=feature_pca_2(raw_90_70,0.98);
mp2_test('98% PCA',70,90,1,pca_98_90_70);
mp2_test('98% PCA',70,90,5,pca_98_90_70);
disp('========== 10 more random projections ==========');
disp(' ');
sumA1=0;
sumB1=0;
sumC1=0;
sumD1=0;
sumOV1=0;
sumA5=0;
sumB5=0;
sumC5=0;
sumD5=0;
sumOV5=0;
for i=1:10
    [A1,B1,C1,D1,OV1]=mp2_test('ramdom',70,90,1,rand_90_70);
    [A5,B5,C5,D5,OV5]=mp2_test('ramdom',70,90,5,rand_90_70);
    sumA1=sumA1+A1;
    sumB1=sumB1+B1;
    sumC1=sumC1+C1;
    sumD1=sumD1+D1;
    sumOV1=sumOV1+OV1;
    sumA5=sumA5+A5;
    sumB5=sumB5+B5;
    sumC5=sumC5+C5;
    sumD5=sumD5+D5;
    sumOV5=sumOV5+OV5;
end
text='average accurcy:';
disp(text);
text=['knn-1 A: ',num2str(fix(sumA1*10000)/1000),'%  B: ',num2str(fix(sumB1*10000)/1000),'%  C: ',num2str(fix(sumC1*10000)/1000),'%  D: ',num2str(fix(sumD1*10000)/1000),'%  Overall: ',num2str(fix(sumOV1*10000)/1000),'%'];
disp(text)
text=['knn-5 A: ',num2str(fix(sumA5*10000)/1000),'%  B: ',num2str(fix(sumB5*10000)/1000),'%  C: ',num2str(fix(sumC5*10000)/1000),'%  D: ',num2str(fix(sumD5*10000)/1000),'%  Overall: ',num2str(fix(sumOV5*10000)/1000),'%'];
disp(text)
end

