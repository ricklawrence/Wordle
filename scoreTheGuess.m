function [vector, score] = scoreTheGuess(guess, answer)
%
% return vector and score for a guess against a known answer 
% (just as Wordle does it online)
%
vector = '00000';
for i=1:5
  if guess(i) == answer(i)
    vector(i) = '2';
  elseif contains(answer, guess(i))
    vector(i) = '1';
  end
end

%=== compute score as sum of digits
score = 0;
for i=1:5
  score = score + str2num(vector(i));
end
  
