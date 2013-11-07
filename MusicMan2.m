function soundVector = MusicMan2(score,time)
if nargin == 1
    time = 4;
end
if nargin==0
    score = input('Please input the score:  ');
    time = input('Please input the time:  ');
end
[frequencies, times, timelocs] = SongParser(score);
times = [time, times];

freqs = cell(length(times), length(frequencies));
% % timelocs(3)
% timelocs(5)
% timelocs(6)
% frequencies(timelocs(5-1)+3-5:timelocs(5)+1-5)
% frequencies(timelocs(6-1)+3-6:timelocs(6)+1-6)
% frequencies

for ii = 2:length(timelocs)
    %freqslength = length(frequencies(timelocs(ii-1):timelocs(ii)-ii+1));
    %freqs(ii-1, 1:freqslength) = frequencies(timelocs(ii-1):timelocs(ii)-ii+1);
    
    %freqslength = length(frequencies(timelocs(ii-1)+1:timelocs(ii)-1));
    %freqs(ii-1, 1:freqslength) = frequencies(timelocs(ii-1)+1:timelocs(ii)-1);

    freqslength = length(frequencies(timelocs(ii-1)+3-ii:timelocs(ii)+1-ii));
    freqs(ii-1, 1:freqslength) = frequencies(timelocs(ii-1)+3-ii:timelocs(ii)+1-ii);
    
    if freqslength ~= 0
        freqs(ii-1, freqslength+1:length(frequencies)) = {-1};
    else
        freqs(ii-1,:) = {-1};
    end
end
disp(freqs);
for ii = 1:size(freqs,1)
    time = times(ii);
    for jj = 1:size(freqs,2)
        if freqs{ii,jj} > -1
            sound(1/4*WaveSong(freqs(ii,jj), time))
        end
    end
end
            
            %sound(1/4*WaveSong(SongParser(score), time))