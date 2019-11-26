function LogLikelihoodMaximisation(model, data, debut, fin )

% this function performs an optimization of parameters of model minimizing
% the negative log likelihood with a gradient descent method (fmincon) 
% initialized at a series of starting points


switch (model)
    
    case 1 % basic QL
        mygrid = [0.1 0.5 0.9; 1 5 20];  % alpha, beta
        maxParam = [1 Inf];
        minParam = [0 0];
        
    case 2 % QL + forgetting
        mygrid = [0.1 0.5 0.9; 2 5 10; 0.1 0.5 0.9]; %alpha, beta, alpha2
        maxParam = [1 Inf 1];
        minParam = [0 0 0];
        
end

nbparam = length(mygrid(:,1));
options = optimset('Algorithm','interior-point');
fmcResults = zeros(3^nbparam,nbparam+1);
gradient = zeros(3^nbparam,nbparam);
hessian = zeros(3^nbparam,nbparam,nbparam);


for nsub = debut : fin
    ratid = ['Rat number ' num2str(nsub)]
    rat_data = data(data(:,1) == nsub, :);
    

%     % Toutes les sessions ont 6 blocs sauf les 4 dernieres qui en ont 12
%     S13_24(S13_24(:,3)>12,:) = []; % La derniere session a + que 12 blocs
%     donnees = [donnees ; S13_24(S13_24(:,1)==nsub,1:8)];

    
    % reorganize columns of donnees for the model fitting functions
    % 1 numRat
    % 2 seance (entrainement 1 à 12 flupenthixol 1 à 8)
    % 3 bloc (entrainement 1 à 6 ou 1 à 18 flupenthixol 1 à 12)
    % 4 zero
    % 5 best choice (levier 1 2 ou 3)
    % 6 choice (levier 1 2 ou 3)
    % 7 risque (0 BR 1 HR)
    % 8 reward (0 ou 1)

    
    M = all_cb(nbparam); % all the combinations of indices of mygrid that need to be tested
    vectParam = zeros(1, nbparam);
    
    for niter = 1 : length(M(:,1));
        iteration = [ 'iteration ' num2str(niter) ' out of ' num2str(3^nbparam)]
        for i = 1 : nbparam
            vectParam(i) = mygrid(i, M(niter,i)); % get current combination of initialization values
        end
                
        [x, fval, ~, ~, ~, grad, hess] = fmincon(@(x) log_likelihood(x, model, rat_data), vectParam, [], [], [], [], minParam(1:nbparam), maxParam(1:nbparam), [], options);
        fmcResults(niter,:) = [x fval];
        gradient(niter,:) = grad';
        hessian(niter,:,:) = hess;
             
    end
    save(['Rat' num2str(nsub) '_fmcResults'], 'fmcResults','gradient','hessian')
end

end
