function [songFrequencies, times, timelocs] = SongParser(score)
% SONGPARSER turns human-readable music into a cell array of frequencies
% Input: An appropriately written score
% Output: A cell-array of frequency vectors corresponding to each beat
%
% The form of the input is 'a-b.c.d-e' where the -'s separate beats, and
% the .'s separate notes in a chord. This example is three beats: the pure
% A note, then a chord of B, C, and D played together, and finally the pure
% note E.
%
% This parser will handle more details than simple notes:
% It will handle c0-c1-c2 as low C, middle C, high C (edit: also c3-c4).
% It will actually handle d-ds-dl for D, D-sharp, D-flat.
% It will accept 3c as three consecutive C notes.

% Split the score up into beats
allNotes = regexp(score,'\-','split');
beatCounter = 1;
times = [0];
timelocs = [0];

% For each beat
for ii = 1:length(allNotes)    
    chord = allNotes{ii};
    time = 0;
    % Split the beat up into notes
    allTones = regexp(chord,'\.','split');
    songBeat = zeros(length(allTones));
    for jj = 1:length(allTones)
        singleTone = allTones{jj};
        % Find the length of the note, octave and modifier (sharp or not)
        nums = regexpi(singleTone,'[a-z]','split');
        if jj == 1
            [number, status] = str2num(nums{1});
            if status
                beats = number;
            else
                beats = 1;
            end
            if beats == 0
                break;
            end
        end
        [number, status] = str2num(nums{end});
        if status && (number <= 4)
            octave = number;
        else
            octave = 1;
        end
        notes = regexp(singleTone,'[0-9]','split');
        empty = true;
        for ll = 1:length(notes)
            if ~isempty(notes{1,ll})
                empty = false;
                break;
            end
        end
        if empty == true
            notes = cell(1);
            notes(1,1) = {str2double(singleTone)};
        end
        
        kk = 1;
        while 1
            if ~isempty(notes{kk})
                singleNote = notes{kk};
                break;
            else
                kk = kk+1;
            end
            if kk > 10
                fprintf('Chord: %s\n Tone: %s\n Key: %s\n',chord, singleTone, key);
                error('Could not find a note');
            end
        end
        if (isa(singleNote(1),'numeric'))
            key = singleNote;
        elseif (regexpi(singleNote(1),'[a-g]'))
            key = singleNote(1);
        elseif (regexpi(singleNote(1),'p'))
            key = 'p';
        else
            fprintf('Chord: %s\n Tone: %s\n Key: %s\n',chord, singleTone, key);
            error('Unknown key');
        end
        mod = 'n';
        if length(singleNote) == 2
            if (regexpi(singleNote(2),'[l s n]'))
                mod = singleNote(2);
            else 
                fprintf('Chord: %s\n Tone: %s\n Modifier: %s\n',chord, singleTone, singleNote(2));
                warning('Unknown modifier. Accepted modifiers are l (flat), s (sharp) and n (neutral)')
            end
        end
        
        %%%%% Normally I would put this by itself in a file
        letter = lower(key);
        frequency = 0;

        if isa(letter,'numeric')
            time = letter;
            timeloc = ii;
        elseif strcmp(mod,'l')  % Flats
            switch letter
            case {'c'}
                frequency = 247.5;
            case {'d'}
                frequency = 277;
            case {'e'}
                frequency = 311;
            case {'f'}
                frequency = 330;
            case {'g'}
                frequency = 370;
            case {'a'}
                frequency = 415;
            case {'b'}
                frequency = 466;
            otherwise
                disp('Error');
            end
        elseif strcmp(mod,'s') % Sharps
            switch letter
            case {'c'}
                frequency = 277;
            case {'d'}
                frequency = 311;
            case {'e'}
                frequency = 349;
            case {'f'}
                frequency = 370;
            case {'g'}
                frequency = 415;
            case {'a'}
                frequency = 466;
            case {'b'}
                frequency = 554;
            otherwise
                disp('Error');
            end
        else                   % Naturals
            switch letter 
                case {'c'}
                    frequency = 262;
                case {'d'}
                    frequency = 294;
                case {'e'}
                    frequency = 330;
                case {'f'}
                    frequency = 349;
                case {'g'}
                    frequency = 392;
                case {'a'}
                    frequency = 440;
                case {'b'}
                    frequency = 495;
                case {'p'}
                    frequency = 0;
                otherwise
                    disp('Error');
            end
        end

        frequency = frequency * 2^(octave-1);             

        songBeat(jj) = frequency;
        
    end
    if beats ~= 0 && ~isa(letter,'numeric')
        for kk=1:beats;
            songFrequencies{beatCounter} = songBeat;
            beatCounter = beatCounter + 1;
        end
    end
    if time ~= 0
        times(length(times)+1) = time;
        timelocs(length(timelocs)+1) = timeloc;
    end
end

times = times(2:end);
timelocs(length(timelocs)+1) = length(songFrequencies)+length(times)+1;

return