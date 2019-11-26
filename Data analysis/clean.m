function A=clean(data, opt)

%this function takes in data as presented in text files and removes
%unnecessary columns and optionnally, unfinished blocks

data(:, [4 9 10 11 12])=[]; %getting rid of columns I don't need eg signal, start time, latency satiété and dose 

switch opt
    case 'unfinished blocks'
        A=remove_unfinished_blocks(data);
        
    otherwise
        A=data;
        
end