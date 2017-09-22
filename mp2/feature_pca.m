function [pca,N] = feature_pca(X,energy_percent)
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
    %error checking
    Xhat=bsxfun(@plus,topV*pca,mean(X,2));
    est_error=sum(sum(abs(X-Xhat).^2,1))/(80-1);
    true_error=sum(eigvals(sorted_index(N+1:length(sorted_index))));
    if round(est_error) ~= round(true_error)
        display('fuck!');
    end
end