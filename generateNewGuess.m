function guess = generateNewGuess(candidates, dictionary, iteration)
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

%=== if iteration > 1, return candidate with highest rank
if iteration > 1
  guess = char(candidates(1));
  return;
end