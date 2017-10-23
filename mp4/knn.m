function [result_idx,class]=knn(input,features)
    dist=zeros(1,40);
    for i=1:40
        dist(1,i)=sum((input-features(:,i)).^2);
    end
    [~,sorted_idx]=sort(dist,'ascend');
    result_idx=sorted_idx(1,2:10+1);
    top_n=fix((result_idx-1)./20);
    class=mode(top_n);
end
