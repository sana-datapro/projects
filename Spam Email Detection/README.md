## Problem
Every day, millions of unwanted or malicious emails (spam, phishing, scams, ads) flood users’ inboxes. Manually identifying and filtering them is impossible and inefficient. Traditional rule-based filters (like keyword lists) often fail to keep up with new spam tactics.
Machine learning–based email spam detection solves this by automatically classifying emails as spam or non-spam based on patterns learned from data.

## Method
We used Random Forest algorithm, a robust model and not sensitive to multidimensionality, multicollinearity, class imbalance and outliers.

## Dataset
The dataset was sourced from the the UCI Machine Learning Repository (https://archive.ics.uci.edu/) and it exists in Kaggle platform.

## Tools Used
Python

## Findings and Key Insights

Random forest classifier performed very well in detecting spam emails with an accuracy of 94%. Not Spam emails were correctly classified as legitimate wilth only 19 false positives. And Spam emails were correctly identified with only 28 false negatives.

Our analysis have shown that Spam emails often use exclamation marks and dollar signs, terms such as 'remove' and 'free' typically used in physhing or marketing emails, excessive capitalization to grab attention and terms such as "your", "000", "money" to personalize emails or suggest financial offers.
