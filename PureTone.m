function [toneVector] = PureTone(seconds, frequency)
t = 0:(seconds*8000-1);
toneVector = cos(2*pi*frequency*t/8000);
end