function [prob,result_idx]=knn(input,features)
    [~,col]=size(features);
    dist=zeros(1,col);
    for i=1:col
        dist(1,i)=sum((input-features(:,i)).^2);
    end
    [~,sorted_idx]=sort(dist,'ascend');
    result_idx=sorted_idx(1,1:10);
    top_n=fix((result_idx-1)./(col/4))+1;
    prob=zeros(1,4);
    for i=1:length(top_n)
        if(top_n(i)==1)
            prob(1,1)=prob(1,1)+1;
        elseif(top_n(i)==2)
            prob(1,2)=prob(1,2)+1;
        elseif(top_n(i)==3)
            prob(1,3)=prob(1,3)+1;
        else
            prob(1,4)=prob(1,4)+1;
        end
    end
    prob=prob./10;
end
