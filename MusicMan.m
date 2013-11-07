function soundVector = MusicMan(score,time)
if nargin == 1
    time = 4;
end
if nargin==0
    score = input('Please input the score:  ');
    time = input('Please input the time:  ');
end
sound(1/4*WaveSong(SongParser(score), time))