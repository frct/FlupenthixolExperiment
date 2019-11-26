function sem = nansem(A)

[~,b] = size(A);
sem = zeros(1,b);

N = sum(~isnan(A));

sem = nanstd(A) ./ sqrt(N);