function [gm] = gen_samples(error_data)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    gm = fitgmdist(error_data,2);
end

