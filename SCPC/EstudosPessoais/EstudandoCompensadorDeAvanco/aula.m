clc
clear
pkg load control

subplot(2, 1, 1);
S = tf('s');
Gp = 5/(S*(S+1)*(S+5));
rlocus(Gp);
legend off;
hold on;
x = linspace(0, 2*pi, 100);
xlimits = xlim();

% add dotted lines at y = -0.5 and y = 0.5 with an offset of 0.1
offset = 0.2;
line(xlimits, [-0.5-offset, -0.5-offset], 'LineStyle', '--', 'Color', 'g');
line(xlimits, [0.5+offset, 0.5+offset], 'LineStyle', '--', 'Color', 'g');
line([0, 0], ylim(), 'LineStyle', '-', 'Color', 'k');
