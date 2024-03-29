
%Antônio Víctor Gonçalves Dias -- Controlador PID


clc;
clear;
pkg load control;

N = 42;
t = 0:0.01:2;
mp = 0.1;
polo1 = -N;
polo2 = -N/5;
polo3 = -N/10;
num = N^3;
den = conv(conv([1 -polo1], [1 -polo2]), [1 -polo3]);
GMA = tf(num, den);

figure 1;  clf;%=======================
rlocus(GMA);
legend off;
hold on;
imaginaryAxis = linspace(-20, 20);
realAxis = zeros(size(imaginaryAxis));
plot(imaginaryAxis, realAxis, 'k');
plot(realAxis, imaginaryAxis, 'k');

%calculando o fator de amortecimento
df = (-log(mp)) / sqrt((pi^2) + (log(mp))^2);
phaseAngle = 180 - acosd(df);

%plotando o ângulo de fase
phaseAngleStraight = linspace(0,-30);
phaseAngleFunction = tand(phaseAngle)*phaseAngleStraight;
plot(phaseAngleStraight, phaseAngleFunction);

%[x, y] = ginput(1);
%Px = x + 1i*y;
Px = -5.5056 + 7.3846i;
plot(real(Px),imag(Px), 'ro');

%1)a)================================================================
%encontrando kp
k=-polyval(GMA.den{1},Px)/(polyval(GMA.num{1},Px));
k=abs(real(k));
GC_kp = feedback(k*GMA,1);

%Plotando o sinal compensado apenas com o kp
figure 2; clf;%================================
grid on;
hold on;
[PV, t] = step(GC_kp, t);
plot(t,PV,'color','#006400');

%1)b)================================================================
%Plotando o tempo de acomodação pro critério de 2%
hold on;
PV_final = PV(end);
vetorFixo = repmat(PV_final, 1, length(t));
plot(t,0.98*vetorFixo,'k--');
plot(t,1.02*vetorFixo,'k--');

yflip = flip(PV);
idxTa = find((yflip>=1.02*PV_final)|(yflip<=0.98*PV_final),1);
indice_acomodacao = length(PV)-idxTa;  % inverte o índice
t_acomodacao = t(indice_acomodacao);
text((t_acomodacao*0.9 + t_acomodacao*1.1) / 2, PV_final*1.1, sprintf('TA: %s s',num2str(t_acomodacao)), 'HorizontalAlignment', 'center');
line([t_acomodacao, t_acomodacao], [min(PV), max(PV)], 'Color', 'red', 'LineStyle', '--');

%2===================================================================
%Setando o novo Px para aumentar a velocidade da resposta transitória
figure 1
hold on;
Px2 = Px*2;
plot(real(Px2),imag(Px2), 'ro');


%Encontrando o controlador PID
polos_GMA = eig(GMA);
ang_polos_GMA = arg(Px2-polos_GMA)*180/pi;
somaPolos = sum(ang_polos_GMA);
ang_Z1 = somaPolos - 180;
coordx = real(Px2);coordx
coordy = imag(Px2);coordy = -coordy
Z1 = (coordx + coordy)/tan(ang_Z1);
Z2 = polo1*0.8;

GPID_GMA = tf(conv([1 -Z1],[1 -Z2]),den);

figure 3; clf;
hold on;
rlocus(GPID_GMA);
plot(real(Px2),imag(Px2), 'ro');

%plotando o ângulo de fase
phaseAngleStraight = linspace(0,-30);
phaseAngleFunction = tand(phaseAngle)*phaseAngleStraight;
plot(phaseAngleStraight, phaseAngleFunction);
legend off;

%achando o novo K =
k2=-polyval(GPID_GMA.den{1},Px2)/(polyval(GPID_GMA.num{1},Px2));
k2=abs(real(k2));

GC_PID = feedback(k2*GPID_GMA,1);

%Plotando o sinal compensado com o PID
figure 2;%================================
grid on;
hold on;
[PV3, t] = step(GC_PID, t);
plot(t,PV3,'color','#006400');

%Plotando o tempo de acomodação pro critério de 2 na saída do PID%
hold on;
PV_final_PID = PV3(end);
vetorFixo2 = repmat(PV_final_PID, 1, length(t));
plot(t,0.98*vetorFixo2,'k--');
plot(t,1.02*vetorFixo2,'k--');

yflip = flip(PV3);
idxTa = find((yflip>=1.02*PV_final_PID)|(yflip<=0.98*PV_final_PID),1);
indice_acomodacao2 = length(PV3)-idxTa;  % inverte o índice
t_acomodacao2 = t(indice_acomodacao2);
text((t_acomodacao2*0.9 + t_acomodacao2*1.1) / 2, PV_final_PID*1.1, sprintf('TA: %s s',num2str(t_acomodacao2)), 'HorizontalAlignment', 'center');
line([t_acomodacao2, t_acomodacao2], [min(PV3), max(PV3)], 'Color', 'red', 'LineStyle', '--');

%4)==================================================================================================
%Pode-se concluir que, utilizando o método de análise do lugar das raíses
%é possível definir um compensador PID de forma satisfatória, seja lá quais
%forem as especificações de overshoot e acomodação.
%Em virtude disso, leva-se a acreditar que o PID desempenha um papel fundamental
%no controle de sistemas dinâmicos, oferecendo uma abordagem versátil e eficaz. Seu uso
% adequado e ajuste cuidadoso podem resultar em sistemas estáveis e com
% desempenho satisfatório em uma ampla variedade de aplicações.
