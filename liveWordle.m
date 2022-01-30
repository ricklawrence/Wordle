%
% play live wordle
%
clc;
warning off;

%=== print todays date
c = date;
today = datestr(datenum(c), 'mmmm dd, yyyy');
[~, dayOfWeek] = weekday(today, 'long');
fprintf('%s, %s\n', dayOfWeek, today);

%=== print summary
fprintf('Vector Coding: Gray = 0  Yellow = 1  Green = 2  (e.g. ''01012'')\n');
fprintf('Playing %s Wordle (%d initial guesses) using %s algorithm.\n', ...
  parameters.wordleMode, parameters.numInitialGuesses, parameters.algorithm);
if strcmp(parameters.wordleMode, 'Easy') || strcmp(parameters.algorithm, 'Random')
  error('Please switch to Hard Wordle with Ranked algorithm to get best results.')
end
fprintf('\n');

%=== initalize
rng('default');                      % so we get same random number sequence every time
previousGuesses = cell(1,1);
previousScores  = cell(1,1);
candidates      = dictionary.words;  % initial candidates are all possible answers

%----------------------------------------------------------------------------------------------------------------
%=== you get 6 guesses
for iteration=1:6
  
  %=== generate new guess
  guess = generateNewGuess(candidates, dictionary, previousGuesses, iteration);
  fprintf('Enter %s as guess number %d in Wordle.\n', upper(guess), iteration);

  %=== input returned vector from Wordle
  prompt = 'Enter vector returned by Wordle: ';
  vector = input(prompt);
  
  %=== found correct answer
  if strcmp(vector, '22222')
    fprintf('Nice going ... you got the correct answer %s with %d guesses!\n', upper(guess), iteration);
    return;
  end

  %=== get new set of candidates
  previousGuesses(iteration) = {guess};
  previousScores(iteration)  = {vector};
  [candidates, scores] = generateCandidates(vector, guess, candidates, previousGuesses, previousScores, dictionary);
  
  %=== print candidates if list is small enough
  fprintf('Generated %d candidates.\n', length(candidates));
  if length(candidates) <= 20
    for c=1:length(candidates)
      fprintf('%s\n', char(upper(candidates(c))));
    end
  end
  
end