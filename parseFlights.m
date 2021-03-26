clear all;
clc;

%% Conversion units
kj2wmin = 16.67;
j2wmin = .017;
manuevers = [0 10 20 30 0 10 20 30 0 10 20 30 0 10 20 30 40]';
descentCat = {'Slow', 'Slow', 'Slow', 'Slow', 'Medium', 'Medium', 'Medium', 'Medium', 'Fast', 'Fast', 'Fast', 'Fast', 'Very Fast', 'Very Fast', 'Very Fast', 'Very Fast', 'Very Fast'}';
descentCat = categorical(descentCat);
descentCat = reordercats(descentCat,{'Slow','Medium','Fast', 'Very Fast'});
%% Read in data from results csv file
T = readtable('C:\Users\Sean\Box\Descent Testing\Experiment Design\ExperimentDesign.csv');
results = table(T.LogName, T.Mode, T.DescentRate, T.Manuever_deg_, T.DescentRate_feet_sec_, T.PowerConsumptionMean_Watts_,T.PowerConsumptionStd_Watts_, T.EnergyConsumption_kJ_.*kj2wmin, T.EnergyPerDescent_J_ft_.*j2wmin,T.GlideRatio, T.RollErrorMean_deg_, T.PitchErrorMean_deg_, T.YawErrorMean_deg_);
varNames = {'logName', 'mode', 'desiredRate','manuever', 'descentRate','powerMean', 'powerStd', 'energy', 'energyPerFoot', 'glideRatio', 'rollError', 'pitchError', 'yawError'};
results.Properties.VariableNames = varNames;

%% Create tables for different descent modes
sz = [0 size(results,2)];
varTypes = ["string", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

inverted0 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
inverted10 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
inverted20 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
inverted30 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
inverted40 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);

normal = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);

slow0 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
slow10 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
slow20 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
slow30 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);

medium0 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
medium10 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
medium20 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
medium30 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);

fast0 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
fast10 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
fast20 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);
fast30 = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);

check = 0;

%% Filter through data based on descent mode
for i=1:length(results.mode)
   %Find mode and desired rate of current step
   curMode = results.mode{i};
   curDesRate = results.desiredRate{i};
   curManuever = results.manuever(i);
   
   %Make sure there is data for the step
   dataCheck = results.descentRate(i);
   
   %Is this a manual test? if so add to inverted test table
   check = (strcmpi(curMode,'Manual')==1);
   if (check == 1) && (dataCheck ~= 0)
       %Determine manuever and add to test table
       switch curManuever
           case 0
              inverted0 = vertcat(inverted0, results(i,:));
           case 10
              inverted10 = vertcat(inverted10, results(i,:));
           case 20
              inverted20 = vertcat(inverted20, results(i,:));
           case 30
              inverted30 = vertcat(inverted30, results(i,:));
           case 40
              inverted40 = vertcat(inverted40, results(i,:));
       end
   end
   
   %Is this a Altitude test? if so add to normal descent test table
   check = (strcmpi(curMode,'Altitude')==1);
   if (check == 1) && (dataCheck ~= 0)
       normal = vertcat(normal, results(i,:));
       
       %%Is this a slow test? if so add to normal slow descent test table
       check = (strcmpi(curDesRate,'Slow')==1);
       if (check == 1)
           %Determine manuever and add to test table
           switch curManuever
               case 0
                  slow0 = vertcat(slow0, results(i,:));
               case 10
                  slow10 = vertcat(slow10, results(i,:));
               case 20
                  slow20 = vertcat(slow20, results(i,:));
               case 30
                  slow30 = vertcat(slow30, results(i,:));
           end
       
       end
       
       %%Is this a medium test? if so add to normal medium descent test table
       check = (strcmpi(curDesRate,'Medium')==1);
       if (check == 1)
           %Determine manuever and add to test table
           switch curManuever
               case 0
                  medium0 = vertcat(medium0, results(i,:));
               case 10
                  medium10 = vertcat(medium10, results(i,:));
               case 20
                  medium20 = vertcat(medium20, results(i,:));
               case 30
                  medium30 = vertcat(medium30, results(i,:));
           end
       end
       
       %%Is this a fast test? if so add to normal fast descent test table
       check = (strcmpi(curDesRate,'Fast')==1);
       if (check == 1)
           %Determine manuever and add to test table
           switch curManuever
               case 0
                  fast0 = vertcat(fast0, results(i,:));
               case 10
                  fast10 = vertcat(fast10, results(i,:));
               case 20
                  fast20 = vertcat(fast20, results(i,:));
               case 30
                  fast30 = vertcat(fast30, results(i,:));
           end
       end
   end
end
%% Calculate Energy Metrics
slow0EnergyMean = mean(nonzeros(slow0.energyPerFoot));
slow0EnergyCI = cInterval(nonzeros(slow0.energyPerFoot));
slow10EnergyMean = mean(nonzeros(slow10.energyPerFoot));
slow10EnergyCI = cInterval(nonzeros(slow10.energyPerFoot));
slow20EnergyMean = mean(nonzeros(slow20.energyPerFoot));
slow20EnergyCI = cInterval(nonzeros(slow20.energyPerFoot));
slow30EnergyMean = mean(nonzeros(slow30.energyPerFoot));
slow30EnergyCI = cInterval(nonzeros(slow30.energyPerFoot));
slowEnergyMean = [slow0EnergyMean slow10EnergyMean slow20EnergyMean slow30EnergyMean]';
slowEnergyCI = [slow0EnergyCI slow10EnergyCI slow20EnergyCI slow30EnergyCI]';

med0EnergyMean = mean(nonzeros(medium0.energyPerFoot));
med0EnergyCI = cInterval(nonzeros(medium0.energyPerFoot));
med10EnergyMean = mean(nonzeros(medium10.energyPerFoot));
med10EnergyCI = cInterval(nonzeros(medium10.energyPerFoot));
med20EnergyMean = mean(nonzeros(medium20.energyPerFoot));
med20EnergyCI = cInterval(nonzeros(medium20.energyPerFoot));
med30EnergyMean = mean(nonzeros(medium30.energyPerFoot));
med30EnergyCI = cInterval(nonzeros(medium30.energyPerFoot));
medEnergyMean = [med0EnergyMean med10EnergyMean med20EnergyMean med30EnergyMean]';
medEnergyCI = [med0EnergyCI med10EnergyCI med20EnergyCI med30EnergyCI]';

fast0EnergyMean = mean(nonzeros(fast0.energyPerFoot));
fast0EnergyCI = cInterval(nonzeros(fast0.energyPerFoot));
fast10EnergyMean = mean(nonzeros(fast10.energyPerFoot));
fast10EnergyCI = cInterval(nonzeros(fast10.energyPerFoot));
fast20EnergyMean = mean(nonzeros(fast20.energyPerFoot));
fast20EnergyCI = cInterval(nonzeros(fast20.energyPerFoot));
fast30EnergyMean = mean(nonzeros(fast30.energyPerFoot));
fast30EnergyCI = cInterval(nonzeros(fast30.energyPerFoot));
fastEnergyMean = [fast0EnergyMean fast10EnergyMean fast20EnergyMean fast30EnergyMean]';
fastEnergyCI = [fast0EnergyCI fast10EnergyCI fast20EnergyCI fast30EnergyCI]';

inverted0EnergyMean = mean(nonzeros(inverted0.energyPerFoot));
inverted0EnergyCI = cInterval(nonzeros(inverted0.energyPerFoot));
inverted10EnergyMean = mean(nonzeros(inverted10.energyPerFoot));
inverted10EnergyCI = cInterval(nonzeros(inverted10.energyPerFoot));
inverted20EnergyMean = mean(nonzeros(inverted20.energyPerFoot));
inverted20EnergyCI = cInterval(nonzeros(inverted20.energyPerFoot));
inverted30EnergyMean = mean(nonzeros(inverted30.energyPerFoot));
inverted30EnergyCI = cInterval(nonzeros(inverted30.energyPerFoot));
inverted40EnergyMean = mean(nonzeros(inverted40.energyPerFoot));
inverted40EnergyCI = cInterval(nonzeros(inverted40.energyPerFoot));
invertedEnergyMean = [inverted0EnergyMean inverted10EnergyMean inverted20EnergyMean inverted30EnergyMean inverted40EnergyMean]';
invertedEnergyCI = [inverted0EnergyCI inverted10EnergyCI inverted20EnergyCI inverted30EnergyCI inverted40EnergyCI]';

energyMean = vertcat(slowEnergyMean, medEnergyMean, fastEnergyMean, invertedEnergyMean);
energyCI = vertcat(slowEnergyCI, medEnergyCI, fastEnergyCI, invertedEnergyCI);
%% Calculate Power Metrics
slow0PwrMean = mean(nonzeros(slow0.powerMean));
slow0PwrCI = cInterval(nonzeros(slow0.powerMean));
slow10PwrMean = mean(nonzeros(slow10.powerMean));
slow10PwrCI = cInterval(nonzeros(slow10.powerMean));
slow20PwrMean = mean(nonzeros(slow20.powerMean));
slow20PwrCI = cInterval(nonzeros(slow20.powerMean));
slow30PwrMean = mean(nonzeros(slow30.powerMean));
slow30PwrCI = cInterval(nonzeros(slow30.powerMean));
slowPwrMean = [slow0PwrMean slow10PwrMean slow20PwrMean slow30PwrMean]';
slowPwrCI = [slow0PwrCI slow10PwrCI slow20PwrCI slow30PwrCI]';

med0PwrMean = mean(nonzeros(medium0.powerMean));
med0PwrCI = cInterval(nonzeros(medium0.powerMean));
med10PwrMean = mean(nonzeros(medium10.powerMean));
med10PwrCI = cInterval(nonzeros(medium10.powerMean));
med20PwrMean = mean(nonzeros(medium20.powerMean));
med20PwrCI = cInterval(nonzeros(medium20.powerMean));
med30PwrMean = mean(nonzeros(medium30.powerMean));
med30PwrCI = cInterval(nonzeros(medium30.powerMean));
medPwrMean = [med0PwrMean med10PwrMean med20PwrMean med30PwrMean]';
medPwrCI = [med0PwrCI med10PwrCI med20PwrCI med30PwrCI]';

fast0PwrMean = mean(nonzeros(fast0.powerMean));
fast0PwrCI = cInterval(nonzeros(fast0.powerMean));
fast10PwrMean = mean(nonzeros(fast10.powerMean));
fast10PwrCI = cInterval(nonzeros(fast10.powerMean));
fast20PwrMean = mean(nonzeros(fast20.powerMean));
fast20PwrCI = cInterval(nonzeros(fast20.powerMean));
fast30PwrMean = mean(nonzeros(fast30.powerMean));
fast30PwrCI = cInterval(nonzeros(fast30.powerMean));
fastPwrMean = [fast0PwrMean fast10PwrMean fast20PwrMean fast30PwrMean]';
fastPwrCI = [fast0PwrCI fast10PwrCI fast20PwrCI fast30PwrCI]';

inverted0PwrMean = mean(nonzeros(inverted0.powerMean));
inverted0PwrCI = cInterval(nonzeros(inverted0.powerMean));
inverted10PwrMean = mean(nonzeros(inverted10.powerMean));
inverted10PwrCI = cInterval(nonzeros(inverted10.powerMean));
inverted20PwrMean = mean(nonzeros(inverted20.powerMean));
inverted20PwrCI = cInterval(nonzeros(inverted20.powerMean));
inverted30PwrMean = mean(nonzeros(inverted30.powerMean));
inverted30PwrCI = cInterval(nonzeros(inverted30.powerMean));
inverted40PwrMean = mean(nonzeros(inverted40.powerMean));
inverted40PwrCI = cInterval(nonzeros(inverted40.powerMean));
invertedPwrMean = [inverted0PwrMean inverted10PwrMean inverted20PwrMean inverted30PwrMean inverted40PwrMean]';
invertedPwrCI = [inverted0PwrCI inverted10PwrCI inverted20PwrCI inverted30PwrCI inverted40PwrCI]';

powerMean = vertcat(slowPwrMean, medPwrMean, fastPwrMean, invertedPwrMean);
powerCI = vertcat(slowPwrCI, medPwrCI, fastPwrCI, invertedPwrCI);

%% Calculate Glide Ratio
slow0Glide = mean(nonzeros(slow0.glideRatio));
slow0GlideCI = cInterval(nonzeros(slow0.glideRatio));
slow10Glide = mean(nonzeros(slow10.glideRatio));
slow10GlideCI = cInterval(nonzeros(slow10.glideRatio));
slow20Glide = mean(nonzeros(slow20.glideRatio));
slow20GlideCI = cInterval(nonzeros(slow20.glideRatio));
slow30Glide = mean(nonzeros(slow30.glideRatio));
slow30GlideCI = cInterval(nonzeros(slow30.glideRatio));
slowGlide = [slow0Glide slow10Glide slow20Glide slow30Glide]';
slowGlideCI = [slow0GlideCI slow10GlideCI slow20GlideCI slow30GlideCI]';

med0Glide = mean(nonzeros(medium0.glideRatio));
med0GlideCI = cInterval(nonzeros(medium0.glideRatio));
med10Glide = mean(nonzeros(medium10.glideRatio));
med10GlideCI = cInterval(nonzeros(medium10.glideRatio));
med20Glide = mean(nonzeros(medium20.glideRatio));
med20GlideCI = cInterval(nonzeros(medium20.glideRatio));
med30Glide = mean(nonzeros(medium30.glideRatio));
med30GlideCI = cInterval(nonzeros(medium30.glideRatio));
medGlide = [med0Glide med10Glide med20Glide med30Glide]';
medGlideCI = [med0GlideCI med10GlideCI med20GlideCI med30GlideCI]';

fast0Glide = mean(nonzeros(fast0.glideRatio));
fast0GlideCI = cInterval(nonzeros(fast0.glideRatio));
fast10Glide = mean(nonzeros(fast10.glideRatio));
fast10GlideCI = cInterval(nonzeros(fast10.glideRatio));
fast20Glide = mean(nonzeros(fast20.glideRatio));
fast20GlideCI = cInterval(nonzeros(fast20.glideRatio));
fast30Glide = mean(nonzeros(fast30.glideRatio));
fast30GlideCI = cInterval(nonzeros(fast30.glideRatio));
fastGlide = [fast0Glide fast10Glide fast20Glide fast30Glide]';
fastGlideCI = [fast0GlideCI fast10GlideCI fast20GlideCI fast30GlideCI]';

inverted0Glide = mean(nonzeros(inverted0.glideRatio));
inverted0GlideCI = cInterval(nonzeros(inverted0.glideRatio));
inverted10Glide = mean(nonzeros(inverted10.glideRatio));
inverted10GlideCI = cInterval(nonzeros(inverted10.glideRatio));
inverted20Glide = mean(nonzeros(inverted20.glideRatio));
inverted20GlideCI = cInterval(nonzeros(inverted20.glideRatio));
inverted30Glide = mean(nonzeros(inverted30.glideRatio));
inverted30GlideCI = cInterval(nonzeros(inverted30.glideRatio));
inverted40Glide = mean(nonzeros(inverted40.glideRatio));
inverted40GlideCI = cInterval(nonzeros(inverted40.glideRatio));
invertedGlide = [inverted0Glide inverted10Glide inverted20Glide inverted30Glide inverted40Glide]';
invertedGlideCI = [inverted0GlideCI inverted10GlideCI inverted20GlideCI inverted30GlideCI inverted40GlideCI]';

glideRatio = vertcat(slowGlide, medGlide, fastGlide, invertedGlide);
powerCI = vertcat(slowGlideCI, medGlideCI, fastGlideCI, invertedGlideCI);

%% Calculate Control Metrics
slow0RollErrorMean = mean(nonzeros(slow0.rollError));
slow0RollErrorCI = cInterval(nonzeros(slow0.rollError));
slow10RollErrorMean = mean(nonzeros(slow10.rollError));
slow10RollErrorCI = cInterval(nonzeros(slow10.rollError));
slow20RollErrorMean = mean(nonzeros(slow20.rollError));
slow20RollErrorCI = cInterval(nonzeros(slow20.rollError));
slow30RollErrorMean = mean(nonzeros(slow30.rollError));
slow30RollErrorCI = cInterval(nonzeros(slow30.rollError));
slowRollErrorMean = [slow0RollErrorMean slow10RollErrorMean slow20RollErrorMean slow30RollErrorMean]';
slowRollErrorCI = [slow0RollErrorCI slow10RollErrorCI slow20RollErrorCI slow30RollErrorCI]';

med0RollErrorMean = mean(nonzeros(medium0.rollError));
med0RollErrorCI = cInterval(nonzeros(medium0.rollError));
med10RollErrorMean = mean(nonzeros(medium10.rollError));
med10RollErrorCI = cInterval(nonzeros(medium10.rollError));
med20RollErrorMean = mean(nonzeros(medium20.rollError));
med20RollErrorCI = cInterval(nonzeros(medium20.rollError));
med30RollErrorMean = mean(nonzeros(medium30.rollError));
med30RollErrorCI = cInterval(nonzeros(medium30.rollError));
medRollErrorMean = [med0RollErrorMean med10RollErrorMean med20RollErrorMean med30RollErrorMean]';
medRollErrorCI = [med0RollErrorCI med10RollErrorCI med20RollErrorCI med30RollErrorCI]';

fast0RollErrorMean = mean(nonzeros(fast0.rollError));
fast0RollErrorCI = cInterval(nonzeros(fast0.rollError));
fast10RollErrorMean = mean(nonzeros(fast10.rollError));
fast10RollErrorCI = cInterval(nonzeros(fast10.rollError));
fast20RollErrorMean = mean(nonzeros(fast20.rollError));
fast20RollErrorCI = cInterval(nonzeros(fast20.rollError));
fast30RollErrorMean = mean(nonzeros(fast30.rollError));
fast30RollErrorCI = cInterval(nonzeros(fast30.rollError));
fastRollErrorMean = [fast0RollErrorMean fast10RollErrorMean fast20RollErrorMean fast30RollErrorMean]';
fastRollErrorCI = [fast0RollErrorCI fast10RollErrorCI fast20RollErrorCI fast30RollErrorCI]';

inverted0RollErrorMean = mean(nonzeros(inverted0.rollError));
inverted0RollErrorCI = cInterval(nonzeros(inverted0.rollError));
inverted10RollErrorMean = mean(nonzeros(inverted10.rollError));
inverted10RollErrorCI = cInterval(nonzeros(inverted10.rollError));
inverted20RollErrorMean = mean(nonzeros(inverted20.rollError));
inverted20RollErrorCI = cInterval(nonzeros(inverted20.rollError));
inverted30RollErrorMean = mean(nonzeros(inverted30.rollError));
inverted30RollErrorCI = cInterval(nonzeros(inverted30.rollError));
inverted40RollErrorMean = mean(nonzeros(inverted40.rollError));
inverted40RollErrorCI = cInterval(nonzeros(inverted40.rollError));
invertedRollErrorMean = [inverted0RollErrorMean inverted10RollErrorMean inverted20RollErrorMean inverted30RollErrorMean inverted40RollErrorMean]';
invertedRollErrorCI = [inverted0RollErrorCI inverted10RollErrorCI inverted20RollErrorCI inverted30RollErrorCI inverted40RollErrorCI]';

rollError = vertcat(slowRollErrorMean, medRollErrorMean, fastRollErrorMean, invertedRollErrorMean);
rollErrorCI = vertcat(slowRollErrorCI, medRollErrorCI, fastRollErrorCI, invertedRollErrorCI);

slow0PitchErrorMean = mean(nonzeros(slow0.pitchError));
slow0PitchErrorCI = cInterval(nonzeros(slow0.pitchError));
slow10PitchErrorMean = mean(nonzeros(slow10.pitchError));
slow10PitchErrorCI = cInterval(nonzeros(slow10.pitchError));
slow20PitchErrorMean = mean(nonzeros(slow20.pitchError));
slow20PitchErrorCI = cInterval(nonzeros(slow20.pitchError));
slow30PitchErrorMean = mean(nonzeros(slow30.pitchError));
slow30PitchErrorCI = cInterval(nonzeros(slow30.pitchError));
slowPitchErrorMean = [slow0PitchErrorMean slow10PitchErrorMean slow20PitchErrorMean slow30PitchErrorMean]';
slowPitchErrorCI = [slow0PitchErrorCI slow10PitchErrorCI slow20PitchErrorCI slow30PitchErrorCI]';

med0PitchErrorMean = mean(nonzeros(medium0.pitchError));
med0PitchErrorCI = cInterval(nonzeros(medium0.pitchError));
med10PitchErrorMean = mean(nonzeros(medium10.pitchError));
med10PitchErrorCI = cInterval(nonzeros(medium10.pitchError));
med20PitchErrorMean = mean(nonzeros(medium20.pitchError));
med20PitchErrorCI = cInterval(nonzeros(medium20.pitchError));
med30PitchErrorMean = mean(nonzeros(medium30.pitchError));
med30PitchErrorCI = cInterval(nonzeros(medium30.pitchError));
medPitchErrorMean = [med0PitchErrorMean med10PitchErrorMean med20PitchErrorMean med30PitchErrorMean]';
medPitchErrorCI = [med0PitchErrorCI med10PitchErrorCI med20PitchErrorCI med30PitchErrorCI]';

fast0PitchErrorMean = mean(nonzeros(fast0.pitchError));
fast0PitchErrorCI = cInterval(nonzeros(fast0.pitchError));
fast10PitchErrorMean = mean(nonzeros(fast10.pitchError));
fast10PitchErrorCI = cInterval(nonzeros(fast10.pitchError));
fast20PitchErrorMean = mean(nonzeros(fast20.pitchError));
fast20PitchErrorCI = cInterval(nonzeros(fast20.pitchError));
fast30PitchErrorMean = mean(nonzeros(fast30.pitchError));
fast30PitchErrorCI = cInterval(nonzeros(fast30.pitchError));
fastPitchErrorMean = [fast0PitchErrorMean fast10PitchErrorMean fast20PitchErrorMean fast30PitchErrorMean]';
fastPitchErrorCI = [fast0PitchErrorCI fast10PitchErrorCI fast20PitchErrorCI fast30PitchErrorCI]';

inverted0PitchErrorMean = mean(nonzeros(inverted0.pitchError));
inverted0PitchErrorCI = cInterval(nonzeros(inverted0.pitchError));
inverted10PitchErrorMean = mean(nonzeros(inverted10.pitchError));
inverted10PitchErrorCI = cInterval(nonzeros(inverted10.pitchError));
inverted20PitchErrorMean = mean(nonzeros(inverted20.pitchError));
inverted20PitchErrorCI = cInterval(nonzeros(inverted20.pitchError));
inverted30PitchErrorMean = mean(nonzeros(inverted30.pitchError));
inverted30PitchErrorCI = cInterval(nonzeros(inverted30.pitchError));
inverted40PitchErrorMean = mean(nonzeros(inverted40.pitchError));
inverted40PitchErrorCI = cInterval(nonzeros(inverted40.pitchError));
invertedPitchErrorMean = [inverted0PitchErrorMean inverted10PitchErrorMean inverted20PitchErrorMean inverted30PitchErrorMean inverted40PitchErrorMean]';
invertedPitchErrorCI = [inverted0PitchErrorCI inverted10PitchErrorCI inverted20PitchErrorCI inverted30PitchErrorCI inverted40PitchErrorCI]';

pitchError = vertcat(slowPitchErrorMean, medPitchErrorMean, fastPitchErrorMean, invertedPitchErrorMean);
pitchErrorCI = vertcat(slowPitchErrorCI, medPitchErrorCI, fastPitchErrorCI, invertedPitchErrorCI);

slow0YawErrorMean = mean(nonzeros(slow0.yawError));
slow0YawErrorCI = cInterval(nonzeros(slow0.yawError));
slow10YawErrorMean = mean(nonzeros(slow10.yawError));
slow10YawErrorCI = cInterval(nonzeros(slow10.yawError));
slow20YawErrorMean = mean(nonzeros(slow20.yawError));
slow20YawErrorCI = cInterval(nonzeros(slow20.yawError));
slow30YawErrorMean = mean(nonzeros(slow30.yawError));
slow30YawErrorCI = cInterval(nonzeros(slow30.yawError));
slowYawErrorMean = [slow0YawErrorMean slow10YawErrorMean slow20YawErrorMean slow30YawErrorMean]';
slowYawErrorCI = [slow0YawErrorCI slow10YawErrorCI slow20YawErrorCI slow30YawErrorCI]';

med0YawErrorMean = mean(nonzeros(medium0.yawError));
med0YawErrorCI = cInterval(nonzeros(medium0.yawError));
med10YawErrorMean = mean(nonzeros(medium10.yawError));
med10YawErrorCI = cInterval(nonzeros(medium10.yawError));
med20YawErrorMean = mean(nonzeros(medium20.yawError));
med20YawErrorCI = cInterval(nonzeros(medium20.yawError));
med30YawErrorMean = mean(nonzeros(medium30.yawError));
med30YawErrorCI = cInterval(nonzeros(medium30.yawError));
medYawErrorMean = [med0YawErrorMean med10YawErrorMean med20YawErrorMean med30YawErrorMean]';
medYawErrorCI = [med0YawErrorCI med10YawErrorCI med20YawErrorCI med30YawErrorCI]';

fast0YawErrorMean = mean(nonzeros(fast0.yawError));
fast0YawErrorCI = cInterval(nonzeros(fast0.yawError));
fast10YawErrorMean = mean(nonzeros(fast10.yawError));
fast10YawErrorCI = cInterval(nonzeros(fast10.yawError));
fast20YawErrorMean = mean(nonzeros(fast20.yawError));
fast20YawErrorCI = cInterval(nonzeros(fast20.yawError));
fast30YawErrorMean = mean(nonzeros(fast30.yawError));
fast30YawErrorCI = cInterval(nonzeros(fast30.yawError));
fastYawErrorMean = [fast0YawErrorMean fast10YawErrorMean fast20YawErrorMean fast30YawErrorMean]';
fastYawErrorCI = [fast0YawErrorCI fast10YawErrorCI fast20YawErrorCI fast30YawErrorCI]';

inverted0YawErrorMean = mean(nonzeros(inverted0.yawError));
inverted0YawErrorCI = cInterval(nonzeros(inverted0.yawError));
inverted10YawErrorMean = mean(nonzeros(inverted10.yawError));
inverted10YawErrorCI = cInterval(nonzeros(inverted10.yawError));
inverted20YawErrorMean = mean(nonzeros(inverted20.yawError));
inverted20YawErrorCI = cInterval(nonzeros(inverted20.yawError));
inverted30YawErrorMean = mean(nonzeros(inverted30.yawError));
inverted30YawErrorCI = cInterval(nonzeros(inverted30.yawError));
inverted40YawErrorMean = mean(nonzeros(inverted40.yawError));
inverted40YawErrorCI = cInterval(nonzeros(inverted40.yawError));
invertedYawErrorMean = [inverted0YawErrorMean inverted10YawErrorMean inverted20YawErrorMean inverted30YawErrorMean inverted40YawErrorMean]';
invertedYawErrorCI = [inverted0YawErrorCI inverted10YawErrorCI inverted20YawErrorCI inverted30YawErrorCI inverted40YawErrorCI]';

yawError = vertcat(slowYawErrorMean, medYawErrorMean, fastYawErrorMean, invertedYawErrorMean);
yawErrorCI = vertcat(slowYawErrorCI, medYawErrorCI, fastYawErrorCI, invertedYawErrorCI);

for i=1:length(descentCat)

    curManuever = manuevers(i);
    color = zeros(length(manuevers), 3);
    %Determine manuever and add to test table
    switch curManuever
       case 0
          color(i,:)=[0 0 1];
         
       case 10
          color(i,:)=[0 1 0];
          
       case 20
          color(i,:)=[1 0 0];
          
       case 30
          color(i,:)=[0.5 0.5 0.5];
          
       case 40
          color(i,:)=[0.25 0.75 0.25];
          
    end
    figure(1)
    %errorbar(descentCat(i),energyMean(i), energyCI(2*i-1), energyCI(2*i));
    scatter(descentCat(i),energyMean(i), [], color(i,:), 'filled');
    xlabel('Descent Rate');
    ylabel('Energy Consumed per Descent (Wmin/feet)');
    grid on
    hold on
    
    figure(2)
    %errorbar(descentCat(i),powerMean(i), powerCI(2*i-1), powerCI(2*i));
    scatter(descentCat(i),powerMean(i), [], color(i,:), 'filled');
    xlabel('Descent Rate');
    ylabel('Power (Wmin)');
    grid on
    hold on
    
    figure(3)
    %errorbar(descentCat(i), rollError(i), rollErrorCI(2*i-1), rollErrorCI(2*i));
    scatter(descentCat(i),rollError(i), [], color(i,:), 'filled');
    xlabel('Descent Rate');
    ylabel('Average Roll Error (deg)');
    grid on
    hold on
    
    figure(4)
    %errorbar(descentCat(i), pitchError(i), pitchErrorCI(2*i-1), pitchErrorCI(2*i));
    scatter(descentCat(i),pitchError(i), [], color(i,:), 'filled');
    xlabel('Descent Rate');
    ylabel('Average Pitch Error (deg)');
    grid on
    hold on
    
    figure(5)
    %errorbar(descentCat(i), yawError(i), yawErrorCI(2*i-1), yawErrorCI(2*i));
    scatter(descentCat(i), yawError(i), [], color(i,:), 'filled');
    xlabel('Descent Rate');
    ylabel('Average Yaw Error (deg)');
    grid on
    hold on
    
    figure(6)
    %errorbar(descentCat(i), yawError(i), yawErrorCI(2*i-1), yawErrorCI(2*i));
    scatter(descentCat(i), glideRatio(i), [], color(i,:), 'filled');
    xlabel('Descent Rate');
    ylabel('Glide Ratio');
    grid on
    hold on
end

%% Function for calculating confidence interval of vector
function CI = cInterval(x)
    if length(x)>1
        SEM = std(x)/sqrt(length(x));               % Standard Error
        ts = tinv([0.025  0.975],length(x)-1);      % T-Score
        CI = mean(x) + ts*SEM;                      % Confidence Intervals
    else
        CI=0;
    end
end