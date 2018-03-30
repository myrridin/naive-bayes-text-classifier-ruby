module LanguageClassifier
  class Model
    attr_reader :data
    attr_reader :doc_counts

    def initialize
      @data = {}
      @doc_counts = Hash.new(0)
    end

    def train(text, language)
      data[language] ||= Hash.new(0)
      doc_counts[language] ||= Hash.new(0)

      parse_tokens(text).each do |token|
        data[language][token] += 1
      end

      doc_counts[language] += 1
    end

    def parse_tokens(text)
      text = text.downcase.gsub(/\W/, ' ').gsub(/\s+/, ' ').strip
      text.split(/\s/).reject { |token| token.length < 3 }.uniq
    end

    def predict(text)
      tokens = parse_tokens(text)
      scores = {}

      data.keys.each do |label|
        prob_label = doc_counts[label].to_f / doc_counts.values.reduce(:+).to_f

        sum = 0.0
        count = 0.0

        tokens.each do |token|
          prob_token = data.keys.reduce(0) { |acc, key| acc += (data[key][token] || 0) } / doc_counts.values.reduce(:+).to_f
          next if prob_token == 0.0

          prob_token_in_label = probability_of_token_in_label(token, label)
          sum += (prob_token_in_label * prob_label) / prob_token
          count += 1.0
        end

        scores[label] = sum / count
      end

      scores
    end

    def probability_of_token_in_label(token, label)
      (data[label][token] || 0).to_f / doc_counts[label].to_f
    end
  end
end
