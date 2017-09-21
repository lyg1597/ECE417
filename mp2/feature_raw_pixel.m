function feature=feature_raw_pixel(all_image,size_h,size_w)
    new_size=size_h*size_w;
    feature=zeros(new_size,80);
    for i=1:80
        feature(:,i)=reshape(imresize(all_image(:,:,i),[size_h,size_w]),[new_size,1]);
        %feature(:,i)=reshape(all_image(:,:,i),[new_size,1]);
    end
end
