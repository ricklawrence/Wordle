function guess = generateNewGuess(candidates, dictionary, previousGuesses, iteration)
%
% return a new guess
%
global parameters;

%=== if this is hard wordle and the first guess, return the initial guess
if iteration == 1 && strcmp(parameters.wordleMode, 'Hard')
  guess = dictionary.initialGuess;
  return;
end
  
%=== if this is easy wordle, the first numInitialGuesses are pre-determinined based on letter coverage  
if iteration <= parameters.numInitialGuesses && strcmp(parameters.wordleMode, 'Easy')
  guess = char(dictionary.initialGuesses(iteration));
  return;
end

%=== if using random algorithm and iteration > 1, return random guess from list of candidates
if strcmp(parameters.algorithm, 'Random')
  index = randperm(length(candidates));
  index = index(1);
  guess = char(candidates(index));
  return;
end

%=== if using ranked algorithm and iteration > 1, return candidate with highest rank
if strcmp(parameters.algorithm, 'Ranked')
  guess = char(candidates(1));
  return;
end