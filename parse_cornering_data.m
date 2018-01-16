function report = parse_cornering_data(report,cornering_data) 
    %% Input

    %Sequence Thresholds
    thresh_IA = 0.1; %deg
    thresh_FZ = 200; %N 
    thresh_segment = 1200;
    thresh_transition = 200;

    %% Code
    %check the input
    if length(cornering_data.sequ_IA) ~= length(cornering_data.sequ_FZ)
        disp ('uneven length sequences');
        return
    end
    report.sequ_IA = cornering_data.sequ_IA;
    report.sequ_FZ = cornering_data.sequ_FZ;

    %convert from lbs to -N
    cornering_data.sequ_FZ = -9.81*cornering_data.sequ_FZ/2.2;

    %run along the data until the start of the test
    i = 1;
    index = cornering_data.start_index;
    report.seg_start = cornering_data.start_index;
    while or(abs(cornering_data.FZ(index)-cornering_data.sequ_FZ(i))>thresh_FZ,abs(cornering_data.IA(index)-cornering_data.sequ_IA(i))>thresh_IA)
        if or(index-report.seg_start > 10000,index == length(cornering_data.IA))
            disp ('error in finding the start of the test');
            return
        end
        index = index+1;
    end

    %parse each test report.seg
    for i = 1:length(cornering_data.sequ_IA)
        %run along the data until the start of the next report.seg
        report.seg_start = index;
        while or(abs(cornering_data.FZ(index)-cornering_data.sequ_FZ(i))>thresh_FZ,abs(cornering_data.IA(index)-cornering_data.sequ_IA(i))>thresh_IA)
            if or(index-report.seg_start > thresh_transition,index == length(cornering_data.IA))
                disp ('error finding the next report.seg');
                return
            end
            index = index+1;
        end
        report.seg_start = index;
        %run to the end of the report.seg
        while and(abs(cornering_data.FZ(index)-cornering_data.sequ_FZ(i))<thresh_FZ,abs(cornering_data.IA(index)-cornering_data.sequ_IA(i))<thresh_IA)
            if index-report.seg_start > thresh_segment
                disp (['overran report.seg ',num2str(i)]);
                return
            elseif index == length(cornering_data.IA)
                disp ('hit end of data early');
                return
            end
            index = index+1;
        end
        %add to report.seg
        report.seg(i).IA = cornering_data.sequ_IA(i);
        report.seg(i).mean_FZ = cornering_data.sequ_FZ(i);
        report.seg(i).FZ = cornering_data.FZ(report.seg_start:index);
        report.seg(i).SA = cornering_data.SA(report.seg_start:index);
        report.seg(i).FY = cornering_data.FY(report.seg_start:index);
    end
    for i = 1:length(cornering_data.sequ_IA)
        report.P = 0.145038*mean(cornering_data.P(cornering_data.start_index:index));
    end
end
    