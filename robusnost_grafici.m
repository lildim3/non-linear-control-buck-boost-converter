%% 
clc
close all
clear

set(groot, ...
    'defaultAxesFontSize', 12, ...
    'defaultTextFontSize', 12, ...
    'defaultAxesFontName', 'Times New Roman', ...
    'defaultTextFontName', 'Times New Roman', ...
    'defaultLineLineWidth', 1.3, ...
    'defaultAxesLineWidth', 0.8, ...
    'defaultTextInterpreter', 'latex', ...
    'defaultAxesTickLabelInterpreter', 'latex', ...
    'defaultLegendInterpreter', 'latex');
outdir = "izvoz_robusnost";
if ~exist(outdir,"dir")
    mkdir(outdir);
end
%%

L=15.91*10^-3*0.8;   %Induktivnost [H]
C=470*10^-6;     %Kapacitivnost [F]
R=52;            %Otpornost potrosaca [Ohm]
E=12;            %Napon [V]

Vc=-22.5; %Nominalna vrednost izlazne varijable
Ye=Vc;

x10=0;
x20=0;

x1e=1.2441; % vC
x2e=Vc; % iL
ue=0.65217; % vCnom/(E-Vcnom)

sig2 = (0.00*x2e)^2;
poremecaj = 0.8; %ako je = 1 onda ga nema

%% open loop
simModel = 'openloop.slx';
time = 1.5;
simOut = sim(simModel, time);

tOpenLoop = simOut.t_out;
ilOpenLoop= simOut.x1_out;
ucOpenLoop = simOut.x2_out;

%% Linearna regulacija - Kontroler na bazi inverzije dinamike

syms x1 x2 u
f1 = (1-u)*x2/L+E*u/L;
f2 = (u-1)*x1/C-x2/(R*C);

A = [diff(f1,x1) diff(f1,x2); diff(f2,x1) diff(f2,x2)];
B = [diff(f1,u); diff(f2,u)];

x1 = x1e; x2 = x2e; u = ue; %Vrednosti u ekvilibrijumu
A = eval(A); B = eval(B); c = [0 1];
s = tf('s');
sys = ss(A,B,c,0);
G = tf(sys);
s = tf('s');
[num, den] =  tfdata(G, 'v');
num(3) = -num(3); %menjanje znaka nule u DPR
Gapprox = tf(num, den);
w1_star = 30;   %manje od num(3)/num(2)/2
wpk = 2*w1_star; %visokofrekventna dinamika radi stroge kauzalnosti
K1 = -w1_star/s * inv(Gapprox) / (s / wpk + 1);
[num, den] = tfdata(K1, 'v');

simModel = 'closedloop.slx';
time = 1.5;
simOut = sim(simModel, time);

tLin = simOut.t_out;
uLin = simOut.u_out;
ilLin = simOut.x1_out;
ucLin = simOut.x2_out;

%% Feedback linearizacija

gama = C*x2e^2 - 2*E*C*x2e + L*x1e^2;
w0 = 40;
k1 = 9*w0;
k0 = 27*w0^2;
ki = 27*w0^3;

simModel = 'eFL_control.slx';
time = 1.5;
simOut = sim(simModel, time);

tFeedback = simOut.t_out;
uFeedback = simOut.u_out;
ilFeedback = simOut.x1_out;
ucFeedback = simOut.x2_out;
%% BL - SMC

w0 = 30;
sel  = 3; 
k1 = 1;
ki = 1;
fi = 1;
wp = 150;

switch sel
    case 1 % SMC
        beta = 3e3;
        k0 = 200;
    case 2 % SMC+I
        beta = 3e3;
        k0 = 2*200;
        ki = 200^2;
    case 3 % BLSMC+I
        beta = 2e3;
        k0 = 2*200;
        ki = 200^2; 
        fi =100;
end

simModel = 'SMC_suzbija_poremecaj.slx';
time = 1.5;
simOut = sim(simModel, time);

tSMC = simOut.t_out;
uSMC = simOut.u_out;
ilSMC = simOut.x1_out;
ucSMC = simOut.x2_out;

%% uc
figure;
subplot(2,2,[3 4])
plot(tLin, ucLin); hold on;
plot(tFeedback, ucFeedback);
plot(tSMC, ucSMC);
xlabel('t[s]');
xlim([0 1.5]);
ylabel('$u_{C}$');
legend('LIN','FL','BLSMC+I','Location','northeast');
grid on;
subplot(2,2,2)
plot(tLin, ilLin); hold on;
plot(tFeedback, ilFeedback);
plot(tSMC, ilSMC);
xlabel('t[s]');
ylabel('$i_{L}$');
legend('LIN','FL','BLSMC+I','Location','northeast');
xlim([0 1.5]);
ylim([0.5 2.5]);
grid on;
subplot(2,2,1)
plot(tLin, uLin); hold on;
plot(tFeedback, uFeedback);
plot(tSMC, uSMC);
xlabel('t[s]');
ylabel('u');
legend('LIN','FL','BLSMC+I','Location','northeast');
ylim([0.58 0.7]);
grid on;


exportgraphics(gcf,fullfile(outdir,'robusnost_kontrola_80.pdf'), 'ContentType','vector');
% open loop deo
figure;
plot(tOpenLoop, ucOpenLoop); hold on;
xlabel('t[s]');
ylabel('$u_{C}$');
xlim([0 1.5]);
ylim([-26 -15]);
grid on;
exportgraphics(gcf, fullfile(outdir,'uc_openloop_80.pdf'), 'ContentType','vector');

figure;
plot(tOpenLoop, ilOpenLoop); hold on;
xlabel('t[s]');
ylabel('$i_{L}$');
grid on;
exportgraphics(gcf,  fullfile(outdir,'il_openloop_80.pdf'), 'ContentType','vector');


