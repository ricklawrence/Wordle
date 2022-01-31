function [candidates, scores] = rankCandidates(candidates, previousGuesses, previousScores, dictionary)
%
% rank the candidates based on commonality of letters in the word
%
global parameters;

%=== get list of single letters in the candidates
candidates = sort(candidates);
x          = char(candidates);
alphabet   = unique(x);

%=== extract letters from previous guesses and remove them from candidate alphabet
previousAlphabet = unique(char(previousGuesses));
reducedAlphabet  = setdiff(alphabet, previousAlphabet);

%=== get letter matrix and letter probabilities from the dictionary for for this subset of words and alphabet
[~,indexC]   = intersect(dictionary.words,    candidates);
[~,indexA]   = intersect(dictionary.alphabet, reducedAlphabet);
letterMatrix = dictionary.letterMatrix1(indexC,indexA);  % = 1 for N in NANNY (this is slightly more accurate)

%=== use letter probabilities computed for candidates, not dictionary
%=== this works because we only care about the relationship among candidates, independent of the entire dictionary
letterCounts = sum(letterMatrix,1)';                % number of words containing each letter
letterProbs  = letterCounts ./ length(candidates);  % probability that word contains each letter

%=== compute score for each candidate across reduced alphabet and return sorted candidates
scores        = letterMatrix * letterProbs;
[~,sortIndex] = sort(scores,'descend');
candidates    = candidates(sortIndex);
scores        = scores(sortIndex);