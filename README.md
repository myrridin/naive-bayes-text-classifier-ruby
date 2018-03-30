# Naive Bayes Text Classification in Ruby

This is a Naive Bayes text classification implementation in Ruby. It was built with language classification in mind but is generic enough it should work with different types of data.

The implementation of the model is in `src/model.rb` and `main.rb` provides an example set of cases. You can run this by cloning and executing `ruby main.rb` in the project directory. The output should look something like

```text

--
Testing "This is probably correct"
Expected result: english
Actual result: english
Confidence: 100.0%
--
Testing "Qu'est-ce que vous aimez faire pendant votre temps libre?"
Expected result: french
Actual result: french
Confidence: 84.23%
--
Testing "¿Puedes hablar más despacio?"
Expected result: spanish
Actual result: spanish
Confidence: 100.0%

```