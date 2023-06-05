%ex10 Antônio Víctor
clc;
clear;
pkg load control;

N = 5;
num_GMA = 4*N;
den_GMA = conv(conv([1 1], [1 2]), [1 2*N]);
GMA = tf(num_GMA, den_GMA);
mp = 0.1;

%1.a)====================================
msgbox('Para continuar, clique no gráfico para selecionar o ponto de intersecção da reta que define os 10% de OS com o lugar das raízes.');
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
[x, y] = ginput(1);
Px = x + 1i*y;
plot(real(Px),imag(Px), 'ro');

%findind Kp and plotting the sign of exit
k=-polyval(GMA.den{1},Px)/(polyval(GMA.num{1},Px));
k=abs(real(k))
GMF = feedback(k*GMA,1);
figure
hold on;
t = 0:0.01:20;
[PV, t] = step(GMF, t);
plot(t,PV,'color','#006400');
grid on;

% Plotting the max and the regime values of PV
ultimo_valor_y = PV(end);
x_linha_tracejada = [t(1), t(end)];
y_linha_tracejada = [PV(end), PV(end)];
plot(x_linha_tracejada, y_linha_tracejada, '--r');
valor_ponto = PV(end);
texto = ['PV de regime: ' num2str(valor_ponto)];
text(t(end), PV(end), texto, 'VerticalAlignment', 'bottom');

[valor_maximoPV, indice_maximoPV] = max(PV);
yMax_linha_tracejada = [valor_maximoPV, valor_maximoPV];
plot(x_linha_tracejada, yMax_linha_tracejada, '--r');
texto = ['PV de Pico: ' num2str(valor_maximoPV)];
text(t(indice_maximoPV), PV(indice_maximoPV), texto, 'VerticalAlignment', 'bottom');

xlabel('Tempo')
ylabel('Saída (PV)')
title('Resposta ao Degrau do Sistema em Malha Fechada, PV verde: sem o integracor, PV laranja: com')

%1.b)====================================
e_reg = 1/ (1+ k)
hold off;

%1.c)====================================
num_integrator = [1 e_reg];
den_integrator = [1 0];
integrator = tf(num_integrator, den_integrator);

num_GMA_Integrator = conv(num_GMA, num_integrator);
den_GMA_Integrator = conv(den_GMA, den_integrator);

GMA_Integrator = tf(num_GMA_Integrator, den_GMA_Integrator);
figure
msgbox('Para continuar, clique no gráfico para selecionar o novo ponto de intersecção da reta que define os 10% de OS com o lugar das raízes. Ignore o ponto já marcado anteriormente');
rlocus(GMA_Integrator);

%findind the new Kp and plotting the sign of exit again
legend off;
hold on;
plot(imaginaryAxis, realAxis, 'k');
plot(realAxis, imaginaryAxis, 'k');

%ploting the phaseAngle
plot(phaseAngleStraight, phaseAngleFunction);
Px = x + 1i*y;
plot(real(Px),imag(Px), 'ro');
[x1, y1] = ginput(1);
Px1 = x1 + 1i*y1;
plot(real(Px1),imag(Px1), 'ro');

k1=-polyval(GMA_Integrator.den{1},Px1)/(polyval(GMA_Integrator.num{1},Px1));
k1=abs(real(k1))
GMF1 = feedback(k1*GMA_Integrator,1);
figure 2
hold on;
t = 0:0.01:20;
[PV1, t] = step(GMF1, t);
plot(t,PV1,'color','#ff8c00');
grid on;

