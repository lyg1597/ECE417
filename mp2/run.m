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
[pca,N]=feature_pca(all_img,0.95);

end

