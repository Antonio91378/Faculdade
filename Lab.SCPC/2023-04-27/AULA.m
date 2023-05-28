clc
clear
pkg load control

%G = 1 / (S+1)
% Tau = inverso do polo = 1
%%%1))  Controle PD : Gpd = kp(1 + Tds)
% Kp => p/  Ereg = 10%
% a) Td = Tau/2
% b) Td = Tau
% c) td = 2T

%%%2)) Controle PID : GPID = Kp(1 + 1/Tis + Tds)
% Ti = tau
% Kp = Kp
% a) Td = Tau/2
% b) Td = Tau
% c) td = 2T

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.a)
t = linspace(0,6,250);
Td = 0.5;
Kp = 9;
Gp = tf(1,[1 1]);
S = tf('s');
Gc = Kp*(Td*S + 1);
GMA = minreal(Gp*Gc);
GMF = GMA/(1+GMA);
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('1A Diferença entre saída controlada e não controlada 0.5')
xlabel('tempo')
ylabel('saída')
clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.b)

figure % abre uma nova janela de plotagem
t = linspace(0,6,250);
Td = 1;
Kp = 9;
Gp = tf(1,[1 1]);
S = tf('s');
Gc = Kp*(Td*S + 1);
GMA = minreal(Gp*Gc);
GMF = GMA/(1+GMA);
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('1B Diferença entre saída controlada e não controlada Tau = 1')
xlabel('tempo')
ylabel('saída')
clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.c)
figure % abre uma nova janela de plotagem
t = linspace(0,6,250);
Td = 2;
Kp = 9;
Gp = tf(1,[1 1]);
S = tf('s');
Gc = Kp*(Td*S + 1);
GMA = minreal(Gp*Gc);
GMF = GMA/(1+GMA);
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('1C Diferença entre saída controlada e não controlada  Tau = 2')
xlabel('tempo')
ylabel('saída')
clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.a)
figure % abre uma nova janela de plotagem
t = linspace(0,6,250);
Td = 0.5;
Ti = 1; %Tau
Kp = 9;
Gp = tf(1,[1 1]);
S = tf('s');
Gc = Kp*(Td*S + 1 + (1/(Ti*S)));
GMA = minreal(Gp*Gc);
GMF = GMA/(1+GMA);
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('2A Diferença entre saída controlada e não controlada');
xlabel('tempo');
ylabel('saída');
clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.b)
figure % abre uma nova janela de plotagem
t = linspace(0,6,250);
Td = 1;%Tau
Ti = 1; %Tau
Kp = 9;
Gp = tf(1,[1 1]);
S = tf('s');
Gc = Kp*(Td*S + 1 + (1/(Ti*S)));
GMA = minreal(Gp*Gc);
GMF = GMA/(1+GMA);
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('2B Diferença entre saída controlada e não controlada');
xlabel('tempo');
ylabel('saída');
clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.c)
figure % abre uma nova janela de plotagem
t = linspace(0,6,250);
Td = 1;%Tau
Ti = 2; %Tau
Kp = 9;
Gp = tf(1,[1 1]);
S = tf('s');
Gc = Kp*(Td*S + 1 + (1/(Ti*S)));
GMA = minreal(Gp*Gc);
GMF = GMA/(1+GMA);
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('2C Diferença entre saída controlada e não controlada');
xlabel('tempo');
ylabel('saída');
clc
clear
