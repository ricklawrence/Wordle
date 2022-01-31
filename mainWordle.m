%----------------------------------------------------------------------------------------------------------------
% wordle 
%
% Rick Lawrence
%
%----------------------------------------------------------------------------------------------------------------
%=== clear workspace and close figures
clc;
clear all;       % clear workspace
close all;       % close all existing figures
rng('default');  % so we get same random number sequence every time
warning off;

%----------------------------------------------------------------------------------------------------------------
%=== SET PARAMETERS
global parameters;
parameters.INPUT_PATH           = '../data';
parameters.bkgdColor            = [1 1 0.8];        % background color for plots
parameters.maxIterations        = 50;
parameters.maxGames             = 10000;
parameters.debug                = 0;

parameters.evaluationSet        = 'Single Answer';
parameters.evaluationSet        = 'Full Dictionary';
parameters.evaluationSet        = 'Previous Answers';

%=== DEFAULT is Hard Wordle (1 initial guess)
parameters.numInitialGuesses    = 1;                 % number of pre-computed initial guesses to use at start of game
if parameters.numInitialGuesses == 1
  parameters.wordleMode         = 'Hard';            % guess must be chosen from eligible candidates
  parameters.wordleTitle        = 'HARD WORDLE';
else
  parameters.wordleMode         = 'Easy';            % you can use any word as guess 
  parameters.wordleTitle        = sprintf('EASY WORDLE (%d FIXED INITIAL GUESSES)', parameters.numInitialGuesses);
end

%=== DEFAULT is ranked with no switching to use Wikipedia ranking
parameters.algorithm            = 'Random';
parameters.algorithm            = 'Ranked';          % default = 'Ranked'

%----------------------------------------------------------------------------------------------------------------
% PROCESS DATA AND BUILD DICTIONARY
%=== read data files
%=== dictionary12972 from https://docs.google.com/spreadsheets/d/1KR5lsyI60J1Ek6YgJRU2hKsk4iAOWvlPLUWjAZ6m8sg/edit#gid=0
%=== answers2315     from https://docs.google.com/spreadsheets/d/1-M0RIVVZqbeh0mZacdAsJyBrLuEmhKUhNaVAI-7pr2Y/edit#gid=0
%=== pastAnswers     from https://screenrant.com/wordle-answers-updated-word-puzzle-guide/ 
dictionaryFile  = sprintf('%s/%s', parameters.INPUT_PATH, 'dictionary12972.csv'); 
answersFile     = sprintf('%s/%s', parameters.INPUT_PATH, 'answers2315.csv'); 
pastAnswersFile = sprintf('%s/%s', parameters.INPUT_PATH, 'pastAnswers.csv');
[dictionaryWords, answers, history] = readData(dictionaryFile, answersFile, pastAnswersFile);
pastAnswers = history.answers;

%=== use all answers file as dictionary
dictionaryWords = answers;
fprintf('Using   2315 possible answers as dictionary.\n\n');

%=== build dictionary structure
dictionary = buildDictionary(dictionaryWords, []);

%----------------------------------------------------------------------------------------------------------------
% BUILD EVALUATION SET AND INITIALIZE
%=== set evaluation set
if strcmp(parameters.evaluationSet,     'Full Dictionary')
  allAnswers = dictionary.words;
  parameters.debug = 0;
elseif strcmp(parameters.evaluationSet, 'Previous Answers')
  allAnswers = pastAnswers;
  parameters.debug = 1;
elseif strcmp(parameters.evaluationSet, 'Single Answer')
  allAnswers = pastAnswers(end);                              % latest wordle answer    
  %allAnswers = dictionary.words(1544);                        % RARER
  %allAnswers = dictionary.words(1287);                        % NANNY
  parameters.debug = 3;
end

%=== set initial guess for all games (and remove from evaluation set)
iteration    = 1;
candidates   = dictionary.words;                                    % start with full dicitonary
initialGuess = generateNewGuess(candidates, dictionary, [], iteration);
allAnswers   = setdiff(allAnswers, initialGuess, 'stable');         % remove initial guess from evaluation set

%=== print summary
fprintf('Playing %s Wordle (%d initial guesses) using %s algorithm against %s evaluation set.\n', ...
           parameters.wordleMode, parameters.numInitialGuesses, parameters.algorithm, parameters.evaluationSet);
if strcmp(parameters.wordleMode, 'Easy')
  fprintf('We use the following words as the initial %d guesses in Easy Wordle: ', parameters.numInitialGuesses);
  for i=1:parameters.numInitialGuesses
    fprintf('%s  ', char(upper(dictionary.initialGuesses(i))));
  end
  fprintf('\n');
else      
  fprintf('Using %s as the initial guess in Hard Wordle.\n', upper(initialGuess));
end

%----------------------------------------------------------------------------------------------------------------
%=== PLAY ONE GAME OF WORDLE FOR EACH WORD IN THE EVALUATION SET
numGames      = min(parameters.maxGames, length(allAnswers));
numGuesses    = zeros(length(numGames), 1);
numCandidates = zeros(length(numGames), 1);
for game=1:numGames
  correctAnswer    = char(allAnswers(game));
  [numGuesses(game), numCandidates(game)] = playWordle(correctAnswer, dictionary);
  if parameters.debug >= 1
    fprintf('Game %4d: Answer = %s required %3d guesses\n', game, char(upper(correctAnswer)), numGuesses(game));
  end
end

%----------------------------------------------------------------------------------------------------------------
%=== SUMMARIZE RESULTS

%=== print summary
[maxGuesses, gameMax] = max(numGuesses);
[minGuesses, gameMin] = min(numGuesses);
successful = length(find(numGuesses <= 6));
fprintf('\nPlayed %d games using %s algorithm:\n', numGames, parameters.algorithm);
fprintf(' Mean number of guesses                 = %4.2f\n',               mean(numGuesses));
fprintf(' Mean number of candidates              = %4.0f\n',               mean(numCandidates));
fprintf(' Number of games with 6 guesses or less = %4d (%3.1f%%)\n',       successful, 100*successful/numGames);
fprintf(' %s required the most guesses        = %4d\n',                    char(upper(allAnswers(gameMax))), maxGuesses);
fprintf(' %s required the fewest guesses      = %4d\n',                    char(upper(allAnswers(gameMin))), minGuesses);

%=== plot results
if strcmp(parameters.evaluationSet,'Full Dictionary') || strcmp(parameters.evaluationSet, 'Previous Answers')
  plotResults(numGuesses, allAnswers, history);
end

%=== print worst words
printWorst = 0;
if printWorst
  [~, sortIndex] = sort(numGuesses, 'descend');
  number         = length(find(numGuesses > 6));
  fprintf('\n%d failed words:\n', number);
  for ii=1:number
    i = sortIndex(ii);
    fprintf('%s\t%d\n', char(allAnswers(i)), numGuesses(i));
  end
end
