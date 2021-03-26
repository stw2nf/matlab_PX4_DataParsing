clear all;
clc;

T = readtable('C:\Users\stw2nf\Box\Descent Testing\Experiment Design\rescueFlipAnalysis.csv');

run = 1:length(T.LogName);

energyRescue = T.EnergyConsumption_Wh_.*60; %Energy of rescue flip
energyRescueMean = mean(energyRescue);
energyRescueStd = std(energyRescue);
energyRescueCI = cInterval(energyRescue);

figure(1)
scatter(run, energyRescue, 'filled');
xlabel('Flight Number');
ylabel('Energy Consumed (Wmin)');
title('Rescue Flip Analysis');
grid on
hold on