function rand_feature = feature_random(raw_pixels,size)
    projection=randn(6300,size);
    rand_feature=transpose(projection)*raw_pixels;
end