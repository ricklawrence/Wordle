function [dictionary, answers, history] = readData(dictionaryFile, answersFile, pastAnswersFile)
%
% read full dictionary, all answers, and past answers
%

global parameters;

%=== read dictionary file
dataTable  = readtable(dictionaryFile);
dictionary = dataTable.WORDS;
fprintf('Read %7d words from %s.\n',length(dictionary), dictionaryFile);

%=== read answers file
dataTable  = readtable(answersFile);
answers    = dataTable.WORDS;
fprintf('Read %7d words from %s.\n',length(answers), answersFile);

%=== read past answers file
dataTable       = readtable(pastAnswersFile);
history.dates   = cellstr(datestr(datenum(dataTable.DATE), 'mm/dd/yyyy'));
history.answers = lower(dataTable.ANSWERS);
fprintf('Read %7d words from %s.\n',length(history.answers), pastAnswersFile);

%=== determine previous answers not in dictionary
missing = setdiff(history.answers, dictionary);

%=== add past answers to dictionary
if length(missing) > 0
  dictionary = [dictionary; history.answers];
  dictionary = unique(dictionary);
  fprintf('Added %3d past answers to dictionary.   Dictionary now contains %d words.\n', length(missing), length(dictionary));
end


