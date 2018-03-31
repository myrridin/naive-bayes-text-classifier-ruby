require_relative('tokenizer/basic')

module LanguageClassifier
  # Model defines a language classifier model which can be trained and used to
  # make predictions regarding the language of text
  class Model
    # Initialize the model variables
    def initialize(tokenizer: LanguageClassifier::Tokenizer::Basic)
      @data = Hash.new { |hash, key| hash[key] = Hash.new(0) }
      @doc_counts = Hash.new(0)
      @tokenizer = tokenizer.new
    end

    # Train the model with a given document's text and label
    #
    # @param [String] text The document's text
    # @param [String] label The data's label
    def train(text, label)
      @tokenizer.tokenize(text).each { |token| @data[label][token] += 1 }
      @doc_counts[label] += 1
    end

    # Predict the label of given text, based on the data learned so far
    #
    # @param [String] text The text to predict the label of
    # @return [Hash] A hash with each label's probability
    def predict(text)
      tokens = parse_tokens(text)
      scores = {}
      @data.each_key { |lab| scores[lab] = probability_of_label(tokens, lab) }
      scores
    end

    private

    # Reduce an array of probabilities to an overall probability
    def overall_score(label_scores)
      label_scores.compact.reduce { |acc, e| acc + e }.to_f / label_scores.size
    end

    # Find the probability of a label across the data set of documents
    def probability_of_label(tokens, label)
      prob_label = @doc_counts[label].to_f / @doc_counts.values.reduce(:+).to_f
      label_scores = []

      tokens.each do |token|
        label_scores << probability_token_is_label(token, label, prob_label)
      end

      overall_score(label_scores)
    end

    # Parse tokens from given text using the provided tokenizer.
    def parse_tokens(text)
      @tokenizer.tokenize(text)
    end

    # Find the probability that a given token belongs to a given label
    def probability_token_is_label(token, label, prob_label)
      token_count = token_count(token)
      prob_token = token_count / @doc_counts.values.reduce(:+).to_f
      return nil if prob_token == 0.0

      prob_token_in_label = probability_token_in_label(label, token)
      (prob_token_in_label * prob_label) / prob_token
    end

    # Find the occurrence rate of a given token in a given label
    def probability_token_in_label(label, token)
      (@data[label][token] || 0).to_f / @doc_counts[label].to_f
    end

    # Find the total token count across all labels
    def token_count(token)
      @data.keys.reduce(0) do |acc, key|
        acc += @data[key][token].to_i
        acc
      end
    end
  end
end
