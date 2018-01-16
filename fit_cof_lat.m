function report = fit_cof_lat(report)
    upper_thresh = 0.05;
    x0 = [10000,4000];
    %Curve fit optons
    options = optimoptions(@lsqnonlin);
    options.MaxFunEvals = 20000;
    options.MaxIter = 20000;
    options.TolFun = 10^-10;
    options.Display = 'off';
    for i = 1:25
        %calculate lateral peaks
        report.seg(i).max_lat = max(report.seg(i).FY);
        report.seg(i).filt_max_lat = mean(report.seg(i).FY(report.seg(i).FY > report.seg(i).max_lat*(1-upper_thresh)));
        report.seg(i).min_lat = min(report.seg(i).FY);
        report.seg(i).filt_min_lat = mean(report.seg(i).FY(report.seg(i).FY < report.seg(i).min_lat*(1-upper_thresh)));
    end
    report.ulat_IA = sort(unique(report.sequ_IA(:)));
    report.ulat_IA = transpose(report.ulat_IA);
    for i = 1:length(report.ulat_IA)
        %sort data
        report.ulat(i).pos_peak_lat = sort(abs([report.seg(report.ulat_IA(i)==report.sequ_IA).filt_min_lat,0]),2);
        report.ulat(i).pos_peak_nor = sort(abs([report.seg(report.ulat_IA(i)==report.sequ_IA).mean_FZ,0]),2);
        report.ulat(i).neg_peak_lat = sort(abs([report.seg(report.ulat_IA(i)==report.sequ_IA).filt_max_lat,0]),2);
        report.ulat(i).neg_peak_nor = sort(abs([report.seg(report.ulat_IA(i)==report.sequ_IA).mean_FZ,0]),2);
        %fit the cof of lateral friction line to a sin curve
        eqn = @(x)ulat_sin_error(x,report.ulat(i).pos_peak_nor,report.ulat(i).pos_peak_lat);
        report.ulat(i).pos_sin_cofs = lsqnonlin(eqn,x0,[],[],options);
        report.ulat(i).pos_sin_a = report.ulat(i).pos_sin_cofs(1);
        report.ulat(i).pos_sin_b = report.ulat(i).pos_sin_cofs(2);
        eqn = @(x)ulat_sin_error(x,report.ulat(i).neg_peak_nor,report.ulat(i).neg_peak_lat);
        report.ulat(i).neg_sin_cofs = lsqnonlin(eqn,x0,[],[],options);
        report.ulat(i).neg_sin_a = report.ulat(i).neg_sin_cofs(1);
        report.ulat(i).neg_sin_b = report.ulat(i).neg_sin_cofs(2);
        %find u_lat and normal sensitivity
        report.ulat(i).pos_ulat = report.ulat(i).pos_sin_cofs(1)/report.ulat(i).pos_sin_cofs(2);
        report.ulat(i).pos_ulat_fsen350 = cos((350/2.2*9.81)/report.ulat(i).pos_sin_cofs(2));
        report.ulat(i).neg_ulat = report.ulat(i).neg_sin_cofs(1)/report.ulat(i).neg_sin_cofs(2);
        report.ulat(i).neg_ulat_fsen350 = cos((350/2.2*9.81)/report.ulat(i).neg_sin_cofs(2));
    end
    %Build combination veriables
    report.ulat_sweep = [fliplr([report.ulat(:).neg_ulat]),[report.ulat(:).pos_ulat]];
    report.mean_ulat = mean(report.ulat_sweep);
    report.ulat_fsen350_sweep = [fliplr([report.ulat(:).neg_ulat_fsen350]),[report.ulat(:).pos_ulat_fsen350]];
    report.mean_ulat_fsen350 = mean(report.ulat_fsen350_sweep);
    
    %fit camber sensitivity line
    eqn = @(x)ulat_lin_error(x,report.ulat_IA,[report.ulat(:).pos_ulat]);
    results = lsqnonlin(eqn,[0,2],[],[],options);
    report.pos_ulat_cambsen = results(1); 
    eqn = @(x)ulat_lin_error(x,report.ulat_IA,[report.ulat(:).neg_ulat]);
    results = lsqnonlin(eqn,[0,2],[],[],options);
    report.neg_ulat_cambsen = results(1);
    
    %Gather data for COF plot
    report.cof_plot_peak = [0;0];
    report.cof_plot_data = [0;0];
    indexs = find(report.ulat_IA(1)==report.sequ_IA);
    for i = 1:length(indexs)
        good_indexs = [report.seg(indexs(i)).FY] > [report.seg(indexs(i)).max_lat]*(1-upper_thresh);
        bad_indexs = [report.seg(indexs(i)).FY] <= [report.seg(indexs(i)).max_lat]*(1-upper_thresh);
        report.cof_plot_peak = [report.cof_plot_peak(1,:),transpose(report.seg(indexs(i)).FY(good_indexs));
                                report.cof_plot_peak(2,:),transpose(abs(report.seg(indexs(i)).FZ(good_indexs)))];
        report.cof_plot_data = [report.cof_plot_data(1,:),transpose(report.seg(indexs(i)).FY(bad_indexs));
                                report.cof_plot_data(2,:),transpose(abs(report.seg(indexs(i)).FZ(bad_indexs)))];
    end
    report.cof_plot_peak(:,1) = [];
    report.cof_plot_data(:,1) = [];
end

