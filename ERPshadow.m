function erpboots = ERPshadow(sets1,sets2)
%% get 97.5% CI of the ERP
% feed in preProcessed EEGdata (*.set) and behaviroal data (*.mat)

%% settings
if IsLinux
    eeglabpath = '/home/cogneuro/Documents/MATLAB/eeglab14_0_0b/';
    filepath   = '/home/cogneuro/Desktop/Experiment1a_EEG';
    behavpath  = '/home/cogneuro/Dropbox/Chen_PhD/Experiment1a_eeg/Data';
    binfile    = '/home/cogneuro/Dropbox/Chen_PhD/Experiment1a_eeg/Exp1_Cue_24bins_allTrials.txt';
else
    eeglabpath = '/Users/saturn/Documents/MATLAB/eeglab13_5_4b/';
    filepath   = '/Users/saturn/Desktop/EEG';
    behavpath  = '/Users/saturn/Dropbox/Chen_PhD/Experiment1a_eeg/Data';
    binfile    = '/Users/saturn/Dropbox/Chen_PhD/Experiment1a_eeg/Exp1_Cue_24bins_allTrials.txt';
end


%% datasets in case of none input
datasets = sets1;
behavset = sets2;




%% paras
srate = 2048; % sampling rate
epochWindow   = [-200.0, 800.0]; % epoch length
rejectChannel = 65:68; % eletrodes around eyes
rejectThreshold = [-75, 75]; % rejection threshold
ROIchannel  = [16:26,53:64]; % those channels you're interested
trialratio  = 0.5; % how many trials to extract for each bootstrapping
bootstime = 1; % do it for n times

ci_interval = [0.025, 0.975];


%% bootstrapping and get the 97.5% CI

%% Extract and bootstrap


%% open eeglab
close all;
cd(eeglabpath)
eeglab;

%% ERPlab processing
% load preprocessed eeg datasets
EEG = pop_loadset('filename',datasets,'filepath',filepath);
% Create Eventlist using ERPLAB
EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
% Assign bins
EEG = pop_binlister( EEG , 'BDF', binfile, 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' );
% Epoch
EEG = pop_epochbin( EEG , epochWindow,  'pre');
% Artifact rejection
EEG  = pop_artextval( EEG , 'Channel', rejectChannel, 'Flag',  1, 'Threshold', rejectThreshold, 'Twindow', epochWindow );


%% Get trials based on conditions
cd(behavpath)
load(behavset);
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
boots.v_1 = mean(EEG.data(ROIchannel,:,valid_1)); boots.v1 = reshape(boots.v_1,srate,size(boots.v_1,3)); % reshape
boots.i_1 = mean(EEG.data(ROIchannel,:,invalid_1)); boots.i1 = reshape(boots.i_1,srate,size(boots.i_1,3));

boots.v_2 = mean(EEG.data(ROIchannel,:,valid_2)); boots.v2 = reshape(boots.v_2,srate,size(boots.v_2,3));
boots.i_2 = mean(EEG.data(ROIchannel,:,invalid_2)); boots.i2 = reshape(boots.i_2,srate,size(boots.i_2,3));

boots.v_3 = mean(EEG.data(ROIchannel,:,valid_3)); boots.v3 = reshape(boots.v_3,srate,size(boots.v_3,3));
boots.i_3 = mean(EEG.data(ROIchannel,:,invalid_3)); boots.i3 = reshape(boots.i_3,srate,size(boots.i_3,3));

boots.v_4 = mean(EEG.data(ROIchannel,:,valid_4)); boots.v4 = reshape(boots.v_4,srate,size(boots.v_4,3));
boots.i_4 = mean(EEG.data(ROIchannel,:,invalid_4)); boots.i4 = reshape(boots.i_4,srate,size(boots.i_4,3));

boots.v_5 = mean(EEG.data(ROIchannel,:,valid_5)); boots.v5 = reshape(boots.v_5,srate,size(boots.v_5,3));
boots.i_5 = mean(EEG.data(ROIchannel,:,invalid_5)); boots.i5 = reshape(boots.i_5,srate,size(boots.i_5,3));

boots.v_6 = mean(EEG.data(ROIchannel,:,valid_6)); boots.v6 = reshape(boots.v_6,srate,size(boots.v_6,3));
boots.i_6 = mean(EEG.data(ROIchannel,:,invalid_6));boots.i6 = reshape(boots.i_6,srate,size(boots.i_6,3));


%% get n average trials
fprintf('getting n average trials\n')
%% valid one
for ii = 1 : bootstime
    index = randperm(length(boots.v1(1,:)));
    index = index(1:round(length(boots.v1(1,:))*trialratio)); % extract a number of trials
    boots.erp.v1{ii} = mean(boots.v1(:,index),2); % average the extracted trials
end


% invalid one
for ii = 1 : bootstime
    index = randperm(length(boots.i1(1,:)));
    index = index(1:round(length(boots.i1(1,:))*trialratio));
    boots.erp.i1{ii} = mean(boots.i1(:,index),2);
end


%% valid two
for ii = 1 : bootstime
    index = randperm(length(boots.v2(1,:)));
    index = index(1:round(length(boots.v2(1,:))*trialratio));
    boots.erp.v2{ii} = mean(boots.v2(:,index),2);
end


% invalid two
for ii = 1 : bootstime
    index = randperm(length(boots.i2(1,:)));
    index = index(1:round(length(boots.i2(1,:))*trialratio));
    boots.erp.i2{ii} = mean(boots.i2(:,index),2);
end


%% valid three
for ii = 1 : bootstime
    index = randperm(length(boots.v3(1,:)));
    index = index(1:round(length(boots.v3(1,:))*trialratio));
    boots.erp.v3{ii} = mean(boots.v3(:,index),2);
end


% invalid three
for ii = 1 : bootstime
    index = randperm(length(boots.i3(1,:)));
    index = index(1:round(length(boots.i3(1,:))*trialratio));
    boots.erp.i3{ii} = mean(boots.i3(:,index),2);
end


%% valid four
for ii = 1 : bootstime
    index = randperm(length(boots.v4(1,:)));
    index = index(1:round(length(boots.v4(1,:))*trialratio));
    boots.erp.v4{ii} = mean(boots.v4(:,index),2);
end

% invalid four
for ii = 1 : bootstime
    index = randperm(length(boots.i4(1,:)));
    index = index(1:round(length(boots.i4(1,:))*trialratio));
    boots.erp.i4{ii} = mean(boots.i4(:,index),2);
end


%% valid five
for ii = 1 : bootstime
    index = randperm(length(boots.v5(1,:)));
    index = index(1:round(length(boots.v5(1,:))*trialratio));
    boots.erp.v5{ii} = mean(boots.v5(:,index),2);
end

% invalid five
for ii = 1 : bootstime
    index = randperm(length(boots.i5(1,:)));
    index = index(1:round(length(boots.i5(1,:))*trialratio));
    boots.erp.i5{ii} = mean(boots.i5(:,index),2);
end


%% valid six
for ii = 1 : bootstime
    index = randperm(length(boots.v6(1,:)));
    index = index(1:round(length(boots.v6(1,:))*trialratio));
    boots.erp.v6{ii} = mean(boots.v6(:,index),2);
end

% invalid six
for ii = 1 : bootstime
    index = randperm(length(boots.i6(1,:)));
    index = index(1:round(length(boots.i6(1,:))*trialratio));
    boots.erp.i6{ii} = mean(boots.i6(:,index),2);
end




%%%%% calculate average and CI of bootstrap erp %%%%%%%
fprintf('calculating average and CI of bootstrap erp\n')
cd(behavpath)
% Valid / Attended
for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.v1{1,l}(k);
    end
    erp.v1(k) = mean(tmp);
    erp.civ1(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.v2{l}(k);
    end
    erp.v2(k) = mean(tmp);
    erp.civ2(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.v3{l}(k);
    end
    erp.v3(k) = mean(tmp);
    erp.civ3(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.v4{l}(k);
    end
    erp.v4(k) = mean(tmp);
    erp.civ4(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.v5{l}(k);
    end
    erp.v5(k) = mean(tmp);
    erp.civ5(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.v6{l}(k);
    end
    erp.v6(k) = mean(tmp);
    erp.civ6(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end




%% invalid / Unattended
for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.i1{l}(k);
    end
    erp.i1(k) = mean(tmp);
    erp.cii1(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.i2{l}(k);
    end
    erp.i2(k) = mean(tmp);
    erp.cii2(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.i3{l}(k);
    end
    erp.i3(k) = mean(tmp);
    erp.cii3(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.i4{l}(k);
    end
    erp.i4(k) = mean(tmp);
    erp.cii4(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.i5{l}(k);
    end
    erp.i5(k) = mean(tmp);
    erp.cii5(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

for k = 1:srate
    for l=1:bootstime
        tmp(l) = boots.erp.i6{l}(k);
    end
    erp.i6(k) = mean(tmp);
    erp.cii6(k) = max(tinv(ci_interval,length(tmp)-1)*(std(tmp)/sqrt(length(tmp))));
    clear tmp
end

fprintf(['datasets ',behavset(1:end-4),' has done\n']);
erpboots = erp;
save([behavset(1:end-4),'_erpboots.mat'],'erpboots');
fprintf([behavset(1:end-4),'_erpboots.mat has been saved\n'])

close all;
cd(behavpath);