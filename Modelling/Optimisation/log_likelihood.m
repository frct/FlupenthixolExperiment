function LL = log_likelihood(vectParam, model, data)

%log_likelihood returns the negative log-likelihood of the model with
%parameter values given by vectParam. It essentially calls simRLonRatsLU2
%with the appropriate parameter values.
%It can be used to find parameters through minimization of this negative LL

%% fixed parameters

Qinit = 0;
simulation = false;

%% model parameters
alpha = vectParam(1);
beta = vectParam(2);

switch (model)
    
    case 1    
        alpha2 = 0;        
        
     case 2
        alpha2 = vectParam(3);
        
end

likelihood = simRLonRats(data, beta, alpha, alpha2, Qinit, simulation );
LL = -1 * likelihood;

end