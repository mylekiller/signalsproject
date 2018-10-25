clear all
clc
%% Build Hash Table
keyset = {'C','D','E','F','G','A','B'};
valueset = [0,2,4,5,7,9,11];
keys = containers.Map(keyset, valueset);

%% Read in music File and Build Sinusoids
fid = fopen('music.txt');
tline = fgetl(fid);
numvoices = str2double(tline);
tline = fgetl(fid);
sharp = false;
flat = false;
song = [];
t = [];
time = 0;
timemult = 1;
fin = [];
for i=1:numvoices
    while ischar(tline)
        if isempty(tline)
            break
        end
        sp = strsplit(tline);
        num = double(cell2mat(sp(1)));
        note = char(num(1));
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
        t = linspace(time, (dur*timemult)+time-0.001, 1000*dur*timemult);
        song = [song sin(2*pi*freq*t)];
        time = time + dur*timemult;
        sharp = false;
        flat = false;
        tline = fgetl(fid);
    end
    if isempty(fin)
        fin = zeros(1,length(song));
    end
    fin = fin + song;
    song = [];
    tline = fgetl(fid);
end
sound(fin,1000)
