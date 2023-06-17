clc;
clear;
pkg load control;
% O código desenvolvido será publicado no github com o intuito de poder ser consultado
% e melhorado por outras pessoas, seguindo o pensamento opensource. Com o objetivo
% de aumentar o alcance o script será desenvolvido em inglês, bem como exercícios anteriores.
t = 0:0.01:20;
mp = 0.2;
pole1 = 0;
pole2 = -6;
pole3 = -10;
GMA = zpk([],[pole1 pole2 pole3],1);

% ploting the exit without the compensator
figure 2
[pvGma, t] = step(GMA, t);
plot(t,pvGma,'color','#00009C');

figure 1;  clf;%=======================
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

%[x, y] = ginput(1);
%Px = x + 1i*y;
Px = -1.7993 + 3.5027i %Value found using the ginput()
plot(real(Px),imag(Px), 'ro');

%findind Kp and plotting the sign of exit
k=-polyval(GMA.den{1},Px)/(polyval(GMA.num{1},Px));
k=abs(real(k))
GMF = feedback(k*GMA,1);

figure 2;%================================
hold on;
[PV, t] = step(GMF, t);
plot(t,PV,'color','#006400');
grid on;

%Setting the new kp
figure 1
hold on;
Px2 = Px*2;
plot(real(Px2),imag(Px2), 'ro');

%findind the Glead
%I will choose the zero with the same value of a existent pole
%this way i can reach the next steps more easily
zero_lead = pole2;
angle_zero_lead = arg(Px2-zero_lead)*180/pi;
poles_GMA = eig(GMA);
angle_poles = arg(Px2-poles_GMA)*180/pi;
angle_pLead = angle_zero_lead - sum(angle_poles) + 180;
poloLead = real(Px2) - imag(Px2)/tand(angle_pLead);

GLead = zpk([pole2],[poloLead],1);
GLead = minreal(GLead);

GLead_GMA_num = conv([1 -pole2],[0 1]);
GLead_GMA_den = conv(conv(conv([1 -pole1],[1 -pole2]),[1 -pole3]),[1 -poloLead]);
GLead_GMA = tf(GLead_GMA_num, GLead_GMA_den);
gLeadGMA = minreal(GLead_GMA);

%finding the rlocus of the system with the glead
figure 3; clf; hold on;
rlocus(gLeadGMA);
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

%[x1, y1] = ginput(1);
%Px_lead = x1 + 1i*y1;
Px_lead = -3.6293 + 6.9844i %Value found using the ginput()
plot(real(Px_lead),imag(Px_lead), 'ro');

%findind Kp of the system with the lead compensator and plotting the sign of exit
kLead=-polyval(gLeadGMA.den{1},Px_lead)/(polyval(gLeadGMA.num{1},Px_lead));
kLead=abs(real(kLead))
GMF_lead = feedback(kLead*gLeadGMA,1);

figure 2;%==============================
t = 0:0.01:20;
[PV_lead, t] = step(GMF_lead, t);
hold on;
plot(t,PV_lead,'color','#eead2d');
grid on;

%glag = se o polo for 1 o zero tem q ser 10


