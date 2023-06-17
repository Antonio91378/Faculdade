clc;
clear;
pkg load control;

%Ex. 11.3 (Nise, 3.ed., p.501)

t = 0:0.01:2;
tp = 0.1;
mp = 0.2;
kvRequired = 40;
zeta = 0.456;

%Definindo a planta
pole1 = 0;
pole2 = -36;
pole3 = -100;
num = 100;
den = conv(conv([1 -pole1], [1 -pole2]), [1 -pole3]);
GP = tf(num, den);
s = tf('s');

wn = (pi/(tp*sqrt(1-zeta^2)))
bw = wn*sqrt((1-2*zeta^2)+sqrt((4*zeta^4) - (4*zeta^2) + 2)) %banda passante
kvP = dcgain(minreal(s*GP))
kc = kvRequired/kvP

figure 1; clf;
kc_Gp = GP*kc;
bode(GP,kc_Gp)

figure 2; clf;
GMF = feedback(kc_Gp,1);
step(GMF,t);
[mgc, mfc, wgc, wfc] = margin(kc_Gp);
mf = 48.1 %fórmula grande no slide

