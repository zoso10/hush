# frozen_string_literal: true

module Hush
  class Sentiment
    def initialize(statement)
      score_sentiment(statement)
    end

    def nice?
      statement_sentiment_score.positive?
    end

    def mean?
      statement_sentiment_score.negative?
    end

    def neutral?
      statement_sentiment_score.zero?
    end

    private

    attr_reader :statement_sentiment_score

    def score_sentiment(statement)
      sentences = tokenize_sentences(statement)
      sentence_scores = sentences.map { |sentence| score_sentence(sentence) }
      # could get more sophisticated here
      # ie. weight more of a certain sentence sentiment heavier.
      @statement_sentiment_score = sentence_scores.reduce(:+)
    end

    def tokenize_sentences(statement)
      statement.
        split(/[.!?]/).
        map { |sentence| sentence.strip.downcase.gsub(/[^\w\s]/, "").split(/\s/) }
    end

    def score_sentence(sentence)
      positive_word_count = (sentence & positive_words).count
      negative_word_count = (sentence & negative_words).count
      # could get more sophisticated here
      # ie. certain words have a higher weight than others.
      positive_word_count - negative_word_count
    end

    def positive_words
      @_positive_words ||= File.read("positive_words.txt").split(",\n")
    end

    def negative_words
      @_negative_words ||= File.read("negative_words.txt").split(",\n")
    end
  end
end
