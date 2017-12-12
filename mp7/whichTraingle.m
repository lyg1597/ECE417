function [traingle_map] = whichTraingle( vertices,traingles,neutral_image )
%WHICHTRAINGLE Summary of this function goes here
%   Detailed explanation goes here
    [im_height,im_width]=size(neutral_image);
    traingle_map=zeros(im_height,im_width);
    for r=1:im_height
        for c=1:im_width
            for i=1:size(traingles,1)
                % if r==39 && c==37
                %     display('interesting');
                % end
                x=ones(3,3);
                x(1:2,1)=transpose(vertices(traingles(i,1),:));
                x(1:2,2)=transpose(vertices(traingles(i,2),:));
                x(1:2,3)=transpose(vertices(traingles(i,3),:));
                lambda=x\[c;r;1];
                lambda=round(lambda,1);
                if all(lambda>=0) && all(lambda<=1)
                    traingle_map(r,c)=i;
                end
            end
        end
    end
end

