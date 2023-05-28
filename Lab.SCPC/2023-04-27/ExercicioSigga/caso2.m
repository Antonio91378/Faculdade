clc
clear
pkg load control

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf;
subplot(1, 2, 1);
t = linspace(0,10,400);
S = tf('s');
Gp = 1/((S+10)*(S+1));
Kp = 15;
Gc = Kp;
GMA = minreal(Gp*Gc);
GMF = minreal(GMA/(1+GMA));
GMA2 = GMF/S;
rlocus(GMA2);
PX = -1.32 + 1i;
hold on;
plot(real(PX), imag(PX),'rs');
ki = -polyval(GMA2.den{1},PX)/polyval(GMA2.num{1},PX)
ki = abs(ki)
GMF2 = feedback(ki*GMA2,1);
PMF2 = eig(GMF2);
plot(real(PMF2), imag(PMF2),'g*','linewidth',1.2,'markersize',5);

subplot(1, 2, 2);
[yp,t]= step(Gp,t);
hold on;
[y1,t] = step(GMF,t);
[y2,t] = step(GMF2,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y1,'r');
plot(t,y2,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
