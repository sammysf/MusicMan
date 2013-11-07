%Author: Sam Toizer
%11/16/2010
%Assignment: Lab Project Part 1

%MusicMan
function soundVector = MusicMan(score,time)
if nargin == 1
    time = 4;
end
if nargin==0
    score = input('Please input the score');
    time = input('Please input the time');
end
sound(WaveSong(SongParser(score), time))

%WaveSong
function [audioVector] = WaveSong(songVector,time)
audioVector = [];
for ii = 1:length(songVector)
    beatFreq = songVector{ii};
    seconds = 1/time;
    chordVector = Chord(seconds, beatFreq);
    audioVector = [audioVector chordVector];
    
end

%Chord
function [chordVector] = Chord(seconds, vectorFrequencies)
if length(vectorFrequencies)>4
    warning('The function Chord will only use the first four frequencies given for a chord consisting of more than four frequencies.')
    vectorFrequencies = vectorFrequencies(1:4);
end
chordVector = 0;
for ii = 1:length(vectorFrequencies)
    A = PureTone(seconds, vectorFrequencies(ii));
    B = A;
    chordVector = chordVector + B;
end

%PureTone
function [toneVector] = PureTone(seconds, frequency)
t = 0:(seconds*8000-1);
toneVector = cos(2*pi*frequency*t/8000);
end

%Question: How would you change your function PureTone to create a tone
%that starts loud and quickly softens?
%Answer: I would change toneVector = cos(2*pi*frequency*t/8000); to 
%toneVector = t.*exp(-t).*cos(2*pi*frequency*t/8000);

%Question: If you string two of the same notes together, you may \hear" the break between the
%notes. Compare the sound of `c-c' at 2 beats/second with the sound of `c-c-c-c' at
%4 beats/second. Why do you think this might be?
%Answer: There is a break between notes because there is a momentary
%silence between the playing of different beats.