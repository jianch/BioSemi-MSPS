%% Preprocess script
% Jian Chen
% 31/Jan/2017

%% files
file = {'CJ22Mar17a.bdf','CJ22Mar17b.bdf','CJ22Mar17c.bdf','CJ22Mar17d.bdf','CJ22Mar17e.bdf'};
file = {'JD3May17a.bdf'};



%% open EEGLAB 
cd /home/cogneuro/Documents/MATLAB/eeglab14_0_0b/
eeglab


%% set paras
path = '/home/cogneuro/Desktop/Experiment1a_EEG/';      % where is the EEG data files?
% where is the channel location files?
channelconf = '/home/cogneuro/Documents/MATLAB/eeglab14_0_0b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp';
ref1 = 48; % reference channel while import data
ref2 = [65 66]; % reference channel
filter = [0.1,30]; % filtering range

%% PreProcess
for i = 1 : length(file)
    
    EEG = pop_biosig([path,file{i}], 'ref', ref1); % load bdf file
    EEG=pop_chanedit(EEG, 'lookup', channelconf); % load channel
    EEG = pop_reref( EEG, ref2); % re-reference
    EEG = pop_eegfiltnew(EEG, filter(1), filter(2), 67584, 0, [], 0); % filter
    EEG = pop_saveset( EEG, 'filename',[file{i}(1:end-4),'_preProcess.set'],'filepath',path); % save data set for eeglab
    
end