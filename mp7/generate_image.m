function generate_image( output_dir,visual_data,neutral_image,vertices,traingles )
%GENERATE_IMAGE Summary of this function goes here
%   Detailed explanation goes here
    mkdir(output_dir);
    for i=1:size(visual_data,2)
        a_img=generate_a_image(neutral_image,visual_data(:,i),vertices,traingles)/255;
        opfilename=[output_dir,sprintf('/test_%04d.jpg',i)];
        display(opfilename);
        imwrite(a_img,opfilename);
    end
end
