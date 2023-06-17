
clc;
clear;
pkg load control;
%pkg load signal;   % Não utiliza nenhuma função deste pacote

%%%%%%%%%%%%%%1.a : Projete um controlador proporcional para atender Ã  especificaÃ§Ã£o de sobressinal em que G = K.

% FunÃ§Ã£o de transferÃªncia do sistema
num = 1;
den = conv(conv([1 0], [1 2]), [1 4]);
G = tf(num, den);

% Sobressinal desejado
sobressinal = 10; % em porcentagem

% ##### CORREÇÃO #####
% % CÃ¡lculo do ganho do controlador proporcional
% ### o ganho K não é calculado desta forma.
%K = 100 / sobressinal;
% ### Para determinar o ganho K, deve-se determinar o
% ### ponto de cruzamento do L.R. com a reta de zeta constante,
% ### correspondente ao sobressinal desejado:
Mp = sobressinal/100;               % valor relativo do sobressinal
zt = -log(Mp)/sqrt(pi^2+log(Mp)^2)  % zeta para sobressinal de 10%
teta = acosd(zt)                    % ângulo da reta de zeta constante
reta = @(x) -tand(teta).*x;     % equação da reta de zeta constante (do Mp desejado)
% ##### CORREÇÃO #####

% ##### CORREÇÃO #####
% ### O primeiro gráfico é do L.R. do sistema não compensado:
figure(2); clf;
rlocus(G); legend off;
% ### traçar a reta de zeta constante (do Mp desejado):
hold on;
eixo = axis;    % Pega os valores dos eixos do gráfico do L.R.
plot(eixo(1:2), reta(eixo(1:2)),'k');
% ### solicita que clique no ponto de cruzamento,
% ### para determinar Px:
disp('Clique no ponto de cruzamento da reta com o L.R.')
%[ptx,pty] = ginput(1);    % solicita que clique em 1 ponto
%plot(ptx,pty,'r+');     % Plota o ponto clicado (para conferência)
%Px = ptx+1i*pty
Px = -0.7152 + 0.9758i
plot(real(Px),imag(Px),'r+');     % Plota o ponto clicado (para conferência)
% ### Determina o valor de K para que Px seja pólo de Gmf:
% ### K = -1/G(Px)
K = -polyval(G.den{1},Px)/polyval(G.num{1},Px)
K = abs(K)  % usa apenas o valor absoluto do K calculado
% ##### CORREÇÃO #####


% FunÃ§Ã£o de transferÃªncia do sistema em malha fechada
T = feedback(K * G, 1);
% ##### OBSERVAÇÃO #####
% Pode-se plotar os pólos de malha fechada devidos ao valor de K calculado:
pmf = eig(T);
plot(real(pmf),imag(pmf),'rx','LineWidth',1.5,'MarkerSize',7)
% ##### OBSERVAÇÃO #####


% ##### CORREÇÃO #####
% ### Chamar a figura antes de plotar:
figure(1); clf;
%figure
% ##### CORREÇÃO #####


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
ylabel('SaÃ­da')
title('Resposta ao Degrau do Sistema em Malha Fechada com e sem o controlador proporcional.')
grid on

%%%%%%%%%% 1.B: CÃ¡lculo do tempo de acomodaÃ§Ã£o para o critÃ©rio de 2%
% Calcular o tempo de amortecimento
plot(t,0.98*sp,'g--');
plot(t,1.02*sp,'g--');
% Valor final da resposta ao degrau
y_final = y(end);
lim_inf = 0.98 * y_final;

% ##### CORREÇÃO #####
% ### Ta = tempo que entra na faixa de 2% e não sai mais,
% ### para isso deve inverter o vetor y para procurar o
% ### último ponto que entra na faixa de 2%, que é
% ### igual ao primeiro que entra na faixa de y invertido:
yflip = flip(y);
% ### No comando abaixo, o símbolo "|" significa "ou":
idxTa = find((yflip>=1.02*y_final)|(yflip<=0.98*y_final),1)
indice_acomodacao = length(y)-idxTa  % inverte o índice
% % Encontrar o Ã­ndice onde a resposta ultrapassa o limite inferior
%indice_acomodacao = find(y > lim_inf, 1);
% ##### CORREÇÃO #####

% Calcular o tempo de acomodaÃ§Ã£o
t_acomodacao = t(indice_acomodacao)

% Plotar a resposta ao degrau e o tempo de acomodaÃ§Ã£o
hold on;
plot([t_acomodacao t_acomodacao], [0 y_final], 'r--', 'LineWidth', 1.5);
text(t_acomodacao, 0.8, ['Ta_{comp} = ' num2str(t_acomodacao)], 'Color', 'red');

% ##### OBSERVAÇÃO #####
% ### Foi a primeira figura plotada (não precisa fazer novamente)
% ##### CORREÇÃO #####
% ### Cada vez que chama "figure" é criada uma nova figura,
% ### então é melhor chamar uma figura específica:
%figure(2);
%figure
%rlocus(G); legend off;
% ##### CORREÇÃO #####

%%%%%%%%%% 1.C: Projete um compensador em AvanÃ§o de Fase para reduzir o tempo de acomodaÃ§Ã£o calculado no item (b) em trÃªs vezes e atender Ã  especificaÃ§Ã£o de sobressinal, em que Glead = k(s - Zlead)/(s - Plead) sendo que o zero desse compensador deve estar em -2.
t_acomodacao_desejado = t_acomodacao / 3;
Ta_desejado = t_acomodacao_desejado;
OS = 0.1; % Overshoot mÃ¡ximo (10%)
zeta = abs(log(OS)) / sqrt(pi^2 + log(OS)^2);
wn = 4 / (zeta * Ta_desejado); % a frequÃªncia natural nÃ£o amortecida.

% ##### CORREÇÃO #####
% ### O Zlead é negativo:
%Zlead = 2; % Com o valor de -2 não se consegue o novo PX
Zlead = -1.5;   % Testar novos valores de Zlead
% ### o pólo do LEAD é determinado pela
% ### contribuição de ângulo para obter 180 no novo PX,
% ### o qual é determinado pelo Ta desejado:
PX = 3*Px
figure(2);
plot(real(PX),imag(PX),'r+');     % Plota o ponto PX (para conferência)
pause(2); % espera 2 segundos, para visualização do gráfico)
figure(1);
% ### Contribuição do zero do LEAD (em graus):
ang_Zlead = arg(PX-Zlead)*180/pi
% ### Contribuição dos pólos de G (em graus):
pG = eig(G);
ang_polos = arg(PX-pG)*180/pi
% ### Contribuição do pólo do LEAD (em graus):
% ### Soma(ang_zeros) - ang_Plead - Soma(ang_polos) = +- 180
ang_Plead =  ang_Zlead - sum(ang_polos) + 180
%ang_Plead =  ang_Zlead - sum(ang_polos) - 180
%ang_Plead = -ang_Zlead + sum(ang_polos) - 180
% ### tand(ang_Plead) = imag(PX)/M
% ### M = imag(PX)/tand(ang_Plead)
% ### Plead = real(PX)-M
Plead = real(PX) - imag(PX)/tand(ang_Plead)
%Plead = zeta * wn + sqrt((zeta * wn)^2 - wn^2); % Definimos um polo muito prÃ³ximo de zero para evitar instabilidades
% ##### CORREÇÃO #####

% CÃ¡lculo dos parÃ¢metros do compensador em avanÃ§o de fase
num_c = [1, -Zlead];
den_c = [1, -Plead];
%den_c = [1, real(Plead)];
C = tf(num_c, den_c );
% ##### CORREÇÃO #####
% ### Cálculo do novo ganho K do compensador LEAD:
% ### K = -1/Gma(PX)
Gma = C * G;
K = -polyval(Gma.den{1},PX)/polyval(Gma.num{1},PX)
K = abs(K)  % usa apenas o valor absoluto do K calculado
% ##### CORREÇÃO #####

% FunÃ§Ã£o de transferÃªncia do sistema compensado
T_compensado = feedback(K*Gma, 1);
%T_compensado = feedback(C * K * G, 1);

% ##### CORREÇÃO #####
% ### Cada vez que chama "figure" é criada uma nova figura,
% ### então é melhor chamar uma figura específica:
figure(3); clf;
%figure
% ##### CORREÇÃO #####

[ycom, t] = step(T_compensado, t);
% Plotar a resposta ao degrau do sistema compensado
plot(t, ycom);
hold on;
sp = ones(size(t));
plot(t,sp);
grid on
% Configurar os rÃ³tulos dos eixos e o tÃ­tulo do grÃ¡fico
xlabel('Tempo');
ylabel('Resposta ao Degrau');
title('Resposta ao Degrau do Sistema Compensado');
grid on;
% Mostrar o valor do tempo de acomodaÃ§Ã£o atual e desejado
disp(['Tempo de AcomodaÃ§Ã£o Atual: ' num2str(t_acomodacao) ' segundos']);
disp(['Tempo de AcomodaÃ§Ã£o Desejado: ' num2str(t_acomodacao_desejado) ' segundos']);
plot(t,0.98*sp,'g--');
plot(t,1.02*sp,'g--');
% CÃ¡lculo do tempo de acomodaÃ§Ã£o do sistema compensado
tolerancia = 0.02; % TolerÃ¢ncia de 2% para considerar o estado de acomodaÃ§Ã£o

% ##### CORREÇÃO #####
% ### y_ss = valor final, após todo o transitório
% ###        (melhor usar dcgain()
y_ss = ycom(end)  % Valor de regime permanente da resposta ao degrau
y_ss = dcgain(T_compensado)
% ##### CORREÇÃO #####

t_acomodacao_compensado = 0; % Inicializa o tempo de acomodaÃ§Ã£o do sistema compensado

% ##### CORREÇÃO #####
% ### Ta = tempo que entra na faixa de 2% e não sai mais,
% ### para isso deve inverter o vetor y para procurar o
% ### último ponto que entra na faixa de 2%, que é
% ### igual ao primeiro que entra na faixa de y invertido:
yflip = flip(ycom);
% ### No comando abaixo, o símbolo "|" significa "ou":
idxTa = find((yflip>=1.02*y_ss)|(yflip<=0.98*y_ss),1)
idxTa = length(ycom)-idxTa  % inverte o índice
t_acomodacao_compensado = t(idxTa)
% % Encontra o primeiro ponto apÃ³s o tempo de amortecimento que atinge 98% do valor final
%for i = 1:length(ycom)
%    if abs(ycom(i) - y_ss) <= tolerancia * y_ss
%        t_acomodacao_compensado = t(i);
%        break;
%    end
%end

% Plotar o novo tempo de acomodaÃ§Ã£o
line([t_acomodacao_compensado t_acomodacao_compensado], [0 1], 'Color', 'red', 'LineStyle', '--');
text(t_acomodacao_compensado, 0.8, ['T_a_c_o_m_p = ' num2str(t_acomodacao_compensado)], 'Color', 'red');

% ##### CORREÇÃO #####
% ### Cada vez que chama "figure" é criada uma nova figura,
% ### então é melhor chamar uma figura específica:
figure(4); clf;
%figure
% ##### CORREÇÃO #####
% ### O Lugar das Raízes SÓ USA G de MALHA ABERTA,
% ### Nunca de Gmf:
GMAcomp = C * K * G;
rlocus(GMAcomp); legend off;
%rlocus(T_compensado); legend off;
% ##### CORREÇÃO #####

% ##### OBSERVAÇÃO #####
% Pode-se plotar os pólos de malha fechada devidos ao valor de K calculado:
hold on;
plot(real(PX),imag(PX),'r+');     % Plota o ponto PX (para conferência)
pmf_comp = eig(T_compensado);
plot(real(pmf_comp),imag(pmf_comp),'rx','LineWidth',1.5,'MarkerSize',7)
% Reta do Zlead ao PX:
plot(real([Zlead PX]),imag([Zlead PX]),'k--')
% Reta do Plead ao PX:
plot(real([Plead PX]),imag([Plead PX]),'k--')
% ##### OBSERVAÇÃO #####
pause(1);
axis([-5 1 -1 5])

