function feature_CC = feature_cepstrum(signal, Ncc, Nw, No)
%FEATURE_CEPSTRUM Summary of this function goes here
%   Detailed explanation goes here
    feature_CC=[];
    for i=1:size(signal,2)
        feature_CC = cat(2,feature_CC,cepstrum(signal(:,i),Ncc,Nw,No));
    end

end

