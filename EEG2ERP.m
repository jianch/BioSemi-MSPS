%% EEG ERPLAB Scripts
% 


%% parameters
file = {'JD23Mar17a'};
bintxt = {'Exp1_Bin_24bins_allTrials','Exp1_Cue_24bins_allTrials','Exp1_Response_allTrials'};

setfilepath = '/home/cogneuro/Desktop/Experiment1a_EEG';
binpath = '/home/cogneuro/Dropbox/Chen_PhD/Experiment1a_eeg/';
erppath =  '/home/cogneuro/Downloads/'; % where to save erpfile
epochrange = [-200.0  800.0];
artichannel = [ 65:68];
artiThreshold = [ -75 75];

%% 
for i = 1:length(file)

	for j = 1:length(bintxt)

		eeglab;

		EEG = pop_loadset('filename',[file{i},'_preProcess.set'],'filepath',setfilepath);
		EEG = eeg_checkset( EEG );
		EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } ); 
		EEG = eeg_checkset( EEG );
		EEG = eeg_checkset( EEG );
		EEG  = pop_binlister( EEG , 'BDF', [binpath,bintxt{j},'.txt'], 'IndexEL',  1, 'SendEL2', 'EEG', 'Voutput', 'EEG' ); 
		EEG = eeg_checkset( EEG );
		EEG = pop_epochbin( EEG , epochrange,  'pre'); 
		EEG = eeg_checkset( EEG );
		EEG  = pop_artextval( EEG , 'Channel', artichannel, 'Flag', [ 1 2], 'Threshold', artiThreshold, 'Twindow', [ -200 800] ); 
		EEG = eeg_checkset( EEG );
		ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
		ERP = pop_savemyerp(ERP, 'erpname', file{i}, 'filename', [file{i},bintxt{j}(6:end-10),'.erp'], 'filepath', erppath, 'Warning', 'on');
		close all; 

	end
end







