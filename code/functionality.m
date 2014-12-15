function [immediatecapacity] = functionality(P30,P31,P32,P37,P39) % quantify the post-earthquake performance level

% determination the performance of each single substation
[level30] = postperformance(P30);
[level31] = postperformance(P31);
[level32] = postperformance(P32);
[level37] = postperformance(P37);
[level39] = postperformance(P39);

% the sum of all the single substations
immediatecapacity=level30*1040+level31*646+level32*725+level37*564+level39*1100;

end




