clear all;
clc;

ftps2mph = 0.681818;
T = readtable('C:\Users\stw2nf\Box\Descent Testing\Experiment Design\terminalVelocityIdentification.csv');

for i=1:length(T{1,:})
    
   x = 1:length(T{:,i});
   figure(1)
   plot(x, T{:,i}.*ftps2mph, 'LineWidth',1);
   xlabel('X');
   ylabel('Descent Rate (mph)');
   title('Terminal Velocity Identification');
   grid on
   hold on
    
end