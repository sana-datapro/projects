## Spam Detection Using Random Forest Classifier
This project focuses on using the Random Forest algorithm to accurately distinguish between spam and non-spam emails. This model is robust and not sensitive to multidimensionality, multicollinearity, class imbalance and outliers.

## Tools Used
Python

## Findings and Key Insights

Random forest classifier performed very well in detecting spam emails with an accuracy of 94%.

Not Spam emails were correctly classified as legitimate wilth only 19 false positives. And Spam emails were correctly identified with only 28 false negatives.

Our analysis have shown that:

       - Spam emails often use exclamation marks and dollar signs (for example: "Gain 1000$ Now!")
       - The terms 'remove', 'free' are common in spam email, they are typically used in physhing or marketing emails.
       - Spam often uses excessive capitalization to grab attention (For example: "BUY NOW!!").
       - The terms "your", "000", "money" appear generally in spam that tries to personalize emails or suggest financial offers.
