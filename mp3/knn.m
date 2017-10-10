function [ error_rate ] = knn(data, dlabels, samples, slabels, k)
    %N1 is the number of rows
    %N2 is the number of columns
    %data is the (M, N) dimension pictures data
    %dlabels is (1, N) dimension label indicating type
    %samples is the (M, K) dimension pictures data
    %slabels is the (1,K) dimension pictures data
    %k is the how many neighbors to determine type
    %error_rate is the validation error
    [~,sample_size] = size(samples);
    plabels_total = zeros(k, sample_size);
    D = pdist2((data.'), (samples.'));
    [~, sorted_index] = sort(D);
    [~, sorted_index_size] = size(sorted_index);
    for i = 1:k
        for j = 1:sorted_index_size
            plabels_total(i,j) = dlabels(sorted_index(i,j));
        end
    end
    if k > 1
        plabels = mode(plabels_total);
    else 
        plabels = plabels_total;
    end
    error_rate = sum(plabels==slabels)/sample_size;
end

