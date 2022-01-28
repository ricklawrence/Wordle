function topWords = getTopWikipediaWords(number,  dictionary, pastAnswers)
%
% return top wikipedia words to be used as evalation set
% optionally print the wikipedia rank of past Wordle answers
%
%=== return top words
[~,sortIndex] = sort(dictionary.wikiRanks, 'descend');
words         = dictionary.words(sortIndex);
topWords      = words(1:number);

%=== print wikipedia ranks for past Wordle answers
pastPrint = 0;
if pastPrint
  for ww=1:length(pastAnswers)
    w = find(strcmp(pastAnswers(ww), dictionary.words));
    fprintf('%s ranks %4d out of %d words\n', char(dictionary.words(w)), dictionary.wikiRanks(w), length(dictionary.words));
  end
end
