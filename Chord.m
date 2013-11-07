function [chordVector] = Chord(seconds, vectorFrequencies)
if length(vectorFrequencies)>4
    warning('The function Chord will only use the first four frequencies given for a chord consisting of more than four frequencies.')
    vectorFrequencies = vectorFrequencies(1:4);
end
chordVector = 0;
for ii = 1:length(vectorFrequencies)
    A = PureTone(seconds, vectorFrequencies(ii));
    chordVector = chordVector + A;
end