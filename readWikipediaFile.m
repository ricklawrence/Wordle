function wikiRanks = readWikipediaFile(inputFile, dictionaryWords, numPrint)
%
% read raw wikipedia word frequency file and retain only the 5 letter words
%
%=== read dictionary file
dataTable  = readtable(inputFile);
words      = dataTable.WORD;
counts     = dataTable.COUNT;
fprintf('Read %7d words from %s.\n',length(words), inputFile);

%=== filter for 5 letter words
x      = char(words);
[i j]  = find(x(:,5) ~= ' ' & x(:,6) == ' ');
filter = unique(i);
words  = words(filter);
counts = counts(filter);
fprintf('Found %4d 5-letter words.\n',length(filter));

%=== join into dictionary and save data
[~,i1,i2]        = intersect(dictionaryWords, words);
wordCounts       = zeros(length(dictionaryWords), 1);
wordCounts(i1,1) = counts(i2);
words(i1)        = words(i2);
fprintf('Matched %d (%3.1f%%) of words in dictionary.\n',length(i1), 100*length(i1)/length(dictionaryWords));

%=== return wiki ranking of each word within the dictionary
[~,sortIndex] = sort(wordCounts, 'descend');
wikiRanks     = sortIndex;
words         = words(sortIndex);
wordCounts    = wordCounts(sortIndex);

%=== print most common words
for w=1:numPrint
  fprintf('%2d\t%s\t%d\n', w, char(words(w)), wordCounts(w));
end

