function run(data_dir)
%RUN Summary of this function goes here
%   Detailed explanation goes here
    filename=[data_dir,'/mesh.txt'];
    vertices=dlmread(filename,' ',[1,0,33,1]);
    traingles=dlmread(filename,' ',[37,0,78,2]);
    filename=[data_dir,'/ECE417_MP5_AV_Data.mat'];
    load(filename);
    filename=[data_dir,'/mouth.jpg'];
    neutral_image=imread(filename);
    mapping=ECE417_MP5_train(av_train,av_validate,silenceModel,100,'result.txt');
    results = ECE417_MP5_test(testAudio,silenceModel,mapping);
    generate_image('./output_img',results,neutral_image,vertices,traingles)
end

