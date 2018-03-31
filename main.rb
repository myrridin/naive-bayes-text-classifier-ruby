require_relative 'src/language_classifier/model'

model = LanguageClassifier::Model.new

Dir.glob('data/train/**/*.txt') do |training_file|
  language = File.dirname(training_file).split('/').last
  file_data = File.read(training_file)
  model.train(file_data, language)
end

test_cases = [
  ['This is probably correct', 'english'],
  ['Qu\'est-ce que vous aimez faire pendant votre temps libre?', 'french'],
  ['¿Puedes hablar más despacio?', 'spanish']
]

test_cases.each do |sentence, expected_output|
  puts '--'
  puts "Testing \"#{sentence}\""

  prediction, confidence = model.predict(sentence).max_by { |_key, val| val }
  confidence_percent = (confidence * 100.0).round(2)

  puts "Expected result: #{expected_output}"
  puts "Actual result: #{prediction}"
  puts "Confidence: #{confidence_percent}%"
end
