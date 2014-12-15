function [P30,P31,P32,P37,P39] = Failureprob(m) % quantify the failure probabilities for all the generation substations

% calculate the epicentral distances 
R30=sqrt(67^2+225);  
R31=sqrt(95^2+225);
R32=sqrt(52^2+225);
R37=sqrt(84^2+225);
R39=sqrt(28^2+225);

% calculate the input peak ground accelerations for each substation
PGA30 = 10^(3.79+0.298*(m-6)-0.0536*(m-6)^2-log10(R30)-0.00135*R30)/1000;
PGA31 = 10^(3.79+0.298*(m-6)-0.0536*(m-6)^2-log10(R31)-0.00135*R31)/1000;
PGA32 = 10^(3.79+0.298*(m-6)-0.0536*(m-6)^2-log10(R32)-0.00135*R32)/1000;
PGA37 = 10^(3.79+0.298*(m-6)-0.0536*(m-6)^2-log10(R37)-0.00135*R37)/1000;
PGA39 = 10^(3.79+0.298*(m-6)-0.0536*(m-6)^2-log10(R39)-0.00135*R39)/1000;

% calculate the failure probability according to the fragility data
P30 = logncdf(PGA30,-1.61,0.35);
P31 = logncdf(PGA31,-1.61,0.35);
P32 = logncdf(PGA32,-1.61,0.35);
P37 = logncdf(PGA37,-1.61,0.35);
P39 = logncdf(PGA39,-1.61,0.35);
end
