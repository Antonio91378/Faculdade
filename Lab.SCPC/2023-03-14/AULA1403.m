clc
pkg load control
dados=load('MA_CRL_14_03_2023.txt');
t=dados(:,2);
pv=dados(:,3);
mv=dados(:,4);
plot(t,pv,t,mv)
[x,y]=ginput(1);
ti = x
idx0 = find(mv > 61, 1)-1;
t0 = t(idx0);
idxi = find(t>=ti,1);
ti = t(idxi);
hold on;
plot(t(idx0),pv(idx0),'o');
pvi = mean(pv(idxi:idx0));
[x,y]=ginput(2);
t2 = x(1)
t3 = x(2)
idx2 = find(t>=t2,1);
idx3 = find(t>=t3,1);
pvf = mean(pv(idx2:idx3));
idx1 = find(pv>=0.63*(pvf-pvi)+pvi,1);
t1 = t(idx1);
tau = t1-t0;
dpv = pvf-pvi;
mvi=mean(mv(idxi:idx0));
mvf=mean(mv(idx2:idx3))
dmv=mvf-mvi;
g=tf(dpv/dmv,[tau 1])

hold on
ts = t(idx0:idx3)-t(idx0);;
[y,ts] = step(dmv*g,ts);
plot(ts+t0,y+pvi,'linewidth',2,'yellow')





