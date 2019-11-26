% does the within-subject 3 factor anova tests on the block dynamics

%% prologue

clear all
close all
addpath('../../..') % to get swtest

%% introduction and initialization

doses = 0 : 3;
n_doses = length(doses);
rat_ids = [27 : 35 37 : 50]; % rat 36 did not do any of the flu3 trials
n_rats = length(rat_ids);
risks = {'LR', 'HR'};
n_risks = length(risks);
trials = 1 : 6;
n_trials = length(trials);

Performance = zeros(n_rats, n_trials * n_doses * n_risks);
Winshift = zeros(n_rats, n_trials * n_doses * n_risks);
Loseshift = zeros(n_rats, n_trials * n_doses * n_risks);

%% filling in the initialized matrix before the tests

for dose = doses
    
    dose_idyLR = dose * n_trials + 1 : (dose + 1) * n_trials;
    dose_idyHR = n_trials * n_doses + dose_idyLR;
    load(['Flu' num2str(dose) ' block cinetics.mat'])
    
    Performance(:, dose_idyLR) = Perf.LR;
    Performance(:, dose_idyHR) = Perf.HR;
    Winshift(:, dose_idyLR) = Win.LR;
    Winshift(:, dose_idyHR) = Win.HR;
    Loseshift(:, dose_idyLR) = Lose.LR;
    Loseshift(:, dose_idyHR) = Lose.HR;
end

%% test of normality

for t = 1 : 48
    [H_perf(t), pValue_perf(t), ~] = swtest(Performance(:,t), 0.01);
    [H_win(t), pValue_win(t), ~] = swtest(Winshift(:,t), 0.01);
    [H_lose(t), pValue_lose(t), ~] = swtest(Loseshift(:,t), 0.01);
end

%% preparing the tables for the repeated-measures anova tests

rats = table(rat_ids', 'VariableNames', {'subject_number'});

% defining the three within subject factors: risk, trial, and flupenthixol doses

flu = nominal(repmat([0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3]', [2 1]));
risk = nominal(['0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' ...
    '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1' '1']');
trial = nominal(repmat(trials', [n_doses * n_risks 1]));
within = table(flu, risk, trial);

% defining the unique within subject factor dose when analyzing HR and LR
% separately

var1 = nominal([0 0 0 0 0 0 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3]');
var2 = nominal(repmat(trials', [n_doses 1]));
within_separate = table(var1, var2, 'VariableNames', {'flu', 'trial'});

% initializing the two tables
P = [rats array2table(Performance)];
W = [rats array2table(Winshift)];
L = [rats array2table(Loseshift)];


%% within-subject 3 factor (dose, risk and sub-block) Anova

rm_P = fitrm(P, 'Performance1-Performance48~1', 'WithinDesign', within)
tbl = mauchly(rm_P)
ranovatbl_P = ranova(rm_P, 'WithinModel', 'risk*flu*trial')
PostHocP = multcompare(rm_P, 'flu', 'ComparisonType', 'lsd')

%% within-subject 2 factor anova with HR and LR separately

% rm_PLR = fitrm(P, 'Performance1-Performance24~1', 'WithinDesign', within_separate)
% figure()
% plot(rm_PLR)
% ranovatbl_PLR = ranova(rm_PLR, 'WithinModel', 'flu*trial')
% PostHocPLR = multcompare(rm_PLR, 'flu', 'ComparisonType', 'bonferroni')
% PostHocPLR = multcompare(rm_PLR, 'flu', 'By', 'trial', 'ComparisonType', 'bonferroni')
% 
% rm_PHR = fitrm(P, 'Performance25-Performance48~1', 'WithinDesign', within_separate)
% ranovatbl_PHR = ranova(rm_PHR, 'WithinModel', 'flu*trial')
% PostHocPHR = multcompare(rm_PHR, 'flu', 'ComparisonType', 'bonferroni')
% PostHocPHR = multcompare(rm_PHR, 'flu', 'By', 'trial', 'ComparisonType', 'bonferroni')

%% within-subject 3 factor (dose, risk and sub-block) Anova on winshift

rm_W = fitrm(W, 'Winshift1-Winshift48~1', 'WithinDesign', within)
tbl = mauchly(rm_W)
ranovatbl_W = ranova(rm_W, 'WithinModel', 'risk*flu*trial')
PostHocW = multcompare(rm_W, 'flu', 'ComparisonType', 'lsd')

%% within-subject 3 factor (dose, risk and sub-block) Anova on loseshift

rm_L = fitrm(L, 'Loseshift1-Loseshift48~1', 'WithinDesign', within)
tbl = mauchly(rm_L)
ranovatbl_L = ranova(rm_L, 'WithinModel', 'risk*flu*trial')
PostHocL = multcompare(rm_L, 'trial', 'ComparisonType', 'lsd')

%% postface

rmpath('../../..')