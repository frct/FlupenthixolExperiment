% applies a friedman Anova test on the three parameters of the model as
% well as the post hoc t-tests

clear all
close all

n_parameters = 3;
var = {'alpha', 'beta', 'alpha2'};
grey = [130/255 130/255 130/255];

rats = [27 : 35 37 : 50]; % excluding rat 35 who only did 24 trials with 0.3mg/kg flupenthixol
n_rats = length(rats);
rat_ids = rats - 26;

doses = 0 : 3;
n_doses = length(doses);

parameter_values = zeros(n_rats, n_parameters, n_doses);

alphas = zeros(n_rats, n_doses);
betas = zeros(n_rats, n_doses);
alpha2s = zeros(n_rats, n_doses);

for dose = doses
    addpath(['flu' num2str(dose)])
    load (['Best parameters on flu' num2str(dose) '.mat'])
    parameter_values(:,:,dose + 1) = Best(rat_ids,1:n_parameters);
    alphas(:,dose + 1) = Best(rat_ids,1);
    betas(:,dose + 1) = Best(rat_ids,2);
    alpha2s(:,dose + 1) = Best(rat_ids,3);
    rmpath(['flu' num2str(dose)])
end

for v = 1 : n_parameters
    [p.(var{v}), tbl.(var{v}), stats.(var{v})] = friedman(reshape(parameter_values(:,v,:),n_rats,4),1,'on');
    c.(var{v}) = multcompare(stats.(var{v}), 'Ctype', 'bonferroni');
end

save('Friedman Anova test',  'p', 'tbl', 'stats', 'c')