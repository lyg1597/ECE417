function [ value ] = linear_interp(u,v,image)
%LINEAR_INTERP Summary of this function goes here
%   Detailed explanation goes here
    [im_height,im_width]=size(image);
    u1=floor(u);
    u2=ceil(u);
    v1=floor(v);
    v2=ceil(v);
    if u2>130 || u1>130 || v1>79 || v2>79
        display('fuck');
    end
    if u2>im_width
        u2=im_width;
    end
    if v2>im_height
        v2=im_height;
    end
    a=((u-u1)/(u2-u1))*(image(v1,u2)-image(v1,u1))+image(v1,u1);
    b=((u-u1)/(u2-u1))*(image(v2,u2)-image(v2,u1))+image(v2,u1);
    value=((v-v1)/(v2-v1))*(b-a)+a;
end

