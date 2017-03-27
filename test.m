
red = [ 255 0 0 ];
green = [ 0 255 0 ];
blue = [ 0 0 255 ];
%yellow = [ 255 255 0 ];

yellow = [ 0 128 128 ];

magenta = [ 255 0 255 ];
brown = [ 165 42 42 ];
orange = [ 255 165 0 ];

color0 = red/255;
color1 = green/255;
color2 = blue/255;
color3 = yellow/255;
color4 = magenta/255;
color5 = brown/255;
color6 = orange/255;

at=1;

for n_cities = [64,128,256,512,1024]
    [D{at},SA{at},MC{at},multiSA{at},feSA{at}, feMC{at}, multifeSA{at}, droutesSA{at}, droutesMC{at}, multidroutesSA{at}, reSA{at}, reMC{at}, multireSA{at}, seSA{at}, seMC{at}, multiseSA{at}, umSA{at}, multiumSA{at}, ul_x_SA{at}, multiul_x_SA{at}, ul_y_SA{at}, multiul_y_SA{at}, tSA{at}, tMC{at}, multitSA{at}, temperature_evolution_multiSA{at}, temperature_permutations_multiSA{at}]=PARtraveling(n_cities,100);

    formatSpecMC = 'MC %d cities - %.1f (%d distinct routes)';
    formatSpecSA = 'SA %d cities - %.1f ( %d distinct routes, %d uphill moves )';
    formatSpecmultiSA = 'multiSA %d cities - %.1f ( %d distinct routes, %d uphill moves )';
    title_at = 'between the initial MC and SA algorithms, for %d cities';
    title_multiat = 'between the initial MC and SA algorithms and the multiSA algorithm, for %d cities';

    best_MC = min(MC{at});
    best_SA = min(SA{at});
    best_multiSA = min(multiSA{at});

    pos_best_MC(at) = find(MC{at} == min(MC{at}));
    pos_best_SA(at) = find(SA{at} == min(SA{at}));
    pos_best_multiSA(at) = find(multiSA{at} == min(multiSA{at}));

    number_routes_SA = droutesSA{at}(pos_best_SA(at));
    number_routes_MC = droutesMC{at}(pos_best_MC(at));
    number_routes_multiSA = multidroutesSA{at}(pos_best_multiSA(at));

    number_up_moves = umSA{at}(pos_best_SA(at));
    number_up_moves_multiSA = multiumSA{at}(pos_best_multiSA(at));

    max_xlength_fe(at) = max ( [ feMC{at}(pos_best_MC(at)), feSA{at}(pos_best_SA(at)) , multifeSA{at}(pos_best_multiSA(at)) ] );

    strMC = sprintf(formatSpecMC,n_cities,best_MC,number_routes_MC);
    strSA = sprintf(formatSpecSA,n_cities,best_SA,number_routes_SA,number_up_moves);
    strmultiSA = sprintf(formatSpecmultiSA,n_cities,best_multiSA,number_routes_multiSA,number_up_moves_multiSA);

    str_title = sprintf(title_at,n_cities);
    str_multititle = sprintf(title_multiat,n_cities);

    FigHandle = figure;
    set(FigHandle, 'Position', [0, 0, 640, 640]);
    plot(seMC{at}{pos_best_MC(at)},'Color', color0,'LineWidth',2);
    ylabel('Same Route Function Evaluations');
    xlabel('# Total Function Evaluations');
    t = title({'Relation between the total number of Function Evaluations and Same Route Function Evaluations',str_title});
    l = legend(strMC);
    file_at = 'same_route_MC_%d.png';
    strFILE = sprintf(file_at,n_cities);
    saveas(FigHandle,strFILE);

    FigHandle = figure;
    set(FigHandle, 'Position', [0, 0, 640, 640]);
    plot(seSA{at}{pos_best_SA(at)},'Color', color2,'LineWidth',2);
    ylabel('Same Route Function Evaluations');
    xlabel('# Total Function Evaluations');
    t = title({'Relation between the total number of Function Evaluations and Same Route Function Evaluations',str_title});
    l = legend(strSA);

    set(l,'FontSize',12);
    set(t,'FontSize',30);
    set(gca,'fontsize',13);
    file_at = 'same_route_SA_%d.png';
    strFILE = sprintf(file_at,n_cities);
    saveas(FigHandle,strFILE);

    FigHandle = figure;
    set(FigHandle, 'Position', [0, 0, 640, 640]);
    ylabel('Route Distance');
    xlabel('# Function Evaluations');

    plot(reMC{at}{pos_best_MC(at)},'Color', color0,'LineWidth',2);

    hold on;
    plot(reSA{at}{pos_best_SA(at)},'Color', color2,'LineWidth',2);
    hold on;
    plot(ul_x_SA{at}{pos_best_SA(at)}, ul_y_SA{at}{pos_best_SA(at)},'o', 'MarkerSize', 2,'Color', color1);

    hold on;
    % yl =  ylim; yl(1)=0; ylim(yl);
    xl = xlim; xl(2) = max_xlength_fe(at); xlim(xl);
    l = legend(strMC,strSA,'SA uphill moves');

    t = title({'Relation between the total number of Function Evaluations and Route Distance',str_title});
    set(l,'FontSize',12);
    set(t,'FontSize',30);
    set(gca,'fontsize',13);
    file_at = 'function_evaluations_%d.png';
    filename = sprintf(file_at,n_cities);
    saveas(FigHandle,filename);


    FigHandle = figure;
    set(FigHandle, 'Position', [0, 0, 640, 640]);
    ylabel('Route Distance');
    xlabel('# Function Evaluations');

    plot(reMC{at}{pos_best_MC(at)},'Color', color0,'LineWidth',2);

    hold on;
    plot(reSA{at}{pos_best_SA(at)},'Color', color2,'LineWidth',2);
    hold on;
    plot(ul_x_SA{at}{pos_best_SA(at)}, ul_y_SA{at}{pos_best_SA(at)},'o', 'MarkerSize', 2,'Color', color1);
    hold on;
    plot(multireSA{at}{pos_best_multiSA(at)},'Color', color6,'LineWidth',2);
    plot(multiul_x_SA{at}{pos_best_multiSA(at)}, multiul_y_SA{at}{pos_best_multiSA(at)},'o', 'MarkerSize', 2,'Color', color5);
    hold on;

    %yl =  ylim; yl(1)=0; ylim(yl);
    xl = xlim; xl(2) = max_xlength_fe(at); xlim(xl);

    l = legend(strMC,strSA,'SA uphill moves',strmultiSA,'multiSA uphill moves');
    t = title({'Relation between the total number of Function Evaluations and Route Distance',str_multititle});
    set(l,'FontSize',12);
    set(t,'FontSize',30);
    set(gca,'fontsize',13);
    file_at = 'function_evaluations_multi_%d.png';
    filename = sprintf(file_at,n_cities);
    saveas(FigHandle,filename);
    at=at+1;
end


at=1;

FigHandle = figure;
    set(FigHandle, 'Position', [0, 0, 640, 640]);
    ylabel('# Permutations per Function Evaluation');
    xlabel('# Function Evaluations');
for n_cities = [64,128,256,512,1024]
    semilogy(temperature_permutations_multiSA{at}{pos_best_MC(at)},'LineWidth',2);
     xl = xlim();
    xl(1) = 1;
    xlim( xl );
    hold on;
        at=at+1;
end
l = legend('64 cities','128 cities','256 cities','512 cities','1024 cities');
    t = title({'Relation between the Permutations per Function Evaluations','for the multiSA algorithm'});
    set(l,'FontSize',12);
    set(t,'FontSize',30);
    set(gca,'fontsize',13);
    file_at = 'permutations_per_fe.png';
    
   
    filename = sprintf(file_at,n_cities);
    saveas(FigHandle,filename);

hold off;

