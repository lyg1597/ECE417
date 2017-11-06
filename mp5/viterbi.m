function [delta, log_likelyhood, seq] = viterbi(Y,A,P0,mu,sigma)
    N = size(A,1); 
    T = size(Y,1);
    M = size(Y,2);
    delta = [];
    for j=1:N
        sigmai(1:M,1:M) = reshape(sigma(j,:,:),[M,M]);
        for t=1:T
            Pys(j,t) = sqrt(1/(((2*pi)^M)*det(sigmai)))*exp(-0.5*(Y(t,:)-mu(j,:))*inv(sigmai)*(Y(t,:)-mu(j,:))');
        end
    end
    
    P0=log(P0);
    Pys=log(Pys);
    A=log(A);
    delta1 = P0+Pys(:,1);
    seq = zeros(N,T);
    seq(:,1) = 1;
    delta(:,1)=delta1;
    
    for t=2:T
        [tmp,tmp_seq] = max(bsxfun(@plus,A,delta(:,t-1)));
        seq(:,t)=transpose(tmp_seq);
        delta(:,t) = transpose(tmp)+Pys(:,t-1);
    end
    log_likelyhood = max(delta(:,T));
end