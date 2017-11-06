function run(path)
%RUN Summary of this function goes here
%   Detailed explanation goes here
    N=5;
    Ainit=[0.8, 0.2, 0, 0, 0;
           0, 0.8, 0.2, 0, 0;
           0, 0, 0.8, 0.2, 0;
           0, 0, 0, 0.8, 0.2;
           0, 0, 0, 0, 1];
       
    feaA2={};
    feaV2={};
    feaAV2={};
    feaA5={};
    feaV5={};
    feaAV5={};
    for i=1:20
        if i<=10
            m=2;
            n=mod(i-1,10)+1;
            filenameA=[path,num2str(m),'.',num2str(n),'.','a','.fea'];
            filenameV=[path,num2str(m),'.',num2str(n),'.','v','.fea'];
            feaA2{i}=dlmread(filenameA);
            feaV2{i}=dlmread(filenameV);
            feaAV2{i}=cat(2,feaA2{i},feaV2{i});
        else
            m=5;
            n=mod(i-1,10)+1;
            filenameA=[path,num2str(m),'.',num2str(n),'.','a','.fea'];
            filenameV=[path,num2str(m),'.',num2str(n),'.','v','.fea'];
            feaA5{i-10}=dlmread(filenameA);
            feaV5{i-10}=dlmread(filenameV);
            feaAV5{i-10}=cat(2,feaA5{i-10},feaV5{i-10});
        end
    end
    corA2=0;
    corV2=0;
    corAV2=0;
    corA5=0;
    corV5=0;
    corAV5=0;
    
    corA2_v=0;
    corV2_v=0;
    corAV2_v=0;
    corA5_v=0;
    corV5_v=0;
    corAV5_v=0;
    
    [P0_a2,A_a2,mu_a2,sigma_a2]=ghmm_learn(feaA2,N,Ainit);
    [P0_v2,A_v2,mu_v2,sigma_v2]=ghmm_learn(feaV2,N,Ainit);
    [P0_av2,A_av2,mu_av2,sigma_av2]=ghmm_learn(feaAV2,N,Ainit);
    
    [P0_a5,A_a5,mu_a5,sigma_a5]=ghmm_learn(feaA5,N,Ainit);
    [P0_v5,A_v5,mu_v5,sigma_v5]=ghmm_learn(feaV5,N,Ainit);
    [P0_av5,A_av5,mu_av5,sigma_av5]=ghmm_learn(feaAV5,N,Ainit);
    
    
    for i=1:20
        disp(i);
        tempfeaA={};
        tempfeaV={};
        tempfeaAV={};
        if i<=10
            k=1;
            for j=1:10
                if j~=i
                    tempfeaA{k}=feaA2{j};
                    tempfeaV{k}=feaV2{j};
                    tempfeaAV{k}=feaAV2{j};
                    k=k+1;
                end
            end
            [tempP0_a2,tempA_a2,tempmu_a2,tempsigma_a2]=ghmm_learn(tempfeaA,N,Ainit);
            [tempP0_v2,tempA_v2,tempmu_v2,tempsigma_v2]=ghmm_learn(tempfeaV,N,Ainit);
            [tempP0_av2,tempA_av2,tempmu_av2,tempsigma_av2]=ghmm_learn(tempfeaAV,N,Ainit);
            
            [~,scale2A]=ghmm_fwd(feaA2{i},tempA_a2,tempP0_a2,tempmu_a2,tempsigma_a2);
            [~,scale5A]=ghmm_fwd(feaA2{i},A_a5,P0_a5,mu_a5,sigma_a5);
            if sum(scale2A)>sum(scale5A)
                corA2=corA2+1;
            end
            
            [~,scale2V]=ghmm_fwd(feaV2{i},tempA_v2,tempP0_v2,tempmu_v2,tempsigma_v2);
            [~,scale5V]=ghmm_fwd(feaV2{i},A_v5,P0_v5,mu_v5,sigma_v5);
            if sum(scale2V)>sum(scale5V)
                corV2=corV2+1;
            end
            
            [~,scale2AV]=ghmm_fwd(feaAV2{i},tempA_av2,tempP0_av2,tempmu_av2,tempsigma_av2);
            [~,scale5AV]=ghmm_fwd(feaAV2{i},A_av5,P0_av5,mu_av5,sigma_av5);
            if sum(scale2AV)>sum(scale5AV)
                corAV2=corAV2+1;
            end
            
            [~,log_likelyhood2A,~]=viterbi(feaA2{i},tempA_a2,tempP0_a2,tempmu_a2,tempsigma_a2);
            [~,log_likelyhood5A,~]=viterbi(feaA2{i},A_a5,P0_a5,mu_a5,sigma_a5);
            if log_likelyhood2A>log_likelyhood5A
                corA2_v=corA2_v+1;
            end
            
            [~,log_likelyhood2V,~]=viterbi(feaV2{i},tempA_v2,tempP0_v2,tempmu_v2,tempsigma_v2);
            [~,log_likelyhood5V,~]=viterbi(feaV2{i},A_v5,P0_v5,mu_v5,sigma_v5);
            if log_likelyhood2V>log_likelyhood5V
                corV2_v=corV2_v+1;
            end
            
            [~,log_likelyhood2AV,~]=viterbi(feaAV2{i},tempA_av2,tempP0_av2,tempmu_av2,tempsigma_av2);
            [~,log_likelyhood5AV,~]=viterbi(feaAV2{i},A_av5,P0_av5,mu_av5,sigma_av5);
            if log_likelyhood2AV>log_likelyhood5AV
                corAV2_v=corAV2_v+1;
            end
        else
            k=1;
            for j=1:10
                if j~=(i-10)
                    tempfeaA{k}=feaA2{j};
                    tempfeaV{k}=feaV2{j};
                    tempfeaAV{k}=feaAV2{j};
                    k=k+1;
                end
            end
            
            [tempP0_a5,tempA_a5,tempmu_a5,tempsigma_a5]=ghmm_learn(tempfeaA,N,Ainit);
            [tempP0_v5,tempA_v5,tempmu_v5,tempsigma_v5]=ghmm_learn(tempfeaV,N,Ainit);
            [tempP0_av5,tempA_av5,tempmu_av5,tempsigma_av5]=ghmm_learn(tempfeaAV,N,Ainit);
            
            [~,scale2A]=ghmm_fwd(feaA5{i-10},A_a2,P0_a2,mu_a2,sigma_a2);
            [~,scale5A]=ghmm_fwd(feaA5{i-10},tempA_a5,tempP0_a5,tempmu_a5,tempsigma_a5);
            if sum(scale2A)<sum(scale5A)
                corA5=corA5+1;
            end
            
            [~,scale2V]=ghmm_fwd(feaV5{i-10},A_v2,P0_v2,mu_v2,sigma_v2);
            [~,scale5V]=ghmm_fwd(feaV5{i-10},tempA_v5,tempP0_v5,tempmu_v5,tempsigma_v5);
            if sum(scale2V)<sum(scale5V)
                corV5=corV5+1;
            end
            
            [~,scale2AV]=ghmm_fwd(feaAV5{i-10},A_av2,P0_av2,mu_av2,sigma_av2);
            [~,scale5AV]=ghmm_fwd(feaAV5{i-10},tempA_av5,tempP0_av5,tempmu_av5,tempsigma_av5);
            if sum(scale2AV)<sum(scale5AV)
                corAV5=corAV5+1;
            end
            
            [~,log_likelyhood2A,~]=viterbi(feaA5{i-10},A_a2,P0_a2,mu_a2,sigma_a2);
            [~,log_likelyhood5A,~]=viterbi(feaA5{i-10},tempA_a5,tempP0_a5,tempmu_a5,tempsigma_a5);
            if log_likelyhood2A<log_likelyhood5A
                corA5_v=corA5_v+1;
            end
            
            [~,log_likelyhood2V,~]=viterbi(feaV5{i-10},A_v2,P0_v2,mu_v2,sigma_v2);
            [~,log_likelyhood5V,~]=viterbi(feaV5{i-10},tempA_v5,tempP0_v5,tempmu_v5,tempsigma_v5);
            if log_likelyhood2V<log_likelyhood5V
                corV5_v=corV5_v+1;
            end
            
            [~,log_likelyhood2AV,~]=viterbi(feaAV5{i-10},A_av2,P0_av2,mu_av2,sigma_av2);
            [~,log_likelyhood5AV,~]=viterbi(feaAV5{i-10},tempA_av5,tempP0_av5,tempmu_av5,tempsigma_av5);
            if log_likelyhood2AV<log_likelyhood5AV
                corAV5_v=corAV5_v+1;
            end
        end
    end
    Acc=zeros(3,3);
    Acc(1,1)=corA2/10;
    Acc(1,2)=corV2/10;
    Acc(1,3)=corAV2/10;
    Acc(2,1)=corA5/10;
    Acc(2,2)=corV5/10;
    Acc(2,3)=corAV5/10;
    Acc(3,1)=(corA2+corA5)/20;
    Acc(3,2)=(corV2+corV5)/20;
    Acc(3,3)=(corAV2+corAV5)/20;
    fprintf('\n -------- Accurcy: Forward Backward ---------\n ');
    table = array2table(Acc,'VariableNames',{'Audio_Recognition','Video_Recognition','AV_Recognition'},'RowNames',{'2','5','Overall'});
    display(table);
    fprintf('---------------------------------------\n');
    
    Acc_v=zeros(3,3);
    Acc_v(1,1)=corA2_v/10;
    Acc_v(1,2)=corV2_v/10;
    Acc_v(1,3)=corAV2_v/10;
    Acc_v(2,1)=corA5_v/10;
    Acc_v(2,2)=corV5_v/10;
    Acc_v(2,3)=corAV5_v/10;
    Acc_v(3,1)=(corA2_v+corA5_v)/20;
    Acc_v(3,2)=(corV2_v+corV5_v)/20;
    Acc_v(3,3)=(corAV2_v+corAV5_v)/20;
    fprintf('\n -------- Accurcy: Viterbi ---------\n ');
    table = array2table(Acc_v,'VariableNames',{'Audio_Recognition','Video_Recognition','AV_Recognition'},'RowNames',{'2','5','Overall'});
    display(table);
    fprintf('---------------------------------------\n');
end

