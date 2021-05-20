function [x,fval]=MinC(T,N,M,bb,d_f,p,q,H,fmax,gmin,gmax,umin,umax,DR,UR)
% parameters: delta:n  bb:n  d^f_n,t:n*T 
% coefficients: k -- p & q
% Generator shift factor matrix; H
% line capacity: fmax
% Optimization problem: linear optimation
% variables: [1,24] g_n,t / [25,48] u_n,t / [49,72] x_n,t [73.96] c_n,t
% x: 3*T*N+ T*N

% Optimization Goal: c
f=zeros(1,T*N*4);
f(T*N*3+1:T*N*4)=1;

% Constraits:
% The optimiztaion goal:piece-wise linear --- A1
k=size(p,1);
A1=zeros(k*T*N,T*N*4);
b1=zeros(k*T*N,1);
for i=1:k
    for t=1:T
        for n=1:N
            A1((i-1)*T*N+(t-1)*N+n,(t-1)*N+n)=p(i,n);
            A1((i-1)*T*N+(t-1)*N+n,T*N*3+(t-1)*N+n)=-1;
            b1((i-1)*T*N+(t-1)*N+n,1)=-q(i,n);
        end
    end
end

% The load balancing -- Aeq1
Aeq1=zeros(T,T*N*4);
beq1=d_f*ones(N,1);
for t=1:T
    Aeq1(t,((t-1)*N+1):(t*N))=1;
    Aeq1(t,(N*T+(t-1)*N+1):(N*T+t*N))=-1;
end

% The state of charge -- Aeq2,3,4
Aeq2=zeros((T-1)*N,T*N*4);
beq2=zeros(T*N,1);
for t=2:T
    for n=1:N
        Aeq2((t-1)*N+n,T*N*2+(t-1)*N+n)=1;
        Aeq2((t-1)*N+n,T*N*2+(t-2)*N+n)=-1;
        Aeq2((t-1)*N+n,T*N+(t-1)*N+n)=-1;
    end
end
Aeq3=zeros(N,T*N*4);
beq3=zeros(N,1);
for n=1:N
    Aeq3(n,T*N*2+(T-1)*N+n)=1;
    beq3(n,1)=bb(n,1)/2;
end

Aeq4=zeros(N,T*N*4);
beq4=zeros(N,1);
for n=1:N
    Aeq4(n,T*N*2+n)=1;
    Aeq4(n,T*N+n)=-1;
    beq4(n,1)=bb(n,1)/2;
end

% line capacity constraints -- A2 A3
% A2=zeros(T*M,T*N*4);
% b2=zeros(T*M,1);
A2_g=H;
b2_f=fmax;
for t=1:(T-1)
    A2_g=blkdiag(A2_g,H);
    b2_f=[b2_f;fmax];
end
b2_d=reshape(H*(d_f.'),[],1);
A2_u=-A2_g;
A2_x=zeros(T*M,T*N);
A2_c=zeros(T*M,T*N);
A2=[A2_g,A2_u,A2_x,A2_c];
b2=b2_f+b2_d;

A3=-A2;
b3=b2_f-b2_d;

% ramping constraints: A4 & A5
A4=zeros(N*(T-1),T*N*4);
b4=[];
b5=[];
for n=1:N
    for t=1:T-1
        ind=(n-1)*(T-1)+t;
        A4(ind,t*N+n)=1;
        A4(ind,(t-1)*N+n)=-1;
    end
    b4=[b4;ones(T-1,1).*UR(n)];
    b5=[b5;ones(T-1,1).*DR(n)];
end
A5=-A4;


% lower bound upper bound constraints-- lb ub
lb_g=gmin;
ub_g=gmax;
lb_u=umin;
ub_u=umax;
ub_x=bb;
for t=1:(T-1)
    lb_g=[lb_g;gmin];
    ub_g=[ub_g;gmax];
    lb_u=[lb_u;umin];
    ub_u=[ub_u;umax];
    ub_x=[ub_x;bb];
end
lb_x=zeros(T*N,1);
lb_c=-Inf(T*N,1);
ub_c=Inf(T*N,1);
lb=[lb_g,lb_u,lb_x,lb_c];
ub=[ub_g,ub_u,ub_x,ub_c];

A=[A1;A2;A3;A4;A5];
b=[b1;b2;b3;b4;b5];
Aeq=[Aeq1;Aeq2;Aeq3;Aeq4];
beq=[beq1;beq2;beq3;beq4];
% linear optimization
% [x,fval,exitflag,output,lambda]=linprog(f,A,b,Aeq,beq,lb,ub);
[x,fval]=linprog(f,A,b,Aeq,beq,lb,ub);










