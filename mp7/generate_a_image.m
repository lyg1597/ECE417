function [ a_image ] = generate_a_image( neutral_image,visual_data,vertices,traingles )
%GENERATE_A_IMAGE Summary of this function goes here
%   Detailed explanation goes here
    [im_height,im_width]=size(neutral_image);
    a_image=zeros(im_height,im_width);
    [newVertX,newVertY]=interpVert(vertices(:,1),vertices(:,2),0,0,0,visual_data(1),visual_data(2),visual_data(3),1);
    new_vertices=[newVertX,newVertY];
    new_traingle_map=whichTraingle(new_vertices,traingles,neutral_image);
    for r=1:im_height
        for c=1:im_width
            traingle=new_traingle_map(r,c);
            if traingle~=0
                x_prime=ones(3,3);
                x_prime(1:2,1)=transpose(new_vertices(traingles(traingle,1),:));
                x_prime(1:2,2)=transpose(new_vertices(traingles(traingle,2),:));
                x_prime(1:2,3)=transpose(new_vertices(traingles(traingle,3),:));
                lambda=x_prime\[c;r;1];
                x=ones(3,3);
                x(1:2,1)=transpose(vertices(traingles(traingle,1),:));
                x(1:2,2)=transpose(vertices(traingles(traingle,2),:));
                x(1:2,3)=transpose(vertices(traingles(traingle,3),:));
                u=x(1,:)*lambda;
                v=x(2,:)*lambda;

                value=linear_interp(u,v,neutral_image);
                a_image(r,c)=value;
            end
        end
    end
end

