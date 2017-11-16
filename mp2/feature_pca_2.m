function [ pca,N ] = feature_pca_2(X,energy_percent )
%FEATURE_PCA_2 Summary of this function goes here
%   Detailed explanation goes here
    Z=bsxfun(@minus,X,mean(X,2));
    S2=(1/(80-1))*(transpose(Z)*Z);
    [V2,D2]=eig(S2);
    eigvals2=diag(D2);
    [~,sorted_index2]=sort(eigvals2,'descend');
    V3=(1/sqrt(79))*Z*V2;
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
    pca=transpose(topV2)*Z;

end

