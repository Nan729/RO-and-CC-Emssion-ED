function[H]= GSDF(linedata)
branches=size(linedata,1);
% linedata=linedata';
fbus=linedata(:,1);
tbus=linedata(:,2);
x=linedata(:,3);
y=1./x;
buses=max(max(fbus),max(tbus));
ybus=zeros(buses,buses);
for i=1:branches
    if fbus(i)>0 && tbus(i)>0
        ybus(fbus(i),tbus(i))=-y(i);
        ybus(tbus(i),fbus(i))=ybus(fbus(i),tbus(i));
    end
end
for i=1:buses
    for j=1:branches
        if fbus(j)==i || tbus(j)==i
            ybus(i,i)=ybus(i,i)+y(j);
        end
    end
end
k=1i*ybus;
% disp('Bus Admittance Matrix ');
% disp(k);
for i=2:buses
    for j=2:buses
        q(i-1,j-1)=k(i,j);
    end
end    
p=1i*q^-1;
% disp(' Impedance Matrix for buses other than Slack Bus ');
% disp(p);
w=zeros(buses,buses);
for i=1:buses
    for j=1:buses
        if i~=1 && j~=1
            w(i,j)=p(i-1,j-1);
        end
    end
end
% disp(' Sensitivity factor matrix ');
% disp(w);
% disp(' Generation shift factor Matrix ');
for i=1:branches
    for j=2:buses
        H(i,j)=(w(fbus(i),j)-w(tbus(i),j))/x(i);
    end
end
% disp(a);
end
