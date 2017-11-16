function [pca,N] = feature_pca_1(X,energy_percent)
    Z=bsxfun(@minus,X,mean(X,2));
    S1=(1/(80-1))*(Z*transpose(Z));
    [V1,D1]=eig(S1);

    eigvals1=diag(D1);
    [~,sorted_index1]=sort(eigvals1,'descend');
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

        
    pca=transpose(topV1)*Z;

end