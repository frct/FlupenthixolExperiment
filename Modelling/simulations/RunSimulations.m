% launches and records the free-running simulations 

%% preamble

clear all
close all
addpath('../Optimization scripts') % to allow access to simRLonRats, etc.

%% simulation specifications

subjects = 27 : 50;
n_reps = 100; % number of simulations per rat

nbAction = 3;
simulation = true;
model = 2;
idxAlpha = 1;
idxBeta = 2;
idxAlpha2 = 3;
Qinit=0;

FullData = load('../../Experiment/raw data');

%% loading behavioral data and filter parameters

for dose = 0 : 3
    
    condition = ['Flu' num2str(dose)];
    data = FullData.(condition);
    
    addpath(genpath(['../Optimization results/flu' num2str(dose)]))
    
    load(['Best parameters on flu' num2str(dose) '.mat'])
    Params = Best(:, 1 : 3);
    
    
    %% LAUNCH SIMULATIONS WITH OPTIMIZED PARAMS
    
    for rat = 1 : length(subjects)
        rat_id = subjects(rat);
        
        rat_data = data(data(:,1) == rat_id, :);
        n_trials = length(rat_data(:,1));
        
        %% get parameters for this rat
        alpha = Params(rat,1);
        alpha2 = Params(rat,3);
        beta = Params(rat,2);
        
        %% launch simulations
        Qvalues = zeros(n_trials + 1, nbAction, n_reps); % because there are Qvalues before the first trial and after the last trial too
        choices = zeros(n_trials, n_reps);
        rewards = zeros(n_trials, n_reps);
        probas = zeros(n_trials, nbAction, n_reps);
        
        for i = 1 : n_reps
            [likelihood, Y, Qval, proba, RPE, RWD] = simRLonRats(rat_data, beta, alpha, alpha2, Qinit, simulation);

            Qvalues(:,:,i) = Qval;
            probas(:,:,i) = proba;
            choices(:,i) = Y;
            rewards(:,i) = RWD;
        end
        
        filename = [condition 'Rat' num2str(rat_id) '_' num2str(n_reps) 'simulations'];
        save(filename, 'rat_data', 'Qvalues', 'probas', 'choices', 'rewards');
    end
    rmpath(genpath(['../Optimization results/flu' num2str(dose)])) % we only remove now to ensure that this script has access to simRLonRatsLU2bis
end

rmpath('../Optimization scripts')