function [Tdist,route,function_evaluations,distinct_routes, route_dist_evolution,stability_evolution ]=traveling_MC(Distances_matrix)
% A simple Monte-Carlo algorithm for the Traveling Salesman Problem. Given  
% n points by its (x,y) coordinates, D(i,j) holds the distance between the 
% 2 points (x(i),y(i)) and (x(j),y(j)). The code tries to find the shortest  
% route that starts at one of the points ("routes"), goes once through 
% everyone of the others and returns to the starting point. It starts with
% an initial random route (a random permutation of the first n integer 
% numbers), and them shortens the total distance through successive swaps 
% in the order of 2 neighbouring routes
function_evaluations = 1;
n=length(Distances_matrix);
% FIRST tentative route 
route=randperm(n); % a random permutation of the first n integers 
Tdist=Distances_matrix(route(n),route(1));
for i=1:n-1                               % initial length
    Tdist=Tdist+Distances_matrix(route(i),route(i+1));     % of route
end
route_dist_evolution(function_evaluations) = Tdist;
stability_evolution(function_evaluations) = 0;
distinct_routes = 0;



i=0;
while i < 100           % stop if no changes occur for LIM=100 iterations
    c=ceil(n*rand);     % randomly chooses a route (at position c in route)
    if c==1  
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
    if delta<0 
        temp=route(c); route(c)=route(next1); route(next1)=temp; % swap order of route(c) and route(c+1) in route                 
        Tdist=Tdist+delta;   
        i=0;
        distinct_routes = distinct_routes + 1;
    else
        i=i+1;
    end
    stability_evolution(function_evaluations) = i;
    route_dist_evolution(function_evaluations) = Tdist;
    function_evaluations = function_evaluations +1;
end
end




