clc
dados=load('MA_CRP_09032023.txt');
t=dados(2;
t=dados(:,2);
pv=dados(:,3);
mv=dados(:,4);
plot(t,pv,t,mv)
[x,y]=ginput(2)
idx = find(t>x(1),1)
t(idx)
pv(idx)
hold on
plot(t(idx),pv(idx),'o')
idx2 = find(t>x(2),2
idx2 = find(t>x(2),2)
idx2 = find(t>x(2),1)
plot(t(idx2),pv(idx2),'o')
idxs = find(mv(idx:idx2)>26,1)
idxs = find(mv(idx:idx2)>26,1)+idx
plot(t(idxs),pv(idxs),'o')
plot(t(idxs),mv(idxs),'o')
idxs = find(mv(idx:idx2)>26,1)+idx-1
plot(t(idxs),pv(idxs),'x')
plot(t(idxs),mv(idxs),'x')