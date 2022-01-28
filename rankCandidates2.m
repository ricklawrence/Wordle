function [candidates, wikiRanks] = rankCandidates2(candidates, dictionary)
%
% rank candidates by frequency of occurrence in wikipedia
%
%=== get index of current candidates into dictionary and get wikipedia ranks
[~,i1,i2]  = intersect(candidates, dictionary.words);
candidates = candidates(i1);
wikiRanks  = dictionary.wikiRanks(i2);

%=== return candidates sorted by wikipedia ranks
[~,sortIndex] = sort(wikiRanks,'descend');
candidates    = candidates(sortIndex);
wikiRanks     = wikiRanks(sortIndex);