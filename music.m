clear all
clc
%% Build Hash Table and Harmoic Tables
keyset = {'C','D','E','F','G','A','B'};
valueset = [0,2,4,5,7,9,11];
keys = containers.Map(keyset, valueset);
piano = [1, 0.11, 0.34, 0.075, 0.065, 0.05, 0.01, 0.03];
organ = [1, 0.8, 0.1, 0.4];
flute = [1, 9, 3.8, 1.8, 0.4, 0.2];
guitar = [1, 0.68, 1.26, 0.13, 0.13, 0.11, 0.01, 0.02, 0.2];
oboe = [1, 0.98, 2.1, 0.19, 0.2, 0.23, 0.61, 0.3, 0.2];
horn = [1, 0.39, 0.23, 0.22, 0.07, 0.05, 0.07, 0.05, 0.04, 0.03];

%% Set other data
samplingrate = 44100; % 44.1 kHz
dynamic = 1;

%% Read in music File and Build Sinusoids
fid = fopen('music.txt');
tline = fgetl(fid);
tempo = str2double(tline); % bpm
tline = fgetl(fid);
numvoices = str2double(tline);
tline = fgetl(fid);
sharp = false;
flat = false;
song = [];
t = [];
time = 0;
fin = [];
for i = 1:numvoices
    while ischar(tline)
        if isempty(tline)
            break
        end
        sp = strsplit(tline);
        num = double(cell2mat(sp(1)));
        note = char(num(1));
        if note == 'p'
            dynamic = .1;
            tline = fgetl(fid);
            continue
        elseif note == 'f'
            dynamic = 5;
            tline = fgetl(fid);
            continue
        elseif note == 'm'
            if char(num(2)) == 'p'
                dynamic = .6;
                tline = fgetl(fid);
                continue
            elseif char(num(2)) == 'f'
                dynamic = 2;
                tline = fgetl(fid);
                continue
            end
        end
        if length(num) == 2
            if char(num(2)) == '#'
                sharp = true;
            elseif char(num(2)) == 'b'
                flat = true;
            end
        end
        keynum = (str2double(cell2mat(sp(2))) * 12) - 8 + keys(note);
        if sharp
            keynum = keynum + 1;
        elseif flat
            keynum = keynum - 1;
        end
        freq = 440*2^((keynum-49)/12);
        dur = str2double(cell2mat(sp(3)));
        dur = dur * (1./tempo * 60);
        t = linspace(time, dur+time-.001, samplingrate*dur);
        z = 1;
        note = zeros(1, length(t));
        for k=1:length(horn)
            note = note + (sin(2*pi*freq*k*t) * horn(k));
        end
        note = dynamic*note*0.1;
        arraylen = samplingrate*dur;
        envelope = [linspace(0,1,.02*samplingrate) linspace(1,.8,.02*samplingrate) linspace(.8,.7,arraylen-(.08*samplingrate)) linspace(.7,0,.04*samplingrate)];
        note = note .* envelope;
        song = [song note];
        time = time + dur;
        sharp = false;
        flat = false;
        tline = fgetl(fid);
    end
    if isempty(fin)
        fin = zeros(1,length(song));
    end
    if i == 1
        fin = fin + song;
    end
    song = [];
    tline = fgetl(fid);
end
plot(fin)
audiowrite('music.wav',fin,samplingrate)
