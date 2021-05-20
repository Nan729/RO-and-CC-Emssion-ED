function[P_form_1,P_form_2]=gen_Azuma(p,tau_value,T)
    P_true_inverse=zeros(length(tau_value),1);
    P_azuma_tight=zeros(length(tau_value),1);
    for k=1:length(tau_value)
        tau=tau_value(k);
        c=4*(tau-p*T)/T;
        P_azuma_tight(k)=([(1-p).*exp(-c.*p)+p.*exp(c.*(1-p))]^T)*exp(-c*(tau-p*T));
        for i=0:1:tau
            P_true_inverse(k)=P_true_inverse(k)+nchoosek(T,i).*(p.^i).*((1-p).^(T-i));
        end
    end
    P_form_1=1-P_true_inverse;
    P_form_2=P_azuma_tight;
end