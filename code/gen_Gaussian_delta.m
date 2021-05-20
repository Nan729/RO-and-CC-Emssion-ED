function [delta]=gen_Gaussian_delta(mu,sigma,epsilon)
    e=1e-3;
    % assume the delta takes value in mu+4sigma , mu-4sigma
    a=0;
    b=abs(mu-4*sigma);
    object=1;
    while (abs(object-epsilon)>e)
        x=(a+b)/2;
        object=(1-normcdf(x,mu,sigma))+(normcdf(-x,mu,sigma));
        if object>epsilon
            a=x;
        else
            b=x;
        end
    end
    delta=x;
end