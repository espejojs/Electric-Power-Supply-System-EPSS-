function [supply,demand,peopleaffected] = rescurprocess(speed1,speed2,toughnessgrid1,toughnessgrid2,toughnessgov1,toughnessgov2,efficiency1,efficiency2,m,num,thresval)

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
toughnessgrid=unifrnd(toughnessgrid1,toughnessgrid2,num,1);
toughnessgov=unifrnd(toughnessgov1,toughnessgov2,num,1);
efficiency=unifrnd(efficiency1,efficiency2,num,1);

% the main loop for the totally 480 hours
x=1:1:24*20;
    for i=1:num
        for j=1:24*20
% quantify the recovery behavior for the demand and initial number of people out of power
            if m==7
            [immediategrossnumber] = numberoutofpower7(immediatecapacity);
                if j<=0.24/0.001
               demand(j)=3380*(0.76+0.001*j);
                else 
               demand(j)=3380;
                end
            elseif m==8
            [immediategrossnumber] = numberoutofpower8(immediatecapacity);
                if j<=0.27/0.000703125
               demand(j)=3380*(0.73+0.000703125*j);
                else
               demand(j)=3380;  
                end
            else
            [immediategrossnumber] = numberoutofpower9(immediatecapacity);
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

t37to39t=t37r+65.1863/speed(i);
t37to39r=t37to39t+(1-level39)/efficiency(i);
t39to32t=t37to39r+72.2979/speed(i);
t39to32r=t39to32t+(1-level32)/efficiency(i);
t32to30t=t39to32r+116.6296/speed(i);
t32to30r=t32to30t+(1-level30)/efficiency(i);


t37to30t=t37r+20.1957/speed(i);
t37to30r=t37to30t+(1-level30)/efficiency(i);


t30to32t=t37to30r+116.6296/speed(i);
t30to32r=t30to32t+(1-level32)/efficiency(i);


t32to39t=t30to32r+72.2979/speed(i);

t32to39r=t32to39t+(1-level39)/efficiency(i);


t30to39t=t37to30r+45.5833/speed(i);
t30to39r=t30to39t+(1-level39)/efficiency(i);
t39to32t=t30to39r+72.2979/speed(i);
t39to32r=t39to32t+(1-level32)/efficiency(i);


if t37t+(1-level37)/efficiency(i)>30
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
else
       if peopleaffected(30)<thresval*immediategrossnumber            % examine whether the threshold value can be reached  
          toughnessgov(i)=toughnessgov(i)+0.1;
          if toughnessgov(i)>toughnessgrid(i)
             if x(j)<=t37to39t
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t37to39r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(x(j)-t37to39t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t39to32t
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t39to32r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(x(j)-t39to32t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t32to30t
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(1-level32);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t32to30r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(1-level32)+1040*(x(j)-t32to30t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
             else
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(1-level32)+1040*(1-level30);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
             end


             else
             if x(j)<=t37to30t
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
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725* (1-level32);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
            elseif x(j)<=t32to39r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725* (1-level32)+1100*(x(j)-t32to39t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
            else
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725* (1-level32)+1100*(1-level39);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
            end
end

else
             if x(j)<=t37to30t
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
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725* (1-level32);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
            elseif x(j)<=t32to39r
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725* (1-level32)+1100*(x(j)-t32to39t)*efficiency(i);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
            else
       supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+725* (1-level32)+1100*(1-level39);
       peopleaffected(j)=(demand(j)-supply(j))/avecon;
            end
end
end


elseif t37r+20.1957/speed(i)>30
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
elseif x(j)<=t37to30t;
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
else
        if peopleaffected(30)<thresval*immediategrossnumber           % examine whether the threshold value can be reached 
          toughnessgov(i)=toughnessgov(i)+0.1;
          if toughnessgov(i)>toughnessgrid(i)
             if x(j)<=t30to39t
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t30to39r
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(x(j)-t30to39t)*efficiency(i);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t39to32t
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t39to32r
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(x(j)-t39to32t)*efficiency(i);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t32to30t
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(1-level32);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t32to30r
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(1-level32)+1040*(x(j)-t32to30t)*efficiency(i);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
             else
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1100*(1-level39)+725*(1-level32)+1040*(1-level30);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
             end

else
             if x(j)<=t37to30r
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

else
             if x(j)<=t37to30r
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





else
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
elseif x(j)<=t37to30t;
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
elseif x(j)<=t37to30r
        supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(x(j)-t37to30t)*efficiency(i);
        peopleaffected(j)=(demand(j)-supply(j))/avecon;
else
        if peopleaffected(30)<thresval*immediategrossnumber           % examine whether the threshold value can be reached 
          toughnessgov(i)=toughnessgov(i)+0.1;
          if toughnessgov(i)>toughnessgrid(i)
             if x(j)<=t30to39t
          supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30);
          peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t30to39r
          supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+1100*(x(j)-t30to39t)*efficiency(i);
          peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t39to32t
          supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+1100*(1-level39);
          peopleaffected(j)=(demand(j)-supply(j))/avecon;
             elseif x(j)<=t39to32r
          supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+1100*(1-level39)+725*(x(j)-t39to32t)*efficiency(i);
          peopleaffected(j)=(demand(j)-supply(j))/avecon;
             else
          supply(j)=immediatecapacity+646*(1-level31)+564*(1-level37)+1040*(1-level30)+1100*(1-level39)+725*(1-level32);
          peopleaffected(j)=(demand(j)-supply(j))/avecon;
end

else 
          if x(j)<=t30to32r
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
else
          if x(j)<=t30to32r
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
end
end



















