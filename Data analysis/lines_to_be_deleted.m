function lines=lines_to_be_deleted(varargin)

%returns vector of indices of trials belonging to unfinished blocks for
%presumably, removal in remove_unfinished_blocks
%may be useful to implement if want to count them in anyway in order to
%assign correct subblock #

if nargin == 1
    A = varargin{1};
    minimum_length = 24;
elseif nargin == 2
    A = varargin{1};
    minimum_length = varargin{2};
else
    error('number of inputs to lines_to_be_deleted is wrong')
end

% if limit > 24
%     error('number of limit trials higher than 24')
% end

lines=[];
[x,~]=size(A);
i=1;

while i<=x % !!!! previous version was i < x 
    
    block=[i];
    
    while i+1<=x && A(i,1) == A(i+1,1) && A(i,3)==A(i+1,3) && A(i,2) == A(i+1,2)
        block = [block i+1];
        i=i+1;
    end
    
    if length(block) < minimum_length
        lines = [lines block];
    elseif length(block)>24
        display('Error in block length')
    end
    
    block=[];
    i=i+1;

end

    