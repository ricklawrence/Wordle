function [candidates, scores] = generateCandidates(vector, guess, candidates, previousGuesses, previousScores, dictionary)
%
% return candidates for given vector against the current candidate list
%
global parameters;

%=== if we just got it right, there are no candidates
if strcmp(vector, '22222')
  candidates = [];
  scores     = [];
  return;
end

%=== initialize index to all candidates
index = [1:length(candidates)]';

%=== loop over letters in score
x = char(candidates);
for s=1:5
  index1 = [];
  if vector(s) == '0'
    index1 = index;                        % no information -- keep current list
  elseif vector(s) == '1'
    [index1,~] = find(x == guess(s));      % words containing the letter
  elseif vector(s) == '2'
    [index1,~] = find(x(:,s) == guess(s)); % words with exact match on letter
  end
  index = intersect(index,index1);
end
candidates = unique(candidates(index));

%=== exclude previous guesses
candidates = setdiff(candidates, previousGuesses);

%=== rank candidates to get words with common letters not used in previous guess
[candidates, scores]   = rankCandidates(candidates, previousGuesses, previousScores, dictionary);
