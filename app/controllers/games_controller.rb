class GamesController < ApplicationController
  def new
    prng = Random.new
    @letters = []
    10.times do |i|
      @letters.push((prng.rand(26) + 65).chr)
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if word_not_in_grid?(@word, @letters)
      @result = "word-not-in-grid"
    else
      response = RestClient.get("https://wagon-dictionary.herokuapp.com/#{@word}")
      result = JSON.parse(response)
      if !result["found"]
        @result = "word-not-exist"
      else
        @result = "ok"
        # {
        #   "found": false,
        #   "word": "abc",
        #   "error": "word not found"
        # }
        # {
        # "found": true,
        # "word": "buy",
        # "length": 3
        # }
      end
    end
  end

  private

  def word_not_in_grid?(attempt, grid)
    attempt.downcase.chars.any? { |char| attempt.downcase.count(char) > grid.downcase.count(char) }
  end
end
