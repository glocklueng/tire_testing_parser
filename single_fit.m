clearvars a F_lat F_n

%remove bad entries
delete_index = find(isnan(ET));
SA = removerows(SA,delete_index);
FY = removerows(FY,delete_index);
FZ = removerows(FZ,delete_index);

%filter data so that only steady state normal force is used
window_rad = 20;
slope_thresh = 200;
normal_thresh = -100;
iter_low = 1;
iter_high = iter_low+2*window_rad;
delta = zeros(length(SA)-(window_rad*2),1);
a = [];
F_n = [];
F_lat = [];
for i = 1:length(delta)
    delta(i) = abs(FZ(iter_low)-FZ(iter_high));
    %the filter, if small slope and non zero normal
    if and(delta(i)<slope_thresh,FZ(i+window_rad)<normal_thresh);
        a = [a;SA(i+window_rad)*(pi/180)];
        F_n = [F_n;FZ(i+window_rad)];
        F_lat = [F_lat;FY(i+window_rad)];
    end
    iter_low = iter_low+1;
    iter_high = iter_high+1;
end

%parse the data into normal forces



%initial conditions
x0 = [15,1.2,2.4,0]; %B,C,D,E
eqn = @(x)magic_formula_error(x,a,F_n,F_lat);

options = optimoptions(@lsqnonlin);
options.MaxFunEvals = 10000;
options.MaxIter = 10000;
[results] = lsqnonlin(eqn,x0,[],[],options);


