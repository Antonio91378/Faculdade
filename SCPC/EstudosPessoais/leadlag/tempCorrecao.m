%ex10 Antônio Ví­ctor
clc;
clear;
pkg load control;

N = 5;
num_GMA = 4*N;
den_GMA = conv(conv([1 1], [1 2]), [1 2*N]);
GMA = tf(num_GMA, den_GMA);
mp = 0.1;

%1.a)====================================
% ##### OBSERVAÇÃO #####
% ### Chamar a figura antes de plotar novo gráfico:
figure(1); clf;     % limpar a figura na 1ª vez
% ##### OBSERVAÇÃO #####
% ### Apresentar a MsgBox em várias linhas
msgbox({'Para continuar, clique no gráfico para selecionar ';
        'o ponto de intersecção da reta que define os 10% de';
        'cruzamento com o lugar das raízes.'});
%msgbox('Para continuar, clique no gráfico para selecionar o ponto de intersecção da reta que define os 10% de OS com o lugar das raízes.');
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
axis([-2.1 0.1 -0.1 2.1]); % ### Zoom no R.L. para escolha do ponto de cruzamento
%[x, y] = ginput(1);
%Px = x + 1i*y;
Px = -1.3051 + 1.7803i; % ### Px obtido na nova interseção
plot(real(Px),imag(Px), 'ro');

%findind Kp and plotting the sign of exit
k=-polyval(GMA.den{1},Px)/(polyval(GMA.num{1},Px));
k=abs(real(k))
GMF = feedback(k*GMA,1);

% ##### OBSERVAÇÃO #####
% ### Quando se usa apenas "figure", uma nova figura é criada
% ### (às vezes isso não é interessante pois vai criando cada vez mais figuras)
figure(2); clf; % limpar a figura na 1ª vez
%figure
% ##### OBSERVAÇÃO #####

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
ylabel('Saí­da (PV)')
title('Resposta ao Degrau do Sistema em Malha Fechada, PV verde: sem o integracor, PV laranja: com')

%1.b)====================================
e_reg = 1/ (1+ k)
hold off;

%1.c)====================================

% ##### CORREÇÃO #####
% ### A escolha do ero do integrador
%     não tem relação com o e_reg do controle Proporcional:
%     Pode-se testar vários valores para zc:
%zc = -0.5;
zc = -1.0;
%zc = -1.5;
num_integrator = [1 -zc];
%num_integrator = [1 e_reg];
% ##### CORREÇÃO #####

den_integrator = [1 0];
integrator = tf(num_integrator, den_integrator);

num_GMA_Integrator = conv(num_GMA, num_integrator);
den_GMA_Integrator = conv(den_GMA, den_integrator);

GMA_Integrator = tf(num_GMA_Integrator, den_GMA_Integrator);

% ##### OBSERVAÇÃO #####
% ### Quando se usa apenas "figure", uma nova figura é criada
% ### (às vezes isso não é interessante pois vai criando cada vez mais figuras)
figure(1)
%figure
% ##### OBSERVAÇÃO #####

% ##### OBSERVAÇÃO #####
% ### Apresentar a MsgBox em várias linhas
msgbox({'Para continuar, clique no gráfico para selecionar ';
        'o novo ponto de intersecção da reta que define os 10% de';
        'cruzamento com o lugar das raízes.'});
%msgbox('Para continuar, clique no gráfico para selecionar o novo ponto de intersecção da reta que define os 10% de OS com o lugar das raízes. Ignore o ponto jÃ¡ marcado anteriormente');
rlocus(GMA_Integrator);

%findind the new Kp and plotting the sign of exit again
legend off;
hold on;
plot(imaginaryAxis, realAxis, 'k');
plot(realAxis, imaginaryAxis, 'k');

%ploting the phaseAngle
plot(phaseAngleStraight, phaseAngleFunction);
%Px = x + 1i*y;
%plot(real(Px),imag(Px), 'ro');
axis([-2.1 0.1 -0.1 2.1]); % ### Zoom no R.L. para escolha do ponto de cruzamento
%[x1, y1] = ginput(1);
%Px1 = x1 + 1i*y1;
%Px1 = -1.1802+ 1.6103i; % ### Px1 (para zc=-e_reg) obtido na nova interseção
%Px1 = -1.1398 + 1.5555i; % ### Px1 (para zc=-0.5) obtido na nova interseção
Px1 = -0.8691 + 1.1861i; % ### Px1 (para zc=-1.0) obtido na nova interseção
%Px1 = -0.5624 + 0.7675i; % ### Px1 (para zc=-1.5) obtido na nova interseção
plot(real(Px1),imag(Px1), 'ro');

k1=-polyval(GMA_Integrator.den{1},Px1)/(polyval(GMA_Integrator.num{1},Px1));
k1=abs(real(k1))
GMF1 = feedback(k1*GMA_Integrator,1);

figure(2)
hold on;

% ##### OBSERVAÇÃO #####
% ### se a variável "t" já foi criada, não é necessário criar novamente:
%t = 0:0.01:20;
% ##### OBSERVAÇÃO #####

[PV1, t] = step(GMF1, t);
plot(t,PV1,'color','#ff8c00');
grid on;

% ##### OBSERVAÇÃO #####
% ### verificando o sobressinal em MF:
eixo = axis; hold on;
PVmax = max(PV1); idxmax = find(PV1>=PVmax,1); tp = t(idxmax);
plot(tp*[1 1], [0 PVmax], 'k+-');
Mp = PVmax-dcgain(GMF1);
texto = sprintf('   Mp = %5.1f%%\n   t_P  = %5.2fs\n   Zc_{PI} = %5.2f\n   K_{PI} = %5.2f',...
                Mp*100,tp, zc, k1);
text(tp,PVmax,texto)
% ##### OBSERVAÇÃO #####


