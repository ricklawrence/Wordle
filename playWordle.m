function [numGuesses, numCandidates] = playWordle(answer, dictionary)
%
% play 1 game of wordle with known answer
%
global parameters;

%=== initalize
rng('default');  % so we get same random number sequence every time
previousGuesses = cell(1,1);
previousScores  = cell(1,1);
candidates      = dictionary.words;  % initial candidates are all possible answers
vector          = '00000';

%=== do successive guesses
iteration     = 0;
numCandidates = 0;
while ~strcmp(vector, '22222') && iteration < parameters.maxIterations
  iteration = iteration + 1;
  
  %=== generate new guess
  guess = generateNewGuess(candidates, dictionary, previousGuesses, iteration);

  %=== score the guess
  [vector, score] = scoreTheGuess(guess, answer);
  
  %=== get new set of candidates
  previousGuesses(iteration) = {guess};
  previousScores(iteration)  = {vector};
  [candidates, scores] = generateCandidates(vector, guess, candidates, previousGuesses, previousScores, dictionary);
  numCandidates = numCandidates + length(candidates);
  
  %=== print results of this iteration
  if parameters.debug >= 2
    fprintf('Iteration %2d: Guess = %s  Answer = %s  Vector = %s  Score = %2d  Number Candidates = %d\n', ...
    iteration, upper(guess), upper(answer), vector, score, length(candidates));
  end
  if parameters.debug == 3 && length(candidates) <= 30
    for w=1:length(candidates)
      fprintf('  %s\t%6.4f\n', char(candidates(w)), scores(w));
    end
  end
  
end

%== return the number of guesses it took to get it right
numGuesses = iteration;


