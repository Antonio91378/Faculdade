clc
clear
pkg load control

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1)
subplot(2, 1, 1);
t = linspace(0,300,400);
tau1= 42;
tau2= 1;
Kp = 1;
S = tf('s');
Gp = 1/((42*S+1)*(S+1));
Gc = Kp;
GMA = minreal(Gp*Gc);
GMF = minreal(GMA/(1+GMA));
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('Controle Proporcional. Kp = 1')
xlabel('tempo')
ylabel('saída (GReg)')

subplot(2, 1, 2);
rlocus(GMA);
title('Lugar das raízes');
xlabel('tempo');
ylabel('saída (GReg)');
hold on;
PMF = eig(GMF);
plot(real(PMF), imag(PMF),'rs');
legend of;
clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.B)
figure
subplot(2, 1, 1);
t = linspace(0,300,400);
tau1= 42;
tau2= 1;
Kp = 3;
S = tf('s');
Gp = 1/((42*S+1)*(S+1));
Gc = Kp;
GMA = minreal(Gp*Gc);
GMF = minreal(GMA/(1+GMA));
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('Controle Proporcional. Kp = 3')
xlabel('tempo')
ylabel('saída (GReg)')

subplot(2, 1, 2);
rlocus(GMA);
title('Lugar das raízes');
xlabel('tempo');
ylabel('saída (GReg)');
hold on;
PMF = eig(GMF);
plot(real(PMF), imag(PMF),'rs');
legend of;
clc
clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2)

figure
subplot(2, 1, 1);
t = linspace(0,300,400);
tau1= 42;
tau2= 1;
Kp = 3;
S = tf('s');
Gp = 1/((42*S+1)*(S+1));
Gc = Kp*(1+(1/(tau1*S)));;
GMA = minreal(Gp*Gc);
GMF = minreal(GMA/(1+GMA));
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('Controle Proporcional Integrador. Kp = 3')
xlabel('tempo')
ylabel('saída (GReg)')

subplot(2, 1, 2);
rlocus(GMA);
title('Lugar das raízes');
xlabel('tempo');
ylabel('saída (GReg)');
hold on;
PMF = eig(GMF);
plot(real(PMF), imag(PMF),'rs');
legend of;
clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3)
figure
subplot(2, 1, 1);
t = linspace(0,300,400);
tau1= 42;
tau2= 1;
Kp = 3;
S = tf('s');
Gp = 1/((42*S+1)*(S+1));
Gc = Kp*(1+tau1*S);
GMA = minreal(Gp*Gc);
GMF = minreal(GMA/(1+GMA));
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('Controle Proporcional Derivativo. Kp = 3')
xlabel('tempo')
ylabel('saída (GReg)')

subplot(2, 1, 2);
rlocus(GMA);
title('Lugar das raízes');
xlabel('tempo');
ylabel('saída (GReg)');
hold on;
PMF = eig(GMF);
plot(real(PMF), imag(PMF),'rs');
legend of;
clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3)
figure
subplot(2, 1, 1);
t = linspace(0,300,400);
tau1= 42;
tau2= 1;
Kp = 3;
S = tf('s');
Gp = 1/((42*S+1)*(S+1));
Gc =  Kp*(1+(1/(tau2*S))+tau1*S);
GMA = minreal(Gp*Gc);
GMF = minreal(GMA/(1+GMA));
[yp,t]= step(Gp,t);
[y,t] = step(GMF,t);
sp = ones(size(t));
plot(t,sp,'k');
hold on;
plot(t,yp,'b');
plot(t,y,'r');
plot(t,0.90*sp,'g--');
plot(t,1.10*sp,'g--');
title('Controle PID. Kp = 3')
xlabel('tempo')
ylabel('saída (GReg)')

subplot(2, 1, 2);
rlocus(GMA);
title('Lugar das raízes');
xlabel('tempo');
ylabel('saída (GReg)');
hold on;
PMF = eig(GMF);
plot(real(PMF), imag(PMF),'rs');
legend of;
clc
clear
