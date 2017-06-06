function EEG_SingleTrial_bootstrap(dataset,behavset,epochWindow,rejectChannel,rejectThreshold,ROIchannel,trialratio,bootstime)
%% Extract single trials
% These scripts must be run after preProcess




%% Extract and bootstrap
for j = 1 : length(dataset)
    
    %% open eeglab
    close all;
    cd(eeglabpath)
    eeglab;

    %% ERPlab processing
    % load preprocessed eeg dataset
    EEG = pop_loadset('filename',dataset{j},'filepath',filepath);
    % Create Eventlist using ERPLAB
    EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
    % Assign bins
    EEG = pop_binlister( EEG , 'BDF', binfile, 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' );
    % Epoch
    EEG = pop_epochbin( EEG , epochWindow,  'pre'); 
    % Artifact rejection
    EEG  = pop_artextval( EEG , 'Channel', rejectChannel, 'Flag',  1, 'Threshold', rejectThreshold, 'Twindow',[ -200.2 799.3] ); 
    
    
    %% Get trials based on conditions
    cd(behavpath)
    load(behavset{j});
    % get validity index based on numerosity
    valid_1   = data.list.cue==1&data.list.targetside==1&data.list.target==1 | data.list.cue==2&data.list.targetside==2&data.list.target==1;
    invalid_1 = data.list.cue==1&data.list.targetside==2&data.list.target==1 | data.list.cue==2&data.list.targetside==1&data.list.target==1;
    
    valid_2   = data.list.cue==1&data.list.targetside==1&data.list.target==2 | data.list.cue==2&data.list.targetside==2&data.list.target==2;
    invalid_2 = data.list.cue==1&data.list.targetside==2&data.list.target==2 | data.list.cue==2&data.list.targetside==1&data.list.target==2;
    
    valid_3   = data.list.cue==1&data.list.targetside==1&data.list.target==3 | data.list.cue==2&data.list.targetside==2&data.list.target==3;
    invalid_3 = data.list.cue==1&data.list.targetside==2&data.list.target==3 | data.list.cue==2&data.list.targetside==1&data.list.target==3;
    
    valid_4   = data.list.cue==1&data.list.targetside==1&data.list.target==4 | data.list.cue==2&data.list.targetside==2&data.list.target==4;
    invalid_4 = data.list.cue==1&data.list.targetside==2&data.list.target==4 | data.list.cue==2&data.list.targetside==1&data.list.target==4;
    
    valid_5   = data.list.cue==1&data.list.targetside==1&data.list.target==5 | data.list.cue==2&data.list.targetside==2&data.list.target==5;
    invalid_5 = data.list.cue==1&data.list.targetside==2&data.list.target==5 | data.list.cue==2&data.list.targetside==1&data.list.target==5;
    
    valid_6   = data.list.cue==1&data.list.targetside==1&data.list.target==6 | data.list.cue==2&data.list.targetside==2&data.list.target==6;
    invalid_6 = data.list.cue==1&data.list.targetside==2&data.list.target==6 | data.list.cue==2&data.list.targetside==1&data.list.target==6;
        
    %% get EEG signals based on numerosity
    % EEG.data = (channels, samples, trials)
    boots.v_1 = EEG.data(:,:,valid_1);
    boots.i_1 = EEG.data(:,:,invalid_1);
    
    boots.v_2 = EEG.data(:,:,valid_2);
    boots.i_2 = EEG.data(:,:,invalid_2);
    
    boots.v_3 = EEG.data(:,:,valid_3);
    boots.i_3 = EEG.data(:,:,invalid_3);
    
    boots.v_4 = EEG.data(:,:,valid_4);
    boots.i_4 = EEG.data(:,:,invalid_4);
    
    boots.v_5 = EEG.data(:,:,valid_5);
    boots.i_5 = EEG.data(:,:,invalid_5);
    
    boots.v_6 = EEG.data(:,:,valid_6);
    boots.i_6 = EEG.data(:,:,invalid_6);
    
    %% Get ROI EEG
    boots.v_1 = mean(EEG.data(ROIchannel,:,valid_1)); boots.v1 = reshape(boots.v_1,2048,70); % reshape
    boots.i_1 = mean(EEG.data(ROIchannel,:,invalid_1)); boots.i1 = reshape(boots.i_1,2048,20);
    
    boots.v_2 = mean(EEG.data(ROIchannel,:,valid_2)); boots.v2 = reshape(boots.v_2,2048,64);
    boots.i_2 = mean(EEG.data(ROIchannel,:,invalid_2)); boots.i2 = reshape(boots.i_2,2048,26);
    
    boots.v_3 = mean(EEG.data(ROIchannel,:,valid_3)); boots.v3 = reshape(boots.v_3,2048,57);
    boots.i_3 = mean(EEG.data(ROIchannel,:,invalid_3)); boots.i3 = reshape(boots.i_3,2048,33);
    
    boots.v_4 = mean(EEG.data(ROIchannel,:,valid_4)); boots.v4 = reshape(boots.v_4,2048,67);
    boots.i_4 = mean(EEG.data(ROIchannel,:,invalid_4)); boots.i4 = reshape(boots.i_4,2048,23);
    
    boots.v_5 = mean(EEG.data(ROIchannel,:,valid_5)); boots.v5 = reshape(boots.v_5,2048,62);
    boots.i_5 = mean(EEG.data(ROIchannel,:,invalid_5)); boots.i5 = reshape(boots.i_5,2048,28);
    
    boots.v_6 = mean(EEG.data(ROIchannel,:,valid_6)); boots.v6 = reshape(boots.v_6,2048,60);
    boots.i_6 = mean(EEG.data(ROIchannel,:,invalid_6));boots.i6 = reshape(boots.i_6,2048,30);    
    
    
    %% bootstrap
    %% valid one
    for ii = 1 : bootstime
        index = randperm(length(boots.v1(1,:)));
        index = index(1:round(length(boots.v1(1,:))*trialratio));
        tmp   = mean(boots.v1(:,index),2);
        boots.N1.v1(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.v1(ii) = min(find(tmp==boots.N1.v1(ii))/2048)-0.2;
        boots.erp.v1{ii} = tmp;
    end
    
    
    % invalid one
    for ii = 1 : bootstime
        index = randperm(length(boots.i1(1,:)));
        index = index(1:round(length(boots.i1(1,:))*trialratio));
        tmp   = mean(boots.i1(:,index),2);
        boots.N1.i1(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.i1(ii) = min(find(tmp==boots.N1.i1(ii))/2048)-0.2;
        boots.erp.i1{ii} = tmp;
    end
    
    
    %% valid two
    for ii = 1 : bootstime
        index = randperm(length(boots.v2(1,:)));
        index = index(1:round(length(boots.v2(1,:))*trialratio));
        tmp   = mean(boots.v2(:,index),2);
        boots.N1.v2(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.v2(ii) = min(find(tmp==boots.N1.v2(ii))/2048)-0.2;
        boots.erp.v2{ii} = tmp;
    end
    
    
    % invalid two
    for ii = 1 : bootstime
        index = randperm(length(boots.i2(1,:)));
        index = index(1:round(length(boots.i2(1,:))*trialratio));
        tmp   = mean(boots.i2(:,index),2);
        boots.N1.i2(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.i2(ii) = min(find(tmp==boots.N1.i2(ii))/2048)-0.2;
        boots.erp.i2{ii} = tmp;
    end
    
    
    %% valid three
    for ii = 1 : bootstime
        index = randperm(length(boots.v3(1,:)));
        index = index(1:round(length(boots.v3(1,:))*trialratio));
        tmp   = mean(boots.v3(:,index),2);
        boots.N1.v3(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.v3(ii) = min(find(tmp==boots.N1.v3(ii))/2048)-0.2;
        boots.erp.v3{ii} = tmp;
    end
    
    
    % invalid three
    for ii = 1 : bootstime
        index = randperm(length(boots.i3(1,:)));
        index = index(1:round(length(boots.i3(1,:))*trialratio));
        tmp   = mean(boots.i3(:,index),2);
        boots.N1.i3(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.i3(ii) = min(find(tmp==boots.N1.i3(ii))/2048)-0.2;
        boots.erp.i3{ii} = tmp;
    end
    
    
    %% valid four
    for ii = 1 : bootstime
        index = randperm(length(boots.v4(1,:)));
        index = index(1:round(length(boots.v4(1,:))*trialratio));
        tmp   = mean(boots.v4(:,index),2);
        boots.N1.v4(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.v4(ii) = min(find(tmp==boots.N1.v4(ii))/2048)-0.2;
        boots.erp.v4{ii} = tmp;
    end
    
    % invalid four
    for ii = 1 : bootstime
        index = randperm(length(boots.i4(1,:)));
        index = index(1:round(length(boots.i4(1,:))*trialratio));
        tmp   = mean(boots.i4(:,index),2);
        boots.N1.i4(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.i4(ii) = min(find(tmp==boots.N1.i4(ii))/2048)-0.2;
        boots.erp.i4{ii} = tmp;
    end
    
    
    %% valid five
    for ii = 1 : bootstime
        index = randperm(length(boots.v5(1,:)));
        index = index(1:round(length(boots.v5(1,:))*trialratio));
        tmp   = mean(boots.v5(:,index),2);
        boots.N1.v5(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.v5(ii) = min(find(tmp==boots.N1.v5(ii))/2048)-0.2;
        boots.erp.v5{ii} = tmp;
    end
    
    % invalid five
    for ii = 1 : bootstime
        index = randperm(length(boots.i5(1,:)));
        index = index(1:round(length(boots.i5(1,:))*trialratio));
        tmp   = mean(boots.i5(:,index),2);
        boots.N1.i5(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.i5(ii) = min(find(tmp==boots.N1.i5(ii))/2048)-0.2;
        boots.erp.i5{ii} = tmp;
    end
    
    
     %% valid six
    for ii = 1 : bootstime
        index = randperm(length(boots.v6(1,:)));
        index = index(1:round(length(boots.v6(1,:))*trialratio));
        tmp   = mean(boots.v6(:,index),2);
        boots.N1.v6(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.v6(ii) = min(find(tmp==boots.N1.v6(ii))/2048)-0.2;
        boots.erp.v6{ii} = tmp;
    end
    
    % invalid six
    for ii = 1 : bootstime
        index = randperm(length(boots.i6(1,:)));
        index = index(1:round(length(boots.i6(1,:))*trialratio));
        tmp   = mean(boots.i6(:,index),2);
        boots.N1.i6(ii) = min(tmp(round((0.2+N1window(1))*2048):round((0.2+N1window(2))*2048)));
        boots.latency.i6(ii) = min(find(tmp==boots.N1.i6(ii))/2048)-0.2;
        boots.erp.i6{ii} = tmp;
    end
    

    
    cd(behavpath)
    % save([behavset{j}(1:end-4),'_bootresult.mat'],'boots')
    % sendmail('saturn.jian.chen@gmail.com','alldone','see attachment',{[behavset{j}(1:end-4),'_bootresult.mat']});
    % sendmail('saturn.jian.chen@gmail.com','Bootstrap Done','move to ERP plot');

    %%%%% calculate the bootstrap erp %%%%%%%
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.v1{1,l}(k);
        end
        erp.v1(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.v2{l}(k);
        end
        erp.v2(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.v3{l}(k);
        end
        erp.v3(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.v4{l}(k);
        end
        erp.v4(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.v5{l}(k);
        end
        erp.v5(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.v6{l}(k);
        end
        erp.v6(k) = mean(tmp);
        clear tmp
    end
    
    fig = figure; plot(erp.v1); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_v1']); close all;
    fig = figure; plot(erp.v2); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_v2']); close all;
    fig = figure; plot(erp.v3); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_v3']); close all;
    fig = figure; plot(erp.v4); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_v4']); close all;
    fig = figure; plot(erp.v5); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_v5']); close all;
    fig = figure; plot(erp.v6); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_v6']); close all;
    
%     sendmail('saturn.jian.chen@gmail.com','Valid ERP Done','see attachment',...
%         {[behavpath,filenameASC(1:end-4),'_ERP_v1.png'],[behavpath,filenameASC(1:end-4),'_ERP_v2.png'],...
%         [behavpath,filenameASC(1:end-4),'_ERP_v3.png'],[behavpath,filenameASC(1:end-4),'_ERP_v4.png'],...
%         [behavpath,filenameASC(1:end-4),'_ERP_v5.png'],[behavpath,filenameASC(1:end-4),'_ERP_v6.png']});

    %% invalid
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.i1{l}(k);
        end
        erp.i1(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.i2{l}(k);
        end
        erp.i2(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.i3{l}(k);
        end
        erp.i3(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.i4{l}(k);
        end
        erp.i4(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.i5{l}(k);
        end
        erp.i5(k) = mean(tmp);
        clear tmp
    end
    
    for k = 1:2048
        for l=1:bootstime
            tmp(l) = boots.erp.i6{l}(k);
        end
        erp.i6(k) = mean(tmp);
        clear tmp
    end
    
    fig = figure; plot(erp.i1); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_i1']); close all;
    fig = figure; plot(erp.i2); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_i2']); close all;
    fig = figure; plot(erp.i3); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_i3']); close all;
    fig = figure; plot(erp.i4); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_i4']); close all;
    fig = figure; plot(erp.i5); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_i5']); close all;
    fig = figure; plot(erp.i6); print('-dpng','-r300',[behavpath,filenameASC(1:end-4),'_ERP_i6']); close all;
    
%     sendmail('saturn.jian.chen@gmail.com','invalid ERP Done','see attachment',...
%         {[behavpath,filenameASC(1:end-4),'_ERP_i1.png'],[behavpath,filenameASC(1:end-4),'_ERP_i2.png'],...
%         [behavpath,filenameASC(1:end-4),'_ERP_i3.png'],[behavpath,filenameASC(1:end-4),'_ERP_i4.png'],...
%         [behavpath,filenameASC(1:end-4),'_ERP_i5.png'],[behavpath,filenameASC(1:end-4),'_ERP_i6.png']});

end
    
    












