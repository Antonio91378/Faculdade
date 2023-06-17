
clc;
clear;
pkg load control;
%pkg load signal;   % N�o utiliza nenhuma fun��o deste pacote

%%%%%%%%%%%%%%1.a : Projete um controlador proporcional para atender à especificação de sobressinal em que G = K.

% Função de transferência do sistema
num = 1;
den = conv(conv([1 0], [1 2]), [1 4]);
G = tf(num, den);

% Sobressinal desejado
sobressinal = 10; % em porcentagem

% ##### CORRE��O #####
% % Cálculo do ganho do controlador proporcional
% ### o ganho K n�o � calculado desta forma.
%K = 100 / sobressinal;
% ### Para determinar o ganho K, deve-se determinar o
% ### ponto de cruzamento do L.R. com a reta de zeta constante,
% ### correspondente ao sobressinal desejado:
Mp = sobressinal/100;               % valor relativo do sobressinal
zt = -log(Mp)/sqrt(pi^2+log(Mp)^2)  % zeta para sobressinal de 10%
teta = acosd(zt)                    % �ngulo da reta de zeta constante
reta = @(x) -tand(teta).*x;     % equa��o da reta de zeta constante (do Mp desejado)
% ##### CORRE��O #####

% ##### CORRE��O #####
% ### O primeiro gr�fico � do L.R. do sistema n�o compensado:
figure(2); clf;
rlocus(G); legend off;
% ### tra�ar a reta de zeta constante (do Mp desejado):
hold on;
eixo = axis;    % Pega os valores dos eixos do gr�fico do L.R.
plot(eixo(1:2), reta(eixo(1:2)),'k');
% ### solicita que clique no ponto de cruzamento,
% ### para determinar Px:
disp('Clique no ponto de cruzamento da reta com o L.R.')
%[ptx,pty] = ginput(1);    % solicita que clique em 1 ponto
%plot(ptx,pty,'r+');     % Plota o ponto clicado (para confer�ncia)
%Px = ptx+1i*pty
Px = -0.7152 + 0.9758i
plot(real(Px),imag(Px),'r+');     % Plota o ponto clicado (para confer�ncia)
% ### Determina o valor de K para que Px seja p�lo de Gmf:
% ### K = -1/G(Px)
K = -polyval(G.den{1},Px)/polyval(G.num{1},Px)
K = abs(K)  % usa apenas o valor absoluto do K calculado
% ##### CORRE��O #####


% Função de transferência do sistema em malha fechada
T = feedback(K * G, 1);
% ##### OBSERVA��O #####
% Pode-se plotar os p�los de malha fechada devidos ao valor de K calculado:
pmf = eig(T);
plot(real(pmf),imag(pmf),'rx','LineWidth',1.5,'MarkerSize',7)
% ##### OBSERVA��O #####


% ##### CORRE��O #####
% ### Chamar a figura antes de plotar:
figure(1); clf;
%figure
% ##### CORRE��O #####


% Plotar a resposta ao degrau do sistema em malha fechada
t = 0:0.01:10;
[y, t] = step(T, t);
[yp,t]= step(G,t);
sp = ones(size(t));
hold on;
plot(t,sp);
plot(t,yp);
plot(t, y);
xlabel('Tempo')
ylabel('Saída')
title('Resposta ao Degrau do Sistema em Malha Fechada com e sem o controlador proporcional.')
grid on

%%%%%%%%%% 1.B: Cálculo do tempo de acomodação para o critério de 2%
% Calcular o tempo de amortecimento
plot(t,0.98*sp,'g--');
plot(t,1.02*sp,'g--');
% Valor final da resposta ao degrau
y_final = y(end);
lim_inf = 0.98 * y_final;

% ##### CORRE��O #####
% ### Ta = tempo que entra na faixa de 2% e n�o sai mais,
% ### para isso deve inverter o vetor y para procurar o
% ### �ltimo ponto que entra na faixa de 2%, que �
% ### igual ao primeiro que entra na faixa de y invertido:
yflip = flip(y);
% ### No comando abaixo, o s�mbolo "|" significa "ou":
idxTa = find((yflip>=1.02*y_final)|(yflip<=0.98*y_final),1)
indice_acomodacao = length(y)-idxTa  % inverte o �ndice
% % Encontrar o índice onde a resposta ultrapassa o limite inferior
%indice_acomodacao = find(y > lim_inf, 1);
% ##### CORRE��O #####

% Calcular o tempo de acomodação
t_acomodacao = t(indice_acomodacao)

% Plotar a resposta ao degrau e o tempo de acomodação
hold on;
plot([t_acomodacao t_acomodacao], [0 y_final], 'r--', 'LineWidth', 1.5);
text(t_acomodacao, 0.8, ['Ta_{comp} = ' num2str(t_acomodacao)], 'Color', 'red');

% ##### OBSERVA��O #####
% ### Foi a primeira figura plotada (n�o precisa fazer novamente)
% ##### CORRE��O #####
% ### Cada vez que chama "figure" � criada uma nova figura,
% ### ent�o � melhor chamar uma figura espec�fica:
%figure(2);
%figure
%rlocus(G); legend off;
% ##### CORRE��O #####

%%%%%%%%%% 1.C: Projete um compensador em Avanço de Fase para reduzir o tempo de acomodação calculado no item (b) em três vezes e atender à especificação de sobressinal, em que Glead = k(s - Zlead)/(s - Plead) sendo que o zero desse compensador deve estar em -2.
t_acomodacao_desejado = t_acomodacao / 3;
Ta_desejado = t_acomodacao_desejado;
OS = 0.1; % Overshoot máximo (10%)
zeta = abs(log(OS)) / sqrt(pi^2 + log(OS)^2);
wn = 4 / (zeta * Ta_desejado); % a frequência natural não amortecida.

% ##### CORRE��O #####
% ### O Zlead � negativo:
%Zlead = 2; % Com o valor de -2 n�o se consegue o novo PX
Zlead = -1.5;   % Testar novos valores de Zlead
% ### o p�lo do LEAD � determinado pela
% ### contribui��o de �ngulo para obter 180 no novo PX,
% ### o qual � determinado pelo Ta desejado:
PX = 3*Px
figure(2);
plot(real(PX),imag(PX),'r+');     % Plota o ponto PX (para confer�ncia)
pause(2); % espera 2 segundos, para visualiza��o do gr�fico)
figure(1);
% ### Contribui��o do zero do LEAD (em graus):
ang_Zlead = arg(PX-Zlead)*180/pi
% ### Contribui��o dos p�los de G (em graus):
pG = eig(G);
ang_polos = arg(PX-pG)*180/pi
% ### Contribui��o do p�lo do LEAD (em graus):
% ### Soma(ang_zeros) - ang_Plead - Soma(ang_polos) = +- 180
ang_Plead =  ang_Zlead - sum(ang_polos) + 180
%ang_Plead =  ang_Zlead - sum(ang_polos) - 180
%ang_Plead = -ang_Zlead + sum(ang_polos) - 180
% ### tand(ang_Plead) = imag(PX)/M
% ### M = imag(PX)/tand(ang_Plead)
% ### Plead = real(PX)-M
Plead = real(PX) - imag(PX)/tand(ang_Plead)
%Plead = zeta * wn + sqrt((zeta * wn)^2 - wn^2); % Definimos um polo muito próximo de zero para evitar instabilidades
% ##### CORRE��O #####

% Cálculo dos parâmetros do compensador em avanço de fase
num_c = [1, -Zlead];
den_c = [1, -Plead];
%den_c = [1, real(Plead)];
C = tf(num_c, den_c );
% ##### CORRE��O #####
% ### C�lculo do novo ganho K do compensador LEAD:
% ### K = -1/Gma(PX)
Gma = C * G;
K = -polyval(Gma.den{1},PX)/polyval(Gma.num{1},PX)
K = abs(K)  % usa apenas o valor absoluto do K calculado
% ##### CORRE��O #####

% Função de transferência do sistema compensado
T_compensado = feedback(K*Gma, 1);
%T_compensado = feedback(C * K * G, 1);

% ##### CORRE��O #####
% ### Cada vez que chama "figure" � criada uma nova figura,
% ### ent�o � melhor chamar uma figura espec�fica:
figure(3); clf;
%figure
% ##### CORRE��O #####

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

% ##### CORRE��O #####
% ### y_ss = valor final, ap�s todo o transit�rio
% ###        (melhor usar dcgain()
y_ss = ycom(end)  % Valor de regime permanente da resposta ao degrau
y_ss = dcgain(T_compensado)
% ##### CORRE��O #####

t_acomodacao_compensado = 0; % Inicializa o tempo de acomodação do sistema compensado

% ##### CORRE��O #####
% ### Ta = tempo que entra na faixa de 2% e n�o sai mais,
% ### para isso deve inverter o vetor y para procurar o
% ### �ltimo ponto que entra na faixa de 2%, que �
% ### igual ao primeiro que entra na faixa de y invertido:
yflip = flip(ycom);
% ### No comando abaixo, o s�mbolo "|" significa "ou":
idxTa = find((yflip>=1.02*y_ss)|(yflip<=0.98*y_ss),1)
idxTa = length(ycom)-idxTa  % inverte o �ndice
t_acomodacao_compensado = t(idxTa)
% % Encontra o primeiro ponto após o tempo de amortecimento que atinge 98% do valor final
%for i = 1:length(ycom)
%    if abs(ycom(i) - y_ss) <= tolerancia * y_ss
%        t_acomodacao_compensado = t(i);
%        break;
%    end
%end

% Plotar o novo tempo de acomodação
line([t_acomodacao_compensado t_acomodacao_compensado], [0 1], 'Color', 'red', 'LineStyle', '--');
text(t_acomodacao_compensado, 0.8, ['T_a_c_o_m_p = ' num2str(t_acomodacao_compensado)], 'Color', 'red');

% ##### CORRE��O #####
% ### Cada vez que chama "figure" � criada uma nova figura,
% ### ent�o � melhor chamar uma figura espec�fica:
figure(4); clf;
%figure
% ##### CORRE��O #####
% ### O Lugar das Ra�zes S� USA G de MALHA ABERTA,
% ### Nunca de Gmf:
GMAcomp = C * K * G;
rlocus(GMAcomp); legend off;
%rlocus(T_compensado); legend off;
% ##### CORRE��O #####

% ##### OBSERVA��O #####
% Pode-se plotar os p�los de malha fechada devidos ao valor de K calculado:
hold on;
plot(real(PX),imag(PX),'r+');     % Plota o ponto PX (para confer�ncia)
pmf_comp = eig(T_compensado);
plot(real(pmf_comp),imag(pmf_comp),'rx','LineWidth',1.5,'MarkerSize',7)
% Reta do Zlead ao PX:
plot(real([Zlead PX]),imag([Zlead PX]),'k--')
% Reta do Plead ao PX:
plot(real([Plead PX]),imag([Plead PX]),'k--')
% ##### OBSERVA��O #####
pause(1);
axis([-5 1 -1 5])

