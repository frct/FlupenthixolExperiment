% chunck Perf, Win and Lose of simulations into different risk groups for 
% future averaging and plotting

clear all
close all
addpath('../../../../../..') % to get lines_to_be_deleted

dose = 3;
condition = ['Flu' num2str(dose)];
load(['flu' num2str(dose) '/Preliminary analysis of simulations.mat'])

rats = [27 : 35 37 : 50]; % rat 36 did not do any of the flu3 trials
n_rats = length(rats);

%% indices for different chunks
hr = 1;
lr = 2;

%% initiate chunked indicators
chunked_perf = cell(n_rats,2); % height corresponds to 24 rats, width to (early,middle,late), and depth to (HR,LR)
chunked_win = cell(n_rats,2);
chunked_lose = cell(n_rats,2);

addpath(['flu' num2str(dose)])

for h = 1 : n_rats %sweeping through rats
    rat = rats(h);
    load([condition 'Rat' num2str(rat) '_100simulations.mat']) % required for risk level information
    l = lines_to_be_deleted(rat_data); %gets the indices of trials belonging to unfinished blocks
    rat_data(l,:) = []; % removing unfinished blocks
    
    %% get indices of different category of trials
    HR = (rat_data(:,7)==1);
    LR = (rat_data(:,7)==0);
    
    chunked_perf{h,hr} = Perf{h}(HR,:);
    chunked_perf{h,lr} = Perf{h}(LR,:);
    chunked_win{h,hr} = Win{h}(HR,:);
    chunked_win{h,lr} = Win{h}(LR,:);
    chunked_lose{h,hr} = Lose{h}(HR,:);
    chunked_lose{h,lr} = Lose{h}(LR,:);
end

rmpath(['flu' num2str(dose)])
rmpath('../../../../../..')
save(['flu' num2str(dose) '/chunked simulations'], 'chunked_perf', 'chunked_win', 'chunked_lose')