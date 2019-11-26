% I want a function that goes through S1-12 and S13-24 and eliminates
% blocks with shortened lengths

function A=remove_unfinished_blocks(A)

lines=lines_to_be_deleted(A);
A(lines,:)=[];