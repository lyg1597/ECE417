function run(filepath)
%RUN Summary of this function goes here
%   Detailed explanation goes here
    filename=[filepath,'/rects/allrects.txt'];
    load(filename,'-ascii');
    jpgdir=[filepath,'/jpg'];
    images=dir([jpgdir,'/*.jpeg']);
    for k=1:length(images)
        A=imread([jpgdir,'/',images(k).name]);
        all_images(:,:,k)=integralimage(A);
    end
    learned_classifiers=adaboost_learn(allrects,all_images);
    adaboost_test(allrects,all_images,learned_classifiers);
end

