function [ pca,N ] = feature_pca_gram( data,energy_percent )
%FEATURE_PCA Summary of this function goes here
%   Detailed explanation goes here
    Xhat=bsxfun(@minus,data,mean(data,2))./(sqrt(size(data,2)-1));
    gram=transpose(Xhat)*Xhat;
    [V,D]=eig(gram);
    eigvals=diag(D);
    [~,sorted_idx]=sort(eigvals,'descend');
    energy = 0;
    i=1;
    while energy<sum(eigvals)*energy_percent
        energy=energy+eigvals(sorted_idx(i));
        i=i+1;
    end
    N=i-1;
    topV=zeros(40,N);
    for i=1:N
        topV(:,i)=V(:,sorted_idx(i));
    end
    pca=transpose(Xhat)*topV;
end

