% parallel optimization for the different rats of the forgetting model, aka
% model 2

clear all
close all

load('../../Experiment/raw data.mat');
data = Flu0; % or Flu1, Flu2, Flu3

subjects = 27 : 50; % optimization was carried out on all subjects including rat 35
n_subjects = length(subjects);
model = 2; % 1 for simple QL, 2 for forgetting QL

%% parallelization

% nWorkers = n_subjects;
% myCluster = parcluster('local');
% myCluster.NumWorkers = nWorkers;
% poolobj = parpool(myCluster,nWorkers);
% 
% parfor sub_id = 1:length(subjects)
%     LogLikelihoodMaximisation(2, data, subjects(sub_id), subjects(sub_id))
% end
% 
% delete(poolobj)

%% alternatively, if one does not wish or is unable to parallelize, or wants to optimize parameters of a subset of the population

LogLikelihoodMaximisation(model, data, subjects(1), subjects(end))