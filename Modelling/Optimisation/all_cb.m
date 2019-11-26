function M = all_cb (n)

% the aim of this function is to return all the combinations of indices of
% my_grid which need to be tested
%eg my_grid is a n * 3 matrix (with n the number of parameters and 3 the
%number of intialization points for each parameter
% then M is a 3^n * n matrix such as:
%   | 1 1 1 ...1 1 |
%   | 1 1 1 ...1 2 |
%   | 1 1 1 ...1 3 |
%   | 1 1 1 ...2 1 |
% etc

nx = 3^n;
ny = n;

M = zeros(nx, ny);

for idy = 1 : ny % sweeping through columns
    idx = 1;
    for n_reps = 1 : 3 ^ (idy - 1) % each column is made of repeated sequences of groups of 1's 2's 3's. The first colums containts only one repetition, the next 3, the next 9, etc...
        for a = 1 : 3
            for b = 1 : 3 ^(n - idy); % size of this repetition
                M(idx, idy) = a;
                idx = idx + 1;
            end
        end
    end
end