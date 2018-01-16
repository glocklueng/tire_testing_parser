clear;
%% Inupt 
%The type of test being performed
%0: Temperature Rise
%1: Cornering
%2: Drive/Brake
test_type = 1;

%load cornering/B1464run17.mat
load cornering/B1464run16.mat
%If this is a setup procedure
% 0:no, 1:yes
setup = 0;
report.company = 'Hoosier';
report.tire = '20.5x7.0-13 R25B';
report.rim_width = '7';
%Set this value based on the plot, use to sequence the start of a run
data.start_index = 64000;

%% Build raw data struct
data.sequ_IA = [0,0,0,0,0,2,2,2,2,2,4,4,4,4,4,1,1,1,1,1,3,3,3,3,3];
data.sequ_FZ = [350,150,50,250,100,350,150,50,250,100,350,150,50,250,100,350,150,50,250,100,350,150,50,250,100];
%Data sequence
data.ET = ET;
data.FX = FX;
data.FY = FY;
data.FZ = FZ;
data.IA = IA;
data.P = P;
data.SA = SA;
data.SR = SR;
data.TSTC = TSTC;

%% Run setup procedure
if setup == 1
    %plot data alignment graph, try to parse data into a graph
    figure(1);
    sample_num = linspace(1,length(data.ET),length(data.ET));
    start_line = zeros(data.start_index,1);
    if test_type == 0
        start_line = (20*[start_line;ones(length(data.ET)-data.start_index,1)])-10;
        plot(sample_num,start_line,sample_num,data.SA/2,sample_num,data.TSTC/8);
        
    elseif test_type == 1
        start_line = (35*[start_line;ones(length(data.ET)-data.start_index,1)])-20;
        plot(sample_num,start_line,sample_num,data.FZ/100,sample_num,data.IA,sample_num,data.P*0.145038);
    elseif test_type == 2
        start_line = (35*[start_line;ones(length(data.ET)-data.start_index,1)])-20;
        plot(sample_num,start_line,sample_num,data.FZ/100,sample_num,data.IA,sample_num,data.SA,sample_num,data.P*0.145038);
    end
    return
end

%% Analyse the parsed data
if test_type == 0
        %TODO
elseif test_type == 1
    report = parse_cornering_data(report,data);
    report = fit_magic_formula(report);
    report = fit_cof_lat(report);
    plot_cornering(report);
elseif test_type == 2
    %TODO
end

clearvars data sample_num start_line data sample_num start_line test_type setup