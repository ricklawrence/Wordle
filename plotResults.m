function plotResults(numGuesses, allAnswers, history, dictionary)
%
% plot result of this evaluation set
%
global parameters;
figureNum = 1;

%--------------------------------------------------------------------
%=== 1. HISTOGRAM OF NUMBER OF GUESSES OVER ALL GAMES
figure(figureNum); fprintf('Figure %d.\n', figureNum);

%=== get data
numGames       = length(allAnswers);
bins           = [0:1:max(numGuesses)];
guesses        = histcounts(numGuesses, bins+0.5);  % in case of rounding error
index1         = 1:6;
index2         = 7:max(numGuesses);
ticks          = bins(2:end);
meanGuesses    = mean(numGuesses);
successful     = length(find(numGuesses <= 6));
accuracy       = 100 * successful / numGames;
[maxGuesses,i] = max(numGuesses);
maxAnswer      = upper(char(allAnswers(i(1))));

%=== bar chart
h  = bar(index1, guesses(index1), 0.8, 'stacked', 'FaceColor', 'g'); hold on;
h  = bar(index2, guesses(index2), 0.8, 'stacked', 'FaceColor', 'r'); hold on;

%=== set title
if strcmp(parameters.evaluationSet,'Full Dictionary')
  strTitle1 = sprintf('Evaluation Set: %d answers from Wordle complete answer set', numGames);
elseif strcmp(parameters.evaluationSet, 'Previous Answers')
  strTitle1 = sprintf('Evaluation Set: %d answers from all daily 2022 Wordle puzzles', numGames);
end
strTitle2   = parameters.wordleTitle;
strTitle3   = sprintf('Success Rate = %2.1f%%  Mean Guesses = %3.2f', accuracy, meanGuesses);
strTitle    = sprintf('%s\n%s\n%s', strTitle1, strTitle2, strTitle3);

%=== set legend and description
strLegend(1) = {sprintf('Won  (Success Rate = %2.1f%%)', accuracy)}; 
strLegend(2) = {sprintf('Lost (%s required %d guesses)', upper(maxAnswer), maxGuesses);}; 
if strcmp(parameters.evaluationSet, 'Previous Answers')
  strLegendLocation = 'NorthWest';
elseif strcmp(parameters.evaluationSet, 'Full Dictionary')
  strLegendLocation = 'NorthEast';
end

%=== finish plot
hold off;
grid on;
set(gca,'Color',parameters.bkgdColor);
set(gca,'LineWidth', 2);
set(gca,'FontSize',  12);
set(gca,'XTick',[ticks]);  
xlabel('Number of Guesses Required to Solve Puzzle', 'FontSize', 16);
ylabel('Number of Wordle Games', 'FontSize', 16);
legend(strLegend, 'Location', strLegendLocation, 'Fontsize', 12, 'FontName','FixedWidth', 'FontWeight','bold');
title(strTitle, 'FontSize', 14);

if ~strcmp(parameters.evaluationSet, 'Previous Answers')
  return;
end

%--------------------------------------------------------------------
%=== 2. BAR PLOT OF WIKIPEDIA WORD RANKS
figureNum = figureNum + 1;
figure(figureNum); fprintf('Figure %d.\n', figureNum);

%=== bar plot
[~,i1,i2]     = intersect(dictionary.words, allAnswers);
wikiRanks(i2) = dictionary.wikiRanks(i1);
y             = wikiRanks;
xTicks        = 1:length(allAnswers);
xLabels       = upper(allAnswers);
h             = bar(y, 0.8, 'FaceColor', 'b');  hold on;

%=== labels
strTitle      = sprintf('Wikipedia Word-Frequency Ranks for %d Daily Wordle Puzzles From %s to %s', ...
                       length(history.dates), char(history.dates(1)), char(history.dates(end)));
xLabel        = sprintf('Wordle Daily Answer');
yLabel        = sprintf('Wikipedia Rank');
strLegends(1) = {sprintf('Words with lower ranks occur more frequently in Wikipedia')};
strLegends(2) = {sprintf('Median Rank = %2.0f (over %d possible Wordle answers)', median(wikiRanks), dictionary.length)};

%=== get axis limits
ax   = gca; 
xmin = ax.XLim(1); 
xmax = ax.XLim(2);
ymin = ax.YLim(1); 
ymax = ax.YLim(2);

%=== horizontal line at median rank
y0 = median(wikiRanks);
plot([xmin,xmax],[y0,y0], 'k:', 'LineWidth', 2); hold on;

%=== add axis labels
hold off;
grid on;
set(gca,'Color',parameters.bkgdColor);
set(gca, 'LineWidth', 1);
set(gca,'FontSize',12);
set(gca,'XTick',xTicks);  
set(gca,'XTickLabel',xLabels(xTicks));
xlabel(xLabel,'FontSize', 16);
ylabel(yLabel,'FontSize', 16);
xtickangle(45);
legend(strLegends, 'Location', 'NorthWest', 'Fontsize', 12, 'FontName','FixedWidth', 'FontWeight','bold');
title(strTitle, 'FontSize', 16);

%--------------------------------------------------------------------
%=== 3. BAR PLOT OF EACH PAST GAME
figureNum = figureNum + 1;
figure(figureNum); fprintf('Figure %d.\n', figureNum);

%=== bar plot
y           = numGuesses;
index1      = find(y<=6);
index2      = find(y>6);
accuracy    = 100*length(index1) / length(y);
meanGuesses = mean(numGuesses);
h = bar(index1, y(index1), 0.8, 'FaceColor', 'g');  hold on;
%h = bar(index2, y(index2), 0.8, 'FaceColor', 'r');  hold on;  % this can give wide red bars ... no idea why
for i=index2
  h = bar(i, y(i), 0.8, 'FaceColor', 'r');  hold on;
end
xTicks  = 1:length(allAnswers);
xLabels = upper(allAnswers);

%=== labels
strTitle1    = sprintf('Results for %d Daily Wordle Puzzles From %s to %s', ...
                       length(history.dates), char(history.dates(1)), char(history.dates(end)));
strTitle2    = parameters.wordleTitle;
strTitle3    = sprintf('Success Rate = %2.1f%%  Mean Guesses = %3.2f', accuracy, meanGuesses);
strTitle     = sprintf('%s\n%s\n%s', strTitle1, strTitle2, strTitle3);
xLabel       = sprintf('Wordle Daily Answer');
yLabel       = 'Number of Guesses';

%=== get axis limits
ax   = gca; 
ylim([0,max(7,max(numGuesses))]);
xmin = ax.XLim(1); 
xmax = ax.XLim(2);
ymin = ax.YLim(1); 
ymax = ax.YLim(2);

%=== horizontal line at 6 guesses
y0 = 6;
plot([xmin,xmax],[y0,y0], 'k-', 'LineWidth', 2); hold on;

%=== horizontal line at mean guesses
y0 = meanGuesses;
plot([xmin,xmax],[y0,y0], 'k:', 'LineWidth', 2); hold on;

%=== add axis labels
hold off;
grid on;
set(gca,'Color',parameters.bkgdColor);
set(gca, 'LineWidth', 1);
set(gca,'FontSize',12);
set(gca,'XTick',xTicks);  
set(gca,'XTickLabel',xLabels(xTicks));
xlabel(xLabel,'FontSize', 16);
ylabel(yLabel,'FontSize', 16);
xtickangle(45);
title(strTitle, 'FontSize', 16);
