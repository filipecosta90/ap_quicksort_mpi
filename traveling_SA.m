function [Tdist,route, function_evaluations, distinct_routes, accepted_uphill_moves,uphill_location_x,uphill_location_y,route_dist_evolution,stability_evolution]=traveling_SA(Distances_matrix,Temperature)
% uses simulated annealing to solve the Traveling Salesman Problem: given n
% routes and the distances between any two of them, finds the shortest route 
% that starts at one of the routes, goes once through everyone of the others 
% and returns to the first one
function_evaluations = 1;
accepted_uphill_moves = 0;
n=length(Distances_matrix);
% FIRST tentative route 
route=randperm(n); % a random permutation of the first n integers 
Tdist=Distances_matrix(route(n),route(1));
for i=1:n-1                               % length of 
    Tdist=Tdist+Distances_matrix(route(i),route(i+1));     % initial route
end
route_dist_evolution(function_evaluations) = Tdist;
stability_evolution(function_evaluations) = 0;
distinct_routes = 0;

T=Temperature;     % initial temperature
i=0;
while i < 100           % stop if no changes for 128 iterations
    c=ceil(n*rand);     % randomly chooses a route (at position c in route)
    if c==1             % and swaps its position with the next one
        previous=n; next1=2; next2=3;
    elseif c==n-1
        previous=n-2; next1=n; next2=1;
    elseif c==n
        previous=n-1; next1=1; next2=2;
    else
        previous=c-1; next1=c+1; next2=c+2;
    end
    % delta=increment in length of route
    delta = Distances_matrix(route(previous),route(next1))+ Distances_matrix(route(next1),route(c)) + Distances_matrix(route(c),route(next2))-Distances_matrix(route(previous),route(c))-Distances_matrix(route(c),route(next1))-Distances_matrix(route(next1),route(next2)); 
    % accept or discard change to route 
    if delta<0 | (exp(-delta/T)>= rand) 
        if delta > 0 
            accepted_uphill_moves = accepted_uphill_moves + 1;
            uphill_location_x(accepted_uphill_moves) = function_evaluations;
            uphill_location_y(accepted_uphill_moves) = Tdist;
        end
        % swap order of route(c) and route(c+1) in route  
        temp=route(c); route(c)=route(next1); route(next1)=temp;                 
        Tdist=Tdist+delta; 
        if delta~=0
            i=0;
        end
        distinct_routes = distinct_routes + 1;
    else
        i=i+1;
    end
    T=0.999*T;
    stability_evolution(function_evaluations) = i;
    route_dist_evolution(function_evaluations) = Tdist;
    function_evaluations = function_evaluations +1;
end

end



