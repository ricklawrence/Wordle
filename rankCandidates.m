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

%=== break tie at top of candidate list using Wikipedia ranks
index0 = find(scores == scores(1));
if parameters.useWikipedia && length(index0) > 1
  candidates1        = candidates(index0);
  index1             = find(contains(dictionary.words, candidates1));
  ranks              = dictionary.wikiRanks(index1);
  [~,sortIndex]      = sort(ranks, 'ascend');
  candidates(index0) = candidates(index0(sortIndex));   % replace tied candidates with wiki-ranked candidates
  scores(index0)     = ranks(sortIndex);                % ranks for tied candidates replaced by their wiki ranks
end
