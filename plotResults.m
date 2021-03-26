close all
clc

i = 1;

markers = ['+','o','*','x','v','d'];

config = Results.Configuration;

controlD = Results.controlD;
maxAcc = Results.maxAcc;
maxVel = Results.maxVel;
maxLatAcc = Results.maxLatAcc;

figure(1)
hold on
for i = 1:length(config)
    scatter(config(i), controlD(i), 40, markers(i),'LineWidth',1.5);
end
grid on
xlabel({'Configuration'},'FontSize',12)
ylabel({'dAy/dStr'},'FontSize',12)
title('Steering Control Sensitivity vs. Configuration')

figure(2)
hold on
for i = 1:length(config)
    scatter(config(i), maxLatAcc(i), 40, markers(i),'LineWidth',1.5);
end
grid on
xlabel({'Configuration'},'FontSize',12)
ylabel({'Max Lateral Acceleration (m/s^2)'},'FontSize',12)
title('Maximum Lateral Acceleration vs. Configuration')

figure(3)
hold on
for i = 1:length(config)
    scatter(config(i), maxAcc(i), 40, markers(i),'LineWidth',1.5);
end
grid on
xlabel({'Configuration'},'FontSize',12)
ylabel({'Max Acceleration (m/s^2)'},'FontSize',12)
title('Max Acceleration vs. Configuration')

figure(4)
hold on
for i = 1:length(config)
    scatter(config(i), maxVel(i), 40, markers(i),'LineWidth',1.5);
end
grid on
xlabel({'Configuration'},'FontSize',12)
ylabel({'Max Velocity (m/s)'},'FontSize',12)
title('Max Velocity vs. Configuration')