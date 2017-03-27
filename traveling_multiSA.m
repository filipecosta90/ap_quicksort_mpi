function [Tdist,route, function_evaluations, distinct_routes, accepted_uphill_moves,uphill_location_x,uphill_location_y,route_dist_evolution,stability_evolution, temperature_evolution, temperature_permutations]=traveling_multiSA(Distances_matrix,Temperature)
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
while i < 100           % stop if no changes for 100 iterations
    delta = 0;
    delta_temp = Temperature-T;
    norm_temp = delta_temp / Temperature;
    number_permutations = ceil( log2((norm_temp)/(norm_temp^2) ) * log2( n ) );
    if (number_permutations == NaN )
        number_permutations = 1;
    end

    temp_route = route;
    for j=1:number_permutations
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
    delta = delta + Distances_matrix(temp_route(previous),temp_route(next1))+ Distances_matrix(temp_route(next1),temp_route(c)) + Distances_matrix(temp_route(c),temp_route(next2))-Distances_matrix(temp_route(previous),temp_route(c))-Distances_matrix(temp_route(c),temp_route(next1))-Distances_matrix(temp_route(next1),temp_route(next2)); 
    temp=temp_route(c); temp_route(c)=temp_route(next1); temp_route(next1)=temp;                 
  end
  % accept or discard change to route 
  if delta<0 | (exp(-delta/T)>= rand) 
        if delta > 0 
            accepted_uphill_moves = accepted_uphill_moves + 1;
            uphill_location_x(accepted_uphill_moves) = function_evaluations;
            uphill_location_y(accepted_uphill_moves) = Tdist;
        end
        % swap order of route(c) and route(c+1) in route  
        route = temp_route;                 
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
    temperature_permutations(function_evaluations) = number_permutations;
    temperature_evolution(function_evaluations) = T;
    function_evaluations = function_evaluations + 1;
end

end



