function [candidates, scores] = rankCandidates1(candidates, previousGuesses, previousScores, dictionary)
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

%=== add back the letters that are matches in location so they are included in scores
previousScore   = char(previousScores(end));
previousGuess   = char(previousGuesses(end));
exactLetters    = unique(previousGuess(previousScore == '2'));
%reducedAlphabet = union(reducedAlphabet, exactLetters); % solves NANNY problem but degrades overall accuracy

%=== score based on letters in candidates, WITHOUT exluding letters in previous guesses
%=== this works because we want each new guess to probe a new subset of the alphabet
%=== UNCOMMENTING THIS STATEMENT REDUCES ACCURACY FROM 92.5% TO 34.7% AGAINST FULL DICTIONARY
%reducedAlphabet = alphabet;

%=== get letter matrix and letter probabilities from the dictionary for for this subset of words and alphabet
[~,indexC]   = intersect(dictionary.words,    candidates);
[~,indexA]   = intersect(dictionary.alphabet, reducedAlphabet);
letterMatrix = dictionary.letterMatrix1(indexC,indexA);  % = 1 for N in NANNY (this is slightly more accurate)

%=== if this is Easy Wordle, use letter counts to better score words with repeated letters
if strcmp(parameters.wordleMode, 'Easy') 
  letterMatrix = dictionary.letterMatrix2(indexC,indexA);  % = 3 for N in NANNY (solves NANNY problem but degrades overall)
end

%=== use letter probabilities computed for candidates, not dictionary
%=== this works because we only care about the relationship among candidates, independent of the entire dictionary
%=== THIS WORKS BETTER (92.5% vs 90.4% against full dictionary)
letterCounts = sum(letterMatrix,1)';                % number of words containing each letter
letterProbs  = letterCounts ./ length(candidates);  % probability that word contains each letter

%=== compute score for each candidate across reduced alphabet and return sorted candidates
scores        = letterMatrix * letterProbs;
[~,sortIndex] = sort(scores,'descend');
candidates    = candidates(sortIndex);
scores        = scores(sortIndex);