function [result_idx,class]=knn(input_idx,features,dim)
    dist=zeros(1,80);
    for i=1:80
        dist(1,i)=sum((features(:,input_idx)-features(:,i)).^2);
    end
    [~,sorted_idx]=sort(dist,'ascend');
    result_idx=sorted_idx(1,2:dim+1);
    top_n=fix((result_idx-1)./20);
    class=mode(top_n);
end
