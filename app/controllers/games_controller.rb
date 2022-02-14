require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @word = params[:word].upcase
    @message = run_game(@word, params[:letters])
  end

  def url_checker(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    lewagon_api = URI.open(url).read
    lewagon_api_hash = JSON.parse(lewagon_api)
    lewagon_api_hash["found"]
  end

  def word_in_grid?(attempt, letters)
    letters = letters.gsub! ' ', ''
    letter_array = letters.upcase.chars
    word_array = attempt.upcase.chars
    word_array.each do |letter|
      return false unless letter_array.include?(letter)

      letter_array.delete_at(letter_array.index(letter))
    end
    return true
  end

  def invalid_attempt_message(attempt, attempt_result)
    @score = 0
    if attempt_result == false
      return "#{attempt} is not an english word"
    else
      return "#{attempt} is not in the grid"
    end
  end

  def run_game(attempt, letters)
    if word_in_grid?(attempt, letters) == true && url_checker(attempt) == true
      @score = attempt.length
      return "Well done! #{attempt} is a valid word"
    else
      invalid_attempt_message(attempt, url_checker(attempt))
    end
  end
end
