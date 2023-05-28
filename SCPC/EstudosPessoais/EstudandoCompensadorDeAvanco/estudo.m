clc;
clear;
pkg load control;
%% Projeto de um controlador na configuração avanço de fase
%% Vamos fazer um exercício relacionado ao projeto de um
%% controlador de avanço de fase para melhorar a estabilidade
%% e a resposta transitória de um sistema com uma função de
%% transferência específica.

K = 1;
s = tf('s');
Gp = K/(s*(s+2)*(s+4));
rlocus(Gp);
legend off;

%% Para esse projeto sera desejado um tempo de pico de 2s e um overshoot de
%% 10%

Tp = 2;
Os = 0.1;


