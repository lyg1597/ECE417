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

raw_pixels90_70=feature_raw_pixel(all_img,90,70);
[pca,N]=feature_pca(raw_pixels90_70,0.95);
rand_feature=feature_random(raw_pixels90_70,N);

correct = 0;
for i=1:80
    [~,class]=knn(i,pca,1);
    if fix((i-1)/20)==class
        correct=correct+1;
    end
end
result=correct/80;
test=['precision rate for knn1 : ',num2str(fix(result*10000)/100),'%'];
display(test);

correct = 0;
for i=1:80
    [result_idx,class]=knn(i,pca,5);
    test=['image index:',num2str(i),'  class:',num2str(class)];
    disp(test);
    disp(result_idx);
    if fix((i-1)/20)==class
        correct=correct+1;
    end
end
result=correct/80;
test=['precision rate for knn5 : ',num2str(fix(result*10000)/100),'%'];
display(test);
        

end

