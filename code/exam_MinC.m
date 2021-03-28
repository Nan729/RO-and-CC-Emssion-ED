function[flag_total]= exam_MinC(T,N,M,bb,d_f,p,q,H,fmax,gmin,gmax,umin,umax,x,fval,error_q)
    flag_total=1;
    G=reshape(x(1:T*N),N,T);
%     disp('generation:');
%     disp(G)
    U=reshape(x(T*N+1:2*T*N),N,T);
    disp('charging decision:');
    disp(U)
    D=d_f.';
    disp('line flow:');
    disp(H*(G-U-D))
    ff=H*(G-U-D);
%     ttt=min(H*(G-U-D)>=-fmax,[],'all');
    if (min(H*(G-U-D)<=fmax+error_q,[],'all')) && (min(H*(G-U-D)>=-(fmax+error_q),[],'all'))
        disp('line constraint satisfied')
    else
        disp('line constraint not satisfied')
        flag_total=0;
    end
    indi=ones(1,N);
    if (min(indi*(G-U-D)<=error_q,[],'all')) && (min(indi*(G-U-D)>=-error_q,[],'all'))
        disp('load balancing satisfied')
    else
        disp('load balancing not satisfied')
        flag_total=0;
    end
    X=reshape(x(2*T*N+1:3*T*N),N,T);
    flag=1;
    for t=2:T
        for n=1:N
            if (X(n,t)-X(n,t-1)-U(n,t)<=error_q)&&(X(n,t)-X(n,t-1)-U(n,t)>=-error_q)
            else
                flag=0;
            end
        end
    end
    for n=1:N
        if (X(n,T)>bb(n)/2+error_q)||(X(n,T)<bb(n)/2-error_q)
            flag=0;
        end
        if (X(n,1)>bb(n)/2+U(n,1)+error_q)||(X(n,1)<bb(n)/2+U(n,1)-error_q)
            flag=0;
        end
    end

    flag_1=min(X<=bb+error_q,[],'all');
    flag_2=min(X>=-error_q,[],'all');
    Fgl= [flag,flag_1,flag_2];
    flag=min(Fgl);
    if flag==1
        disp('state of charge satisfied')
    else
        disp('state of charge not satisfied')
        flag_total=0;
    end
    if (min(G<=gmax+error_q,[],'all')) && (min(G>=gmin-error_q,[],'all'))
        disp('generation constraint satisfied')
    else
        disp('generation constraint not satisfied')
        flag_total=0;
    end
    if (min(U<=umax+error_q,[],'all')) && (min(U>=umin-error_q,[],'all'))
        disp('storage ramping constraint satisfied')
    else
        disp('storage ramping constraint not satisfied')
        flag_total=0;
    end
    
    C=reshape(x(3*T*N+1:4*T*N),N,T);
    if (sum(C,'all')<=fval+error_q) && (sum(C,'all')>=fval-error_q)
        disp('objective function correct')
    else
        disp('objective function not correct')
        flag_total=0;
    end
    flag_3=1;
    max_C=zeros(N,T);
    for t=1:T
        for n=1:N
            for i=1:size(p,1)
                if (p(i,n)*G(n,t)+q(i,n)>max_C(n,t))
                    max_C(n,t)=p(i,n)*G(n,t)+q(i,n);
                end
            end
            if (max_C(n,t)<C(n,t)-error_q) ||(max_C(n,t)>C(n,t)+error_q)
                flag_3=0;
            end
        end
    end
    if flag_3==1
        disp('piece-wise linear satisfied')
    else
        disp('piece-wise linear not satisfied')
        flag_total=0;
    end
    if flag_total==1
        disp('PASS!')
    else
        disp('Failed!')
    end
end