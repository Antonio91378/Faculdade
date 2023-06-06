clc;
clear;
pkg load control;

mp = 0.2;
GMA = zpk([],[0 -6 -10],1);

figure 1;  clf;
rlocus(GMA);
legend off;
hold on;
imaginaryAxis = linspace(-20, 20);
realAxis = zeros(size(imaginaryAxis));
plot(imaginaryAxis, realAxis, 'k');
plot(realAxis, imaginaryAxis, 'k');

%calculating damping factor
df = (-log(mp)) / sqrt((pi^2) + (log(mp))^2);
phaseAngle = 180 - acosd(df);

%ploting the phaseAngle
phaseAngleStraight = linspace(0,-30);
phaseAngleFunction = tand(phaseAngle)*phaseAngleStraight;
plot(phaseAngleStraight, phaseAngleFunction);

msgbox({'Para continuar, clique no gráfico para selecionar ';
'o ponto de intersecção da reta que define os 10% de OS';
'com o cruzamento do lugar das raízes.'});

[x, y] = ginput(1);
Px = x + 1i*y;
plot(real(Px),imag(Px), 'ro');

%findind Kp and plotting the sign of exit
k=-polyval(GMA.den{1},Px)/(polyval(GMA.num{1},Px));
k=abs(real(k))
GMF = feedback(k*GMA,1);
figure 2; clf;
hold on;
t = 0:0.01:20;
[PV, t] = step(GMF, t);
plot(t,PV,'color','#006400');
grid on;
