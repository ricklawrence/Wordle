function dictionary = buildDictionary(dictionaryWords, wikiRanks, testWord)
%
% build the dictionary structure
%
global parameters;

%=== get list of single letters in the full dictionary -- always a-z
x        = char(dictionaryWords);
alphabet = unique(x);

%=== compute letter density matrix (1 if letter appears in specified location in the word)
letterMatrix = zeros(length(alphabet),length(dictionaryWords),5);
for L=1:length(alphabet)
  letter            = alphabet(L);
  k                 = find(x == letter);
  letterMatrix(L,k) = 1;                 % letterMatrix = 1 if this letter appears in this location
end

%=== transpose this matrix and save as letterMatrix0
letterMatrix0 = zeros(length(dictionaryWords),length(alphabet),5);
for loc=1:5
  letterMatrix0(:,:,loc) = letterMatrix(:,:,loc)';
end

%=== sum over locations to get density
letterMatrix2 = sum(letterMatrix0,3);     % = 3 for N in NANNY
letterMatrix1 = min(letterMatrix2,1);     % = 1 for N in NANNY

%=== compute probability that a dictionary word contains each letter in alphabet
letterCounts = sum(letterMatrix1,1)';                    % number of words containing each letter
letterProbs  = letterCounts ./ length(dictionaryWords);  % probability that word contains each letter

%=== compute score for each word across full alphabet (highest score is best initial guess)
fullScores = letterMatrix1 * letterProbs;

%=== get initial guess
[~,sortIndex] = sort(fullScores,'descend');
initialGuess  = char(dictionaryWords(sortIndex(3)));  % alter, alter, later are tied at top ... use 'later'

%=== save all data
dictionary.length        = length(dictionaryWords);
dictionary.words         = dictionaryWords;
dictionary.wikiRanks     = wikiRanks;
dictionary.alphabet      = alphabet;
dictionary.letterProbs   = letterProbs;
dictionary.letterMatrix0 = letterMatrix0;
dictionary.letterMatrix1 = letterMatrix1;
dictionary.letterMatrix2 = letterMatrix2;
dictionary.fullScores    = fullScores;
dictionary.initialGuess  = initialGuess;

%==== get best successive initial guesses used in Easy Wordle
initialGuesses    = cell(5,1);
initialGuesses(1) = {dictionary.initialGuess};
alphabet0         = dictionary.alphabet;
for i=2:5
  usedLetters       = unique(char(initialGuesses(1:i-1)));
  alphabet0         = setdiff(alphabet0, usedLetters);
  [~,indexA]        = intersect(dictionary.alphabet, alphabet0);
  scores            = dictionary.letterMatrix1(:,indexA) * dictionary.letterProbs(indexA);
  [~,sortIndex]     = sort(scores,'descend');
  initialGuesses(i) = dictionary.words(sortIndex(1));
end
dictionary.initialGuesses = initialGuesses;

%----------------------------------------------------------------------------
%=== debug print
if ~isempty(testWord)
  
  %=== print probabilty that any word contains specific letter
  [~,sortIndex] = sort(dictionary.letterProbs, 'descend');
  for i=1:length(dictionary.alphabet)
    letter = sortIndex(i);
    fprintf('%s %4.3f\n', dictionary.alphabet(letter), dictionary.letterProbs(letter));
  end
  
  %=== print best initial guesses
  [~,sortIndex] = sort(dictionary.fullScores, 'descend');
  fprintf('Best initial guesses:\n');
  for ww=1:10
    w = sortIndex(ww);
    fprintf('%s %5.4f\n', char(dictionary.words(w)), dictionary.fullScores(w));
  end
  
  %=== print metrics for test word
  w = find(strcmp(testWord, dictionary.words));
  fprintf('Metrics for ''%s'':\n', testWord);
  fprintf('Wikipedia rank = %d\n', dictionary.wikiRanks(w));
  fprintf('Letter Matrix:\n');
  for i=1:length(dictionary.alphabet)
    fprintf('%2s', dictionary.alphabet(i));
  end
  fprintf('\n');
  for i=1:length(dictionary.alphabet)
    fprintf('%2d', dictionary.letterMatrix(w,i));
  end
  fprintf('\n');
end
%----------------------------------------------------------------------------
