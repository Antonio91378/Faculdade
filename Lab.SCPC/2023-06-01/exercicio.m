clc;
clear;
pkg load control;

N = 5;
num = 1;
den = conv(conv([1 0], [1 1]), [1 5]);
GMA = tf(num, den);

%1
%a)=================================================
rlocus(GMA);
legend off;
hold on;
imaginaryAxis = linspace(-20, 20);
realAxis = zeros(size(imaginaryAxis));
plot(imaginaryAxis, realAxis, 'k');
plot(realAxis, imaginaryAxis, 'k');

%b===================================================
%calculating damping factor
df = (-log(10/100)) / sqrt((pi^2) + (log(10/100))^2);
phaseAngle = 180 - acosd(df);
%ploting the phaseAngle
phaseAngleStraight = linspace(0,-30);
phaseAngleFunction = tand(phaseAngle)*phaseAngleStraight;
plot(phaseAngleStraight, phaseAngleFunction);
[x, y] = ginput(1);
Px = x + 1i*y;
%c===================================================
plot(real(Px),imag(Px), 'ro');

%d===================================================
k=-polyval(GMA.den{1},Px)/(polyval(GMA.num{1},Px));
k=abs(real(k))

%e===================================================
GMF = feedback(k*GMA,1);
figure
hold on;
t = 0:0.01:20;
[PV, t] = step(GMF, t);
plot(t,PV,'g');
grid on;
realAxis = ones(size(imaginaryAxis));
idealMp = repmat(1.1, 1, size(imaginaryAxis));
imaginaryAxis = linspace(0, 20);
plot(imaginaryAxis,realAxis,'--r');
plot(imaginaryAxis,idealMp,'--r');
xlabel('Tempo')
ylabel('Saída (PV)')
title('Resposta ao Degrau do Sistema em Malha Fechada')
idxMax = find(PV >= max(PV),1);
tp = t(idxMax)
plot(tp,PV(idxMax),'ro');
hold off;

%f============================================NÃO DEU TEMPO, MAS EU TAVA QUASE LÁ
figure 1;
plot(real(Px)*3,imag(Px)*3, 'ro');
pG = eig(GMA);
px3 = Px*3;
ang_polos = arg(px3-pG)*180/pi
ang_Pd = sum(ang_polos) - 180;
poloPd = imag(px3) / tand(180 - ang_Pd);
poloPd = real(px3) - poloPd;
plot(poloPd,0, 'ro');
GPd = tf([1 poloPd], 1);
GMF2 = feedback(GPd*GMF,1);
figure 2
[PV2, t] = step(GMF2, t);
hold on
plot(t,PV2,'g');
