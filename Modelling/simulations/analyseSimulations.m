% get simulated data, index performance, win-shift and lose-shift results
% to it

clear all
close all

dose = 3;
condition = ['Flu' num2str(dose)];
addpath(['flu' num2str(dose)])
rats = [27 : 35 37 : 50]; % rat 36 did not do any of the flu3 trials
n_rats = length(rats);

Perf = cell(n_rats,1); % a cell of 24 matrices for each rat, each matrix giving the performance score for each simulated set of choices
Win = cell(n_rats,1);
Lose = cell(n_rats,1);

for rat = 1 : n_rats
    %% load appropriate simulation
    rat_id = rats(rat);
    load([condition 'Rat' num2str(rat_id) '_100simulations.mat'])
    
    %% clean it
    l = lines_to_be_deleted(rat_data); %gets the indices of trials belonging to unfinished blocks
    rat_data(l,:) = []; % removing unfinished blocks
    nt = length(rat_data(:,1)); % number of trials for this rat
    choices(l,:) = []; % removing unfinished blocks from simulated data
    rewards(l,:) = [];
    
    %% compute performance matrix
    target = repmat(rat_data(:,5),1,100); %replicate the target column 100 times for direct comparison to simulated choices
    Perf{rat} = (choices == target); % perf = 1 when choice equals to target, 0 otherwise
    
    %% compute win-shift and lose-shift indices
    Win{rat} = NaN * ones(nt,100);
    Lose{rat} = NaN * ones(nt,100);
    
    for s = 1:100 % sweeping through simulations
        for t = 2:nt % sweeping through trials, first line is a line of NaNs because shifts are undefined
            if rat_data(t,3) == rat_data(t-1,3) % win and lose-shift are not defined at the first trial of a block
                if rewards(t-1,s) == 1 && choices(t-1,s) == target(t-1,s) % win-shift can occur only if there was a reward at t-1 and if the choice was correct
                    Win{rat}(t,s) = (choices(t,s) ~= choices(t-1,s)); % win-shift=1 if choice changes from previous trial and =0 if it's the same
                elseif rewards(t-1,s) == 0 % lose-shift situations occur whenever a previous choice was not rewarded
                    Lose{rat}(t,s) = (choices(t,s) ~= choices(t-1,s)); % =1 if different action, =0 if the same
                end
            end
        end
    end
    
    %% collapsing simulations by averaging
    Perf{rat} = mean(Perf{rat}, 2);
    Win{rat} = nanmean(Win{rat}, 2);
    Lose{rat} = nanmean(Lose{rat}, 2);
end

save(['flu' num2str(dose) '/Preliminary analysis of simulations'], 'Perf', 'Win', 'Lose')
rmpath(['flu' num2str(dose)])
rmpath('../../../../../..') % to get lines_to_be_deleted