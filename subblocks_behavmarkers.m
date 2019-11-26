function BlockMeasures = subblocks_behavmarkers(data)

% a function that given data, divides it into subblocks of 4 trials and
% averages the different behavioural measures between blocks

% input data is of the form:
%    1      2         3         4          5         6         7       
%  rat | session |  block  |  target  |  choice  |  risk  |  reward

% output: BlockMeasures is a structure variable containing average performance,
% win-shift and lose-shift

%% Initialize ind, the list of indicators we are measuring

measure_types = {'perf', 'win', 'lose'};
n_types = length(measure_types);
binSize = 4;
n_trials = length(data(:,1));
n_bins = 24 / binSize; % the number of trials in a block is 24

for j = 1 : n_types
    subblock.(measure_types{j}) = NaN * ones(n_trials, n_bins);
end

%% looping through trials

for t = 1 : n_trials
    n_inblock = my_modulo(t,24);
    subblock_id = 1;
    while subblock_id * binSize < n_inblock
        subblock_id = subblock_id +1;
    end
    
    for j = 1 : n_types
        
        switch measure_types{j}
            
            case 'perf'
                if data(t, 4) == data(t, 5)
                    subblock.perf(t, subblock_id) = 1;
                else
                    subblock.perf(t, subblock_id) = 0;
                end
                
            case 'win'
                if t>1 %win-shift doesn't exist for the very first trial
                    if same_block(data(t - 1, :), data(t,:)) && data(t - 1,5) == data(t - 1, 4) && data(t - 1,7) == 1
                        if data(t,5) ~= data(t - 1, 5)
                            subblock.win(t, subblock_id) = 1;
                        else
                            subblock.win(t, subblock_id) = 0;
                        end
                    end
                end
                
            case 'lose'
                if t>1 %lose-shift doesn't exist for the very first trial
                    if data(t - 1, 7) == 0
                        if data(t, 5) ~= data(t - 1, 5)
                            subblock.lose(t, subblock_id) = 1;
                        else
                            subblock.lose(t, subblock_id) = 0;
                        end
                    end
                end
                
        end
        
    end
    
end
    


for j = 1 : n_types
    BlockMeasures.(measure_types{j}) = nanmean(subblock.(measure_types{j}));
end