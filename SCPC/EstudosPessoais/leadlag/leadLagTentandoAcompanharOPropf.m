clc;
clear;
pkg load control;

mp = 0.2;
ta = 6;
GMA = zpk([],[0 -6 -4],1);
v = [-10 0]
p = eig(GMA);
apolos = arg(px-v)*180/pi;
ang_av = 180 - sum(apolos); % angulo do polo de avanço
polo_av = real(px) - imag(px) / tand(ang_av); %imag do k mais a tan do ang etc...
zero_av = -6;
% usar o minreal pra cancelar fatorar
Gav(s - zero_av)/(s - polo_av);
GMA1 = Gav*GMA;
hcrv = get(gca,'children');set(hcrv,'color',[0.5 0.5 0.5]) % mudar a cor do lugar das raizes antigo
k = -polyval(GMA.den{1},px)/polyval(GMA.num{1},px)
k = real(k);
GMF_lead = feedback(k*GMA,1); polos_GMA_lead = eig(GMF_lead);







%para calcular o lead eu preciso ter o ganho e um s-zero no num
%e num s - polo no den. éinteressante colocar o zero para cancelar um dos polos
% dominantes para fazer com que o sistema avance.
% o outro polo a ser colocado será a esquerda do zero colocado
% esse polo precisa ser calculado para que o lugar das raízes
% passe no lugar desejado.
% para fazer isso pode-se usar o critério dos ângulos para somar os 180º
%

