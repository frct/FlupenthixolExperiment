function [loglikelihood, Y, Qvalues, proba, RPE, RWD] = simRLonRats(data, beta, alpha, alpha2, Qinit, simulation)

% This function essentially has two different purposes depending on whether
% the input variable simulation is true or false.
% If false, then it constrains the chosen model with its given parameters 
% to the history of choices actually made by the animal and then computes
% the hypothetical Q-values and resulting choice probabilities for each 
% trial which can in turn give us the log-likelihood of a model and 
% parameter set, which is particularly interesting when performing model 
% optimisation.
% If true, this function generates random simulations based on the model
% and its parameters leaving it to generate its own unique history and
% Q-value computations.

n_trials = size(data,1);
n_actions = 3;
Y = zeros(n_trials,1); % choices made by the model
RWD = zeros(n_trials,1); % rewards obtained by the model
Qvalues = zeros(n_trials+1, n_actions); % there are n_trials + 1 instances of Q-values for 3 different possible levers
Qvalues(1,:) = Qinit;
proba = zeros(n_trials,n_actions);
RPE = zeros(n_trials+1,n_actions);
totalpgd=zeros(n_trials,1);
probaRwd = [ 7/8 1/16 ; 5/8 3/16 ]; % reward probability for the target lever (1st column) or either of the remaining two levers (2nd column) in low (1st line) and high uncertainty (2nd line)

%% get correct parameters for different metalearning models

for t = 1 : n_trials
    
    [Y(t), proba(t,:)] = ValueBasedDecision(Qvalues(t,:), beta); % Y is a random sample (ie simulated action) from the softmax distribution proba
    
    bestaction = data(t,4);
    
    if simulation
        %% either free running simulation
        action = Y(t);
        risk = data(t,6) + 1; % low risk is line 1 and high risk line 2 in probaRwd
        
        % we must also simulate rewards using the experimental
        % reward contingencies
        
        reward = (action == bestaction) * (drand01([(1-probaRwd(risk,1)) probaRwd(risk,1)])-1) + (action ~= bestaction) * (drand01([(1-probaRwd(risk,2)) probaRwd(risk,2)])-1);
    else
        %% or a simulation constrained to the subject's history, as is the case in parameter optimization
        action = data(t,5);
        reward = data(t,7);
    end
    
    RWD(t) = reward;
    totalpgd(t) = log(proba(t,action));
    [ RPE(t+1,:), Qvalues(t+1,:) ] = TemporalDifferenceError(reward, action, Qvalues(t,:), alpha, alpha2, Qinit );
    
    if t < n_trials
        if data(t,2) ~= data(t+1,2) % if we've changed sessions, we reset Qvalues
            RPE(t+1,:) = zeros(1,3);
            Qvalues(t+1,:) = Qinit;
        end
    end
    
end

loglikelihood = sum(totalpgd);

RPE(1,:)=[];

if ~simulation
    clear Y;
    clear Qvalues;
    clear proba;
    clear RPE;
    clear RWD;
end

end