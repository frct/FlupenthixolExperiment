function test=same_block(line1,line2)
% self-explanatory, isn't it?

if line1(2) == line2(2) % if on the same session
    if line1(3)==line2(3) % if on the same block
        test = true;
    else
        test = false;
    end
else
    test = false;
end