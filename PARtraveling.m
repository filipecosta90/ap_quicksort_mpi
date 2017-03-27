function [D, Tdist_SA, Tdist_MC, Tdist_multiSA, function_evaluations_SA, function_evaluations_MC, function_evaluations_multiSA, distinct_routes_SA, distinct_routes_MC, distinct_routes_multiSA, route_dist_evolution_SA, route_dist_evolution_MC, route_dist_evolution_multiSA, stability_evolution_SA, stability_evolution_MC, stability_evolution_multiSA, accepted_uphill_moves_SA,accepted_uphill_moves_multiSA, uphill_location_x_SA , uphill_location_x_multiSA, uphill_location_y_SA, uphill_location_y_multiSA, time_SA, time_MC, time_multiSA, temperature_evolution_multiSA, temperature_permutations_multiSA] = PARtraveling(n,REPS)

% This is a simulation of a parallel execution on p processors of the code
% traveling which uses simulated annealing to find the shortest route to go
% through each one of n towns
% Each process executes the same code with different random
% numbers and, in general, will find different answers with different
% costs. The parallel solution is thus the answer with smaller cost.

% generates the position of each town in a square of side 10...
x=10*rand(1,n); y=10*rand(1,n); 
D=zeros(n);
Tdist_SA = zeros(REPS,1);
Tdist_MC = zeros(REPS,1);

% ... and computes the distances between them 
for i=1:n
    for j=1:n
        D(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
    end
end

max_Temperature = max(max(D));
initial_Temperature = max_Temperature / log(2);
% Run with simulated annealing

for p=1:REPS
    tStart = tic; 
    [Tdist_SA(p),route,function_evaluations_SA(p),distinct_routes_SA(p), accepted_uphill_moves_SA(p),uphill_location_x_SA{p},uphill_location_y_SA{p}, route_dist_evolution_SA{p}, stability_evolution_SA{p}]=traveling_SA(D,initial_Temperature);
    time_SA(p) = toc(tStart);
end


% Run without simulated annealing  
for p=1:REPS
    tStart = tic; 
    [Tdist_MC(p),route2,function_evaluations_MC(p), distinct_routes_MC(p), route_dist_evolution_MC{p}, stability_evolution_MC{p}]=traveling_MC(D);
    time_MC(p) = toc(tStart);
end

for p=1:REPS
    tStart = tic; 
    [Tdist_multiSA(p),route,function_evaluations_multiSA(p),distinct_routes_multiSA(p), accepted_uphill_moves_multiSA(p),uphill_location_x_multiSA{p},uphill_location_y_multiSA{p}, route_dist_evolution_multiSA{p}, stability_evolution_multiSA{p}, temperature_evolution_multiSA{p}, temperature_permutations_multiSA{p}]=traveling_multiSA(D,initial_Temperature);
    time_multiSA(p) = toc(tStart);
end


end
