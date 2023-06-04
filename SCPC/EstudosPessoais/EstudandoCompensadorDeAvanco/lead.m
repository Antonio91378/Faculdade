clc;
clear;
pkg load control;
pkg load signal;

%%1.a : Projete um controlador proporcional para atender à especificação de sobressinal em que Gc = Kp.
N = 5;
num = 1;
den = conv(conv([1 0], [1 2]), [1 2*N]);
GMA = tf(num, den);

%graph one --------
rlocus(GMA);
legend off;
hold on;
imaginaryAxis = linspace(-20, 20);
realAxis = zeros(size(imaginaryAxis));
plot(imaginaryAxis, realAxis, 'k');
plot(realAxis, imaginaryAxis, 'k');
t = 0:0.01:10;
%calculating damping factor
df = (-log(10/100)) / sqrt((pi^2) + (log(10/100))^2);
phaseAngle = 180 - acosd(df);
%ploting the phaseAngle
phaseAngleStraight = linspace(0,-30);
phaseAngleFunction = -deg2rad(phaseAngle)*phaseAngleStraight;
plot(phaseAngleStraight, phaseAngleFunction);
[Px, Py] = ginput(1);
k=-polyval(GMA.den{1},Px)/(polyval(GMA.num{1},Px));
k=abs(real(k));
GMF = feedback(k*GMA,1);
hold off;


%second one graph ---------
figure
hold on;
[PV, t] = step(GMF, t);
plot(t,PV,'g');
grid on;
realAxis = ones(size(imaginaryAxis));
imaginaryAxis = linspace(0, 10);
plot(imaginaryAxis,realAxis,'--r');
xlabel('Tempo')
ylabel('Saída (PV)')
title('Resposta ao Degrau do Sistema em Malha Fechada com e sem o controlador proporcional.')
hold off;

%%%%%%%%%% 1.B: Cálculo do tempo de acomodação para o critério de 2%
% Calcular o tempo de amortecimento
plot(t,0.98*sp,'g--');
plot(t,1.02*sp,'g--');
% Valor final da resposta ao degrau
y_final = y(end);
lim_inf = 0.98 * y_final;

% Encontrar o índice onde a resposta ultrapassa o limite inferior
indice_acomodacao = find(y > lim_inf, 1);

% Calcular o tempo de acomodação
t_acomodacao = t(indice_acomodacao)

% Plotar a resposta ao degrau e o tempo de acomodação
hold on;
plot([t_acomodacao t_acomodacao], [0 y_final], 'r--', 'LineWidth', 1.5);
text(t_acomodacao, 0.8, ['T_a_c_o_m_p = ' num2str(t_acomodacao)], 'Color', 'red');
figure
rlocus(G)
%%%%%%%%%% 1.C: Projete um compensador em Avanço de Fase para reduzir o tempo de acomodação calculado no item (b) em três vezes e atender à especificação de sobressinal, em que Glead = k(s - Zlead)/(s - Plead) sendo que o zero desse compensador deve estar em -2.
t_acomodacao_desejado = t_acomodacao / 3;
Ta_desejado = t_acomodacao_desejado;
OS = 0.1; % Overshoot máximo (10%)
zeta = abs(log(OS)) / sqrt(pi^2 + log(OS)^2);
wn = 4 / (zeta * Ta_desejado); % a frequência natural não amortecida.

Zlead = 2;
Plead = zeta * wn + sqrt((zeta * wn)^2 - wn^2); % Definimos um polo muito próximo de zero para evitar instabilidades

% Cálculo dos parâmetros do compensador em avanço de fase
num_c = [1, Zlead];
den_c = [1, real(Plead)];
C = tf(num_c, den_c );
% Função de transferência do sistema compensado
T_compensado = feedback(C * K * G, 1);
figure
[ycom, t] = step(T_compensado, t);
% Plotar a resposta ao degrau do sistema compensado
plot(t, ycom);
hold on;
sp = ones(size(t));
plot(t,sp);
grid on
% Configurar os rótulos dos eixos e o título do gráfico
xlabel('Tempo');
ylabel('Resposta ao Degrau');
title('Resposta ao Degrau do Sistema Compensado');
grid on;
% Mostrar o valor do tempo de acomodação atual e desejado
disp(['Tempo de Acomodação Atual: ' num2str(t_acomodacao) ' segundos']);
disp(['Tempo de Acomodação Desejado: ' num2str(t_acomodacao_desejado) ' segundos']);
plot(t,0.98*sp,'g--');
plot(t,1.02*sp,'g--');
% Cálculo do tempo de acomodação do sistema compensado
tolerancia = 0.02; % Tolerância de 2% para considerar o estado de acomodação
y_ss = ycom(end); % Valor de regime permanente da resposta ao degrau
t_acomodacao_compensado = 0; % Inicializa o tempo de acomodação do sistema compensado

% Encontra o primeiro ponto após o tempo de amortecimento que atinge 98% do valor final
for i = 1:length(ycom)
    if abs(ycom(i) - y_ss) <= tolerancia * y_ss
        t_acomodacao_compensado = t(i);
        break;
    end
end

% Plotar o novo tempo de acomodação
line([t_acomodacao_compensado t_acomodacao_compensado], [0 1], 'Color', 'red', 'LineStyle', '--');
text(t_acomodacao_compensado, 0.8, ['T_a_c_o_m_p = ' num2str(t_acomodacao_compensado)], 'Color', 'red');
figure
rlocus(T_compensado);
