function [immediategrossnumber7] = numberoutofpower7(immediatesupply) % calculate the number of the immediate people out of power

demand=3380*0.76; % immediate post-earthquake power demand

immediategrossnumber7=(demand-immediatesupply)/(1927.14/(24*365*1000)); % quantify the number of people out of power 

end



