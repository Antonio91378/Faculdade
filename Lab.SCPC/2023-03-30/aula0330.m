clc
pkg load control

% Kp = 1/8,1/2,1
% Ti = 140;
%
% Kp = 7
% Ti = 50, 100, 200;
Ti = 200; % mudando essa variável eu mudo a frewuencia da funcao com o controlador
Kp = 7;

t = linspace(0,1000,400);
Gp = tf(8,[140 1]);
Gc = tf(Kp*[Ti,1],[Ti,0]);
GMA = minreal(Gp*Gc);
GMF = GMA/(1+GMA);
[yp,t]= step(Gp/8,t);
[y,t] = step(GMF,t);
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

%vermelho planta + o controlador



