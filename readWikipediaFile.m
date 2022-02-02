function wikiRanks = readWikipediaFile(inputFile, outputFile, dictionaryWords)
%
% read raw wikipedia word frequency file and retain only the 5 letter words
%

if ~isfile(outputFile)
  
  %-------------------------------------------------------------------------------------------
  %=== 5-letter wikipedia file does not exist -- read raw file and write 5-letter word file
  
  %=== read wikipedia word counts
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

  %=== join into dictionary and save data
  [~,i1,i2]        = intersect(dictionaryWords, words);
  wordCounts       = zeros(length(dictionaryWords), 1);
  wordCounts(i1,1) = counts(i2);
  words(i1)        = words(i2);

  %=== return wiki ranking of each word within the dictionary
  [~,sortIndex]        = sort(wordCounts, 'descend');
  wikiRanks(sortIndex) = [1:length(sortIndex)]';
  words                = words(sortIndex);
  wordCounts           = wordCounts(sortIndex);

  %=== write to output file
  fid = fopen(outputFile, 'w');
  fprintf(fid, 'Rank,Word,Count\n');
  for w=1:length(words)
    fprintf(fid, '%2d,%s,%d\n', w, char(words(w)), wordCounts(w));
  end
  fprintf('Wrote %6d ranks to   %s\n', length(words), outputFile);
  fclose('all');

else
  
  %-------------------------------------------------------------------------------------------
  %=== 5-letter wikipedia exists -- read it
  dataTable = readtable(outputFile);
  ranks     = dataTable.Rank;
  words     = dataTable.Word;
  
  %=== join with dictionary
  [~,i1,i2]     = intersect(dictionaryWords, words);
  wikiRanks     = inf(length(dictionaryWords),1);
  wikiRanks(i1) = ranks(i2);
  fprintf('Read %7d ranks from %s\n', length(wikiRanks), outputFile);
end
