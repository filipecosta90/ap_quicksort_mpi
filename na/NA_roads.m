%California Road Network's Edges (Edge ID, Start Node ID, End Node ID, L2 Distance)
filename = 'cal.cedge.txt';
E = readtable(filename);
E_start_node_id = E.Var2 + 1;
E_end_node_id = E.Var3 + 1;
E_distance = E.Var4;

%California Road Network's Nodes (Node ID, Longitude, Latitude)
filename = 'cal.cnode.txt';
N = readtable(filename);

number_cities = max(N.Var1)+1;
number_edges = length(E.Var1);
D = sparse(number_cities,number_cities); %Inf(number_cities,'single');

for e_num=1:number_edges 
    start_city = E_start_node_id(e_num);
    end_city = E_end_node_id(e_num);
    D(start_city,end_city) = E_distance(e_num);
end
