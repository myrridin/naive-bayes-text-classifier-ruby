module LanguageClassifier
  module Tokenizer
    # The basic tokenizer strips non-word characters and splits on whitespace
    # characters
    class Basic
      def tokenize(text)
        text.strip
            .downcase
            .gsub(/\W/, ' ')
            .gsub(/\s+/, ' ')
            .split(/\s/)
            .reject { |token| token.length < 3 }
            .uniq
      end
    end
  end
end