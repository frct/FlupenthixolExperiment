% get the best set of parameters from each fmcResults = for each rat

clear all
close all

nb_params = 3;
dose = 3;
idxLL = nb_params + 1;
rats = 27 : 50;
n_rats = length(rats);

load('../../Experiment/raw data.mat')

%% remember to also change this line when changing dose
data = Flu3;
%%

Best = zeros(n_rats, nb_params + 7);

for rat = rats
    
    load (['flu' num2str(dose) '/Rat' num2str(rat) '_fmcResults.mat'])
    [BestLL, idxBest] = min (fmcResults(:, idxLL));
    n_trials = length(data(data(:,1) == rat, 1));
    
    % we carry out a likelihood ratio test with model0 (ie equiprobable
    % selection of levers on every trial)
    LL0 = - n_trials * log(1/3);
    d = 2 * (LL0 - BestLL);
    p_value = 1 - chi2cdf(d, nb_params);
    
    % we also calculate individual AIC and BIC scores used for model
    % comparisons
    
    AIC = 2 * BestLL + 2 * nb_params;
    BIC = 2 * BestLL + nb_params * log(n_trials);
    
    Best(rat - 26, :) = [fmcResults(idxBest,:) n_trials LL0 d p_value AIC BIC];
end

save(['flu' num2str(dose) '/Best parameters on flu' num2str(dose)], 'Best')