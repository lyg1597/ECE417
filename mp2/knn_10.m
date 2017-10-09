function result_idx=knn_1(input_idx,features)
    min_dist=Inf;
    for i=1:80
        if i~=input_idx
            dist=sum((features(:,input_idx)-features(:,i)).^2);
            if dist<min_dist
                min_dist=dist;
                result_idx=i;
            end
        end
    end