function [pca,N] = feature_pca(X,energy_percent)
    Z=bsxfun(@minus,X,mean(X,2));
    S1=(1/(80-1))*(Z*transpose(Z));
    S2=(1/(80-1))*(transpose(Z)*Z);
    [V1,D1]=eig(S1);
    [V2,D2]=eig(S2);
    V3=(1/sqrt(79))*Z*V2;
    eigvals1=diag(D1);
    eigvals2=diag(D2);
    [~,sorted_index1]=sort(eigvals1,'descend');
    [~,sorted_index2]=sort(eigvals2,'descend');
    energy = 0;
    i=1;
    while energy<sum(eigvals1)*energy_percent
        energy=energy+eigvals1(sorted_index1(i));
        i=i+1;
    end
    N=i-1;
    topV1=zeros(6300,N);
    for i=1:N
        topV1(:,i)=V1(:,sorted_index1(i));
    end
    
    energy = 0;
    i=1;
    while energy<sum(eigvals2)*energy_percent
        energy=energy+eigvals2(sorted_index2(i));
        i=i+1;
    end
    N=i-1;
    topV2=zeros(6300,N);
    for i=1:N
        topV2(:,i)=V3(:,sorted_index2(i));
    end
        
    pca=transpose(topV1)*Z;

end