# Wordle

This code operates in two modes:
1.	Test Wordle algorithm against multiple evaluation sets.
2.	Provide guesses for Live Wordle at https://www.powerlanguage.co.uk/wordle/

matlab:	
mainWordle						Controls backtesting of Wordle algorithm against multiple evaluation sets
liveWordle						Provides guesses for playing Live Wordle
playWordle						Simulate a single Wordle puzzle
readData							Reads dictionary and past answer files
readWikipediaFile			Reads Wikipedia word frequencies
buildDictionary				Constructs dictionary including necessary indices
scoreTheGuess					Returns score for a guess against known answer
generateNewGuess			Returns best next guess
generateCandidates		Generates a list of candidate words satisfying information from previous guess
rankCandidates1				Ranks the list of candidates seeking to maximize information returned
rankCandidates2				Ranks the list of candidates in terms of Wikipedia word frequencies
plotResults						Generate figures summarizing performance against evaluation sets
getTopWikipediaWords	Build evaluation set using words with highest Wikipedia frequency

data:
answers2315.csv				List of 2315 words that form basis for all Wordle puzzles
dictionary2449.csv		Dictionary of 2449 5-letter words (not used)
dictionary9332.csv		Dictionary of 9332 5-letter words (not used)
dictionary12972.csv		Dictionary of12972  5-letter words (not used)
pastAnswers.csv				List of daily Wordle answers since January 1, 2022
wikipediaWordFreq.txt	Wikipedia word frequencies for 2.18M words

results:
Contains miscellaneous PowerPoint slide decks summarizing various findings.

archive:
Contains periodic code backups.
