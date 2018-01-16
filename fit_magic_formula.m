function report = fit_magic_formula(report)
    %Magic formula fit initial conditions
    x0 = [15,0.02,50,0]; %B,C,D,E
    %Upper and lower bounds, keeps runaways from happening
    ub = [50 ,5  ,5  ,1.2];
    lb = [5  ,0.8,2  ,0.2];
    %Curve fit optons
    options = optimoptions(@lsqnonlin);
    options.MaxFunEvals = 20000;
    options.MaxIter = 20000;
    options.TolFun = 10^-10;
    options.Display = 'off';

    for i = 1:length(report.seg)
        eqn = @(x)magic_formula_error(x,report.seg(i).SA*(pi/180),report.seg(i).FZ,report.seg(i).FY);
        report.seg(i).magic_cofs = lsqnonlin(eqn,x0,lb,ub,options);
        report.seg(i).B = report.seg(i).magic_cofs(1);
        report.seg(i).C = report.seg(i).magic_cofs(2);
        report.seg(i).D = report.seg(i).magic_cofs(3);
        report.seg(i).E = report.seg(i).magic_cofs(4);
    end