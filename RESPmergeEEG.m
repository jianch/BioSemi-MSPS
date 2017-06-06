%% merge behavioral data into EEG

% Sometimes, it's hard to lively send behavioral data to EEG system, i.e.
% oral response. Here is a code example to merge behavioral result into EEG
% data.
% Author: Jian Chen
% saturn.jian.chen@gmail.com
% 13/Dec/2016

%% load EEG data first, finish 'channel location', 're-reference'
% get event data via 'event = EEG.event'
event = EEG.event;
event_back = event;

%% load behavioral data
fid = fopen('GG01Dec16a_acc.txt');
acc = textscan(fid,'%d');
fclose(fid);

%% set the latency between target code and inserted code
time = 100; 

%% creat response event
for i = 2 : 2 : length(event)
    Nevent(i/2).bepoch    = event(i).bepoch;
    Nevent(i/2).bini      = event(i).bini;
    Nevent(i/2).binlabel  = event(i).binlabel;
    Nevent(i/2).codelabel = event(i).codelabel;
    Nevent(i/2).duration  = event(i).duration;
    Nevent(i/2).enable    = event(i).enable;
    Nevent(i/2).flag      = event(i).flag;
    Nevent(i/2).item      = event(i).item + 1;
    Nevent(i/2).latency   = event(i).latency + time;
    Nevent(i/2).type      = acc{1}(i/2);
end

%% add new events to original event list
for i = 1:length(Nevent)
    event(2*i+i+1:end+1) = event(2*i+i:end); % move rows down
    event(2*i+i) = Nevent(i); % insert response mark
end

%% save event in case of overwrite
save event_merge.mat event

%% if the EEG data was currently loaded, simply replace the EEG.event with event, then operate as normal
EEG.event = event;
%replace ERPLAB event if you are using ERPLAB plugin
ERP.EVENTLIST.eventinfo = event; 


