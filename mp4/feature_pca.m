function [pca,N] = feature_pca(X,energy_percent)
%FEATURE_PCA Summary of this function goes here
%   Detailed explanation goes here
    Z=bsxfun(@minus,X,mean(X,2));
    S=(1/(80-1))*(Z*transpose(Z));
    [V,D]=eig(S);
    eigvals=diag(D);
    [~,sorted_index]=sort(eigvals,'descend');
    energy = 0;
    i=1;
    while energy<sum(eigvals)*energy_percent
        energy=energy+eigvals(sorted_index(i));
        i=i+1;
    end
    N=i-1;
    topV=zeros(6300,N);
    for i=1:N
        topV(:,i)=V(:,sorted_index(i));
    end
    
    pca=transpose(topV)*Z;
end

