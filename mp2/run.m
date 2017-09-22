function run
%RUN Summary of this function goes here
%   Detailed explanation goes here

all_img=zeros(90,70,80);

for i=1:80
    if i<=20
        filename=['./newimdata/A',num2str(mod(i,21)),'.jpg'];
    elseif i>20 && i<=40
        filename=['./newimdata/B',num2str(mod(i-20,21)),'.jpg'];
    elseif i>40 && i<=60
        filename=['./newimdata/C',num2str(mod(i-40,21)),'.jpg'];
    else
        filename=['./newimdata/D',num2str(mod(i-60,21)),'.jpg'];
    end
    one_img=double(rgb2gray(imread(filename)));
    all_img(:,:,i)=one_img;
end

raw_pixels=feature_raw_pixel(all_img,90,70);
[pca,N]=feature_pca(raw_pixels,0.95);
rand_feature=feature_random(raw_pixels,N);

correct = 0;
rec_idx=zeros(1,80);
for i=1:80
    idx=knn_1(i,pca);
    rec_idx(1,i)=idx;
    if fix((i-1)/20)==fix((idx-1)/20)
        correct=correct+1;
    end
end
result=correct/80;
test=['precision rate: ',num2str(fix(result*10000)/100),'%'];
display(test);
display(rec_idx);
        

end

