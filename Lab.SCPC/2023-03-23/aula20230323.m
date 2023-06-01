clc
pkg load control
Gp = tf(8,[140 1]);
Ti = 140; % mudando essa variável eu mudo a frewuencia da funcao com o controlador
Gc = tf(1,[Ti 0]);
G = Gp*Gc;
GMF = G/(1+G);
[y,t] = step(GMF);
[yp,t]= step(Gp/8,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');

plot(t,0.95*sp,'g--');
plot(t,1.05*sp,'g--');

p = eig(GMF);%calcula os polos complexos do G de argumento

dt = -real(p(1));
TaMF = 3/dt; %Ta tempo de amortecimento
plot(TaMF,0.95,'r*');
pp = eig(Gp);
Tau = 1/abs(pp);
tap = 3*Tau;
plot(tap,0.95,'b*');
a = 0;
%vermelho planta + o controlador


