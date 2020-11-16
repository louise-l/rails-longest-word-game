require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
  end

  def score
    @display_res = display_result
  end

  def matching_letters(attempt, grid)
    attempt.upcase!
    attempt.chars.all? do |letter|
      attempt.count(letter) <= grid.count(letter)
    end
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word_check = JSON.parse(word_serialized)
    word_check["found"]
  end

  def display_result
    @matching = matching_letters(params[:word], params[:grid])
    @english = english_word?(params[:word])

    if @matching && @english
      "Congratulations, the word is valid and was present"
    elsif @matching && @english == false
      "Sorry but #{params[:word]} isn't an english word"
    else
      "Sorry but #{params[:word]} cant be built for#{params[:grid]}"
    end
  end
end
