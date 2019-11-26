function [ Y, proba ] = ValueBasedDecision(values, beta)

nbA = length(values); % nb actions

combVal = min(beta * values, ones(1,nbA) * 700); % Qvalues times beta
proba = exp(combVal) / sum(exp(combVal)); % softmax distribution
Y = drand01(proba); % sampling an action from the distribution

proba = max(proba,ones(1,nbA)*1e-100);
end