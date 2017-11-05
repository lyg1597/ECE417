function run(path)
%RUN Summary of this function goes here
%   Detailed explanation goes here
    feaA={};
    feaV={};
    for i=1:20
        if i<=10
            m=2;
        else
            m=5;
        end
        n=mod(i-1,10)+1;
        filenameA=[path,num2str(m),'.',num2str(n),'.','a','.fea'];
        filenameV=[path,num2str(m),'.',num2str(n),'.','v','.fea'];
        feaA{i}=dlmread(filenameA);
        feaV{i}=dlmread(filenameV);
    end
    A_init=[1/2,1/2;1/2,1/2];
    [P0_a,A_a,mu_a,sigma_a]=ghmm_learn(feaA,2);
    [P0_v,A_v,mu_v,sigma_v]=ghmm_learn(feaV,2);
end

