% extract intra-block dynamics for 4 by 4 trials sub-blocks

%% prologue

clear all
close all

%% initializations

doses = 0 : 3;
n_doses = length(doses);
risk = {'LR', 'HR'};
rat_ids = [27 : 35 37 : 50]; % rat 36 did not do enough of the flu3 trials
n_rats = length(rat_ids);

All = load('raw data');
Dose_Fieldnames = fields(All);

%% 

for d = doses
    data = All.(Dose_Fieldnames{d + 1});
    
    idy = 1;
    
    for rat_id = rat_ids
        rat_data = data(data(:,1) == rat_id, :);
        rat.HR = rat_data(rat_data(:,6) == 1, :);
        rat.LR = rat_data(rat_data(:,6) == 0, :);
        for r = 1 : 2
            means = subblocks_behavmarkers(rat.(risk{r}));
            Perf.(risk{r})(idy,:) = means.perf;
            Win.(risk{r})(idy,:) = means.win;
            Lose.(risk{r})(idy,:) = means.lose;            
        end
        idy = idy + 1;
    end
    save(['Flu' num2str(d) ' block measures'], 'Perf', 'Win', 'Lose')
end