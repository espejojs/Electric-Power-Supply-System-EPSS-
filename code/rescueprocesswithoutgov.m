function [supply,demand,peopleaffected] = rescueprocesswithoutgov(speed1,speed2,efficiency1,efficiency2,m,num)

[P30,P31,P32,P37,P39] = Failureprob(m);
[level30] = postperformance(P30);
[level31] = postperformance(P31);
[level32] = postperformance(P32);
[level37] = postperformance(P37);
[level39] = postperformance(P39);


[immediatecapacity] = functionality(P30,P31,P32,P37,P39);

avecon=1927.14/(24*365*1000);

% the distance from each substation to the rescue center
dist30=60.8126;
dist31=129.0198;
dist32=81.9339;
dist37=70.6243;
dist39=48.8142;

% generate the random numbers for every parameter
speed=unifrnd(speed1,speed2,num,1);
efficiency=unifrnd(efficiency1,efficiency2,num,1);

% the main loop for the totally 480 hours
x=1:1:24*20;
for i=1:num
        for j=1:24*20
            if m==7
                if j<=0.24/0.001
               demand(j)=3380*(0.76+0.001*j);
                else 
               demand(j)=3380;
                end
            elseif m==8
                if j<=0.27/0.000703125
               demand(j)=3380*(0.73+0.000703125*j);
                else
               demand(j)=3380;  
                end
            else
                if j<=0.3/0.000625
               demand(j)=3380*(0.7+0.000625*j);
                else 
               demand(j)=3380;  
                end
            end
            
                    
% predefine the travelling and repairing time                 
t31t=4+dist31/speed(i);
t31r=t31t+(1-level31)/efficiency(i);
t37t=t31r+172.7538/speed(i);
t37r=t37t+(1-level37)/efficiency(i);
t37to30t=t37r+20.1957/speed(i);
t37to30r=t37to30t+(1-level30)/efficiency(i);
t30to32t=t37to30r+116.6296/speed(i);
t30to32r=t30to32t+(1-level32)/efficiency(i);
t32to39t=t30to32r+72.2979/speed(i);
t32to39r=t32to39t+(1-level39)/efficiency(i);

% track the evolution of the status of people out of power and the delivered supply 
if x(j)<=t31t
        supply(j)=immediatecapacity;
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t31r
        supply(j)=immediatecapacity+646*(x(j)-t31t)*efficiency(i);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t37t
        supply(j)=immediatecapacity+646*(1-level31);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t37r
        supply(j)=immediatecapacity+646*(1-level31)+564*(x(j)-t37t)*efficiency(i);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t37to30t
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t37to30r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(x(j)-t37to30t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t30to32t
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t30to32r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725*(x(j)-t30to32t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t32to39t
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725*(1-level32);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t32to39r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725*(1-level32)+1100*(x(j)-t32to39t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
else
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725*(1-level32)+1100*(1-level39);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
end

end

end
end








