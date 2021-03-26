clear all;
clc;

T = readtable('C:\Users\stw2nf\Box\Descent Testing\Experiment Design\baselineThrottle.csv');

figure(1)
plot(T.BaselineThrottle, T.PowerConsumption_W_, 'LineWidth',1);
xlabel('Baseline Throttle');
ylabel('Power (W)');
grid on
hold on

figure(2)
plot(T.BaselineThrottle, T.Energy_Wmin_ft_, 'LineWidth',1);
xlabel('Baseline Throttle');
ylabel('Energy per Descent (Wmin/ft)');
grid on
hold on

figure(3)
plot(T.BaselineThrottle, T.RollErrorMean_deg_,...
     T.BaselineThrottle, T.PitchErrorMean_deg_,...
     T.BaselineThrottle, T.YawErrorMean_deg_, 'LineWidth',1);
xlabel('Baseline Throttle');
ylabel('Angle MAE (deg)');
legend('Roll MAE', 'Pitch MAE', 'Yaw MAE')
grid on
hold on