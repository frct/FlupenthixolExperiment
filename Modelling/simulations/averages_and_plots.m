% do the average simulations and the plots

clear all
close all
addpath('../../Experiment')

dose = 3;
condition = ['Flu' num2str(dose)];
addpath(['flu' num2str(dose)])
load('chunked simulations.mat')
rmpath(['flu' num2str(dose)])

rats = [27 : 35 37 : 50]; % rat 36 did not do any of the flu3 trials, rats 27, 31, 34, 44 and 49 have at least one subblock in one dose condition where WS is not defined
n_rats = length(rats);

%% we are doing trial-by-trial averages

averagePerf = zeros(n_rats,24,2); % 24 lines for the number of rats, 24 columns for each trial, two depth for the two risk levels
averageWin = zeros(n_rats,24,2);
averageLose = zeros(n_rats,24,2);

%% fill in the average and sem cells for each risk and stage
for risk = 1:2
    p = []; % matrix that will contain performance of the 24 rats in the given risk and stage combination
    w = [];
    l = [];
    
    rat_idx = 1;
    
    for rat = 1 : n_rats;
        p = (reshape(chunked_perf{rat,risk},24,[]))'; % get a matrix with blocks as lines, and 24 trials (for each block) in column
        w = (reshape(chunked_win{rat,risk},24,[]))';
        l = (reshape(chunked_lose{rat,risk},24,[]))';
        
        averagePerf(rat_idx, :, risk) = nanmean(p); % average for trials 1, trials 2, etc. and trials 24
        averageWin(rat_idx, :, risk) = nanmean(w);
        averageLose(rat_idx, :, risk) = nanmean(l);
        
        rat_idx = rat_idx + 1;
    end
end

%% extract original data averages

A = load('../../Experiment/raw data.mat');
fname = fields(A);
data = A.(fname{dose + 1});

data_avgPerf = zeros(n_rats,24,2);
data_avgWin = zeros(n_rats,24,2);
data_avgLose = zeros(n_rats,24,2);

for risk = 1:2
    
    rat_idx = 1;
    
    for rat = rats
        
        rat_data = data(data(:,1) == rat & data(:,6) == mod(risk,2), :);
        
        Perf = rat_data(:,4) == rat_data(:,5);
        nt = length(Perf);
        Win = NaN * ones(nt,1);
        Lose = NaN * ones(nt,1);
        
        for t = 2:nt % win- and lose-shift are not defined for trial 1
            if rat_data(t,3) == rat_data(t-1,3) && rat_data(t,1) == rat_data(t-1,1)% win- and lose-shift undefined for first trials of any blocks
                if rat_data(t-1,7) == 1 && rat_data(t-1,5) == rat_data(t-1,4)
                    Win(t) = rat_data(t,5) ~= rat_data(t-1,5);
                elseif rat_data(t-1,7) == 0
                    Lose(t) = rat_data(t,5) ~= rat_data(t-1,5);
                end
            end
        end
        
        Perf = (reshape(Perf,24,[]))';
        Win = (reshape(Win,24,[]))';
        Lose = (reshape(Lose,24,[]))';
        
        data_avgPerf(rat_idx, :, risk) = nanmean(Perf);
        data_avgWin(rat_idx, :, risk) = nanmean(Win);
        data_avgLose(rat_idx, :, risk) = nanmean(Lose);
        
        rat_idx = rat_idx + 1;
    end
end

label1 = {'HR', 'LR'};

%% figures and MSE

MSE = struct('Perf',zeros(1,2), 'Win', zeros(1,2), 'Lose', zeros(1,2)); % structure containing the different mean squared-errors

figure(1)
idx_plot = 0;
suptitle(['Performance on ' condition])
for risk = 1:2
    idx_plot = idx_plot + 1;
    
    Y1 = 100 * mean(averagePerf(:,:,risk));
    E1 = 100 * nansem(averagePerf(:,:,risk));
    
    Y2 = 100 * mean(data_avgPerf(:,:,risk));
    E2 = 100 * nansem(data_avgPerf(:,:,risk));
    
    MSE.Perf(risk) = sum((Y1 - Y2).^2) / 24;
    
    subplot(1,2,idx_plot)
    hold on
    title(label1{risk})
    axis([0 25 0 100])
    axis square
    errorbar(1:24, Y1, E1,'r')
    errorbar(1:24, Y2, E2)
    legend('simulated','original','Location', 'southEast')
end
saveas(gcf,['flu' num2str(dose) '/Evolution of performance on ' condition '.png'])

figure(2)
idx_plot = 0;
suptitle(['Win-shift on ' condition])
for risk = 1:2
    idx_plot = idx_plot + 1;
    
    Y1 = 100 * nanmean(averageWin(:,:,risk));
    E1 = 100 * nansem(averageWin(:,:,risk));
    
    Y2 = 100 * nanmean(data_avgWin(:,:,risk));
    E2 = 100 * nansem(data_avgWin(:,:,risk));
    
    MSE.Win(risk) = sum((Y1(2:24) - Y2(2:24)).^2) / 23; % win-shift is never defined for first trial, so that there are 23 instead of 24 observations
    
    subplot(1,2,idx_plot)
    hold on
    title(label1{risk})
    axis([0 25 0 100])
    axis square
    errorbar(2:24, Y1(2:24), E1(2:24),'r')
    errorbar(2:24, Y2(2:24), E2(2:24))
    legend('simulated','original', 'Location', 'southeast')
end
saveas(gcf,['flu' num2str(dose) '/Evolution of win-shift on ' condition '.png'])

figure(3)
idx_plot = 0;
suptitle(['Lose-shift on ' condition])
for risk = 1:2
    idx_plot = idx_plot + 1;
    
    Y1 = 100 * nanmean(averageLose(:,:,risk));
    E1 = 100 * nansem(averageLose(:,:,risk));
    
    Y2 = 100 * nanmean(data_avgLose(:,:,risk));
    E2 = 100 * nansem(data_avgLose(:,:,risk));
    
    MSE.Lose(risk) = sum((Y1(2:24) - Y2(2:24)).^2) / 23; % win-shift is never defined for first trial, so that there are 23 instead of 24 observations
    
    subplot(1,2,idx_plot)
    hold on
    title(label1{risk})
    axis([0 25 0 100])
    axis square
    errorbar(2:24, Y1(2:24), E1(2:24),'r')
    errorbar(2:24, Y2(2:24), E2(2:24))
    legend('simulated','original','Location', 'southeast')
end
saveas(gcf,['flu' num2str(dose) '/Evolution of lose-shift on ' condition '.png'])

save(['flu' num2str(dose) '/MSE'], 'MSE')

%% postface

rmpath('../../Experiment')