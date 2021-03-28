function [gm] = gen_samples(error_data)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    gm = fitgmdist(error_data,2);
end

