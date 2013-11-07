function [audioVector] = WaveSong(songVector,time)
audioVector = [];
for ii = 1:length(songVector)
    beatFreq = songVector{ii};
    seconds = 1/time;
    chordVector = Chord(seconds, beatFreq);
    audioVector = [audioVector chordVector];
    
end