function plot_cornering(report)
    clf;
    
    %Build magic cof table
    magic_formula_coefficients = table;
    out_IA = transpose([report.seg(:).IA]);
    out_FZ = transpose([report.seg(:).mean_FZ]);
    out_B = transpose([report.seg(:).B]);
    out_C = transpose([report.seg(:).C]);
    out_D = transpose([report.seg(:).D]);
    out_E = transpose([report.seg(:).E]);
    magic_formula_coefficients.Inclination_Angle = out_IA;
    magic_formula_coefficients.Normal_Force = out_FZ;
    magic_formula_coefficients.B = out_B;
    magic_formula_coefficients.C = out_C;
    magic_formula_coefficients.D = out_D;
    magic_formula_coefficients.E = out_E;
    %sort table better
    magic_formula_coefficients = sortrows(magic_formula_coefficients,2);
    magic_formula_coefficients = sortrows(magic_formula_coefficients,1);
    
    figure(2);
    set(gcf,'Name','Tire Cornering Data');
    set(gcf,'pos',[10 500 850 565]);
    
    %Plot output data
    uitable('Data', [report.P,report.mean_ulat,report.pos_ulat_cambsen,report.neg_ulat_cambsen,report.mean_ulat_fsen350]...
           ,'ColumnName', {'Pressure','U Lat','Pos IA Delta','Neg IA Delta','Norm Delta','U Long'}...
           ,'Position', [25 500 750 40]);
    set(gca,'Visible','off'); 
    
    %Plot Tables of Data
    uitable('Data', table2array(magic_formula_coefficients)...
           ,'ColumnName', {'IA', 'FN', 'B', 'C', 'D', 'E'}...
           ,'Position', [25 25 500 448]);
    set(gca,'Visible','off');
    
    %Plot lat fit cofs
    uitable('Data', [transpose([-fliplr(report.ulat_IA),report.ulat_IA]),transpose([fliplr([report.ulat(:).neg_sin_a]),[report.ulat(:).pos_sin_a]]),transpose([fliplr([report.ulat(:).neg_sin_b]),[report.ulat(:).pos_sin_b]])]...
           ,'ColumnName', {'IA','Sin A','Sin B'}...
           ,'Position', [550 25 260 200]);
    set(gca,'Visible','off'); 

    
    
    figure(3)
    set(gcf,'Name','Tire Cornering Plots');
    set(gcf,'pos',[10 10 850 600]);

    plot_thresh = 12;
    plot_a = linspace(-plot_thresh*(pi/180),plot_thresh*(pi/180),100);
    subplot(2,2,1);
    title('All Magic Formula Plots (Dimentionalized)')
    hold on;
    for i = 1:25
        plot(plot_a,magic_formula(report.seg(i).magic_cofs,plot_a,report.seg(i).mean_FZ));
    end
    hold off
    
    subplot(2,2,2);
    title('All Magic Formula Plots (Nondimentionalized)')
    hold on;
    for i = 1:25
        plot(plot_a,magic_formula(report.seg(i).magic_cofs,plot_a,1));
    end
    hold off
    
    subplot(2,2,(3:4));
    title('Zero Camber U Lateral Fit')
    hold on;
    plot_x = linspace(0,1700,100);
    plot(report.cof_plot_peak(2,:),report.cof_plot_peak(1,:),'g.',report.cof_plot_data(2,:),report.cof_plot_data(1,:),'b.'...
        ,plot_x,report.ulat(1).neg_sin_cofs(1).*sin(plot_x/report.ulat(1).neg_sin_cofs(2)),'r-');
    hold off  

end

