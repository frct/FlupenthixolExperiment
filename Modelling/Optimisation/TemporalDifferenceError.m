function [ TDerror, values ] = TemporalDifferenceError(reward, action, values, alpha, alpha2, Qinit )

% reward = reward value obtained by the agent
% action = action that was performed
% values = action values in the previous state
% alpha = learning rate
% alpha2 = forgetting rate for non chosen actions
% Qinit = initial Qvalues

nbAction = length(values);
TDerror = zeros(1,nbAction);
TDerror(action) = reward - values(action);
values(action) = values(action) + alpha * TDerror(action);

if (nbAction > 1),
    for iii=0:(nbAction-2), % we update the values of non-chosen actions
        TDerror(mod(action+iii,nbAction)+1) = Qinit - values(mod(action+iii,nbAction)+1);
        values(mod(action+iii,nbAction)+1) = values(mod(action+iii,nbAction)+1) + alpha2 * TDerror(mod(action+iii,nbAction)+1);
    end;
end;
end

