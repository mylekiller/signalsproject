clear all
clc
%% Build Hash Table
keyset = {'C','D','E','F','G','A','B'};
valueset = [0,2,4,5,7,9,11];
keys = containers.Map(keyset, valueset);

%% Set other data
samplingrate = 44100; % 44.1 kHz
dynamic = 1;

%% Read in music File and Build Sinusoids
fid = fopen('music.txt');
tline = fgetl(fid);
tempo = str2double(tline); % bpm
tline = fgetl(fid);
sharp = false;
flat = false;
song = [];
t = [];
time = 0;
while ischar(tline)
    sp = strsplit(tline);
    num = double(cell2mat(sp(1)));
    note = char(num(1));
    if note == 'p'
        dynamic = .5;
        tline = fgetl(fid);
        continue
    elseif note == 'f'
        dynamic = 7;
        tline = fgetl(fid);
        continue
    elseif note == 'm'
        if char(num(2)) == 'p'
            dynamic = 1;
            tline = fgetl(fid);
            continue
        elseif char(num(2)) == 'f'
            dynamic = 3;
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
    note = dynamic * sin(2*pi*freq*t);
    arraylen = samplingrate*dur;
    envelope = [linspace(0,1,.02*samplingrate) linspace(1,.8,.02*samplingrate) linspace(.8,.7,arraylen-(.08*samplingrate)) linspace(.7,0,.04*samplingrate)];
    note = note .* envelope;
    song = [song note];
    time = time + dur;
    sharp = false;
    flat = false;
    tline = fgetl(fid);
end
plot(song)
sound(song,samplingrate)
