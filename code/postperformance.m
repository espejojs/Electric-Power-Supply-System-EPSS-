function [level] = postperformance(p) % determine the relationship between the failure probability and the performance level

if p<0.25          % the case that failure probability is smaller than 0.25
    level=1-p;

elseif p<0.5       % the case that failure probability is larger than 0.25 but smaller than 0.5
    level=0.5-p;
else               % the case that failure probability is larger than 0.5
    level=0;

end

end





