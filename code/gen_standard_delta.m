function[standard_delta,real_bb]= gen_standard_delta(bb,virtual_bb,w_loc)
    standard_delta=1-min(virtual_bb./bb);
    real_bb=bb.*(1-standard_delta);
    for i=1:size(bb,1)
        if real_bb(i)<0
            real_bb(i)=0;
        end
        if ~(ismember(i,w_loc))
            real_bb(i)=bb(i);
        end
    end
end