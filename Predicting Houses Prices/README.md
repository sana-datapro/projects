## Problem Definition
Real estate agents and sellers often struggle to set accurate home prices due to fluctuating market conditions. Incorrect pricing can lead to properties staying on the market too long or selling below their true value. Predicting house prices helps determine the optimal listing price, understand market trends, and achieve faster, more profitable sales.

## Objective 
Predicted house prices using Linear Regression Algorithm based on multiple features, including area, neighborhood, year built, heating, electrical systems, and several others. 

## Tools Used
Python (pandas, sklearn, standard scaling & dimensionality reduction using PCA used for better performance)

## Findings and Key Insights
The R2 is highly significant, equal to 0.87. That means that 87% of the variance in the target variable (house price) can be explained by the features in the dataset. The RMSE is equal to 27355 dollars, that means that en average, the model's predictions on the houses prices are off by 27,355 dollars when predicting home prices.The RMSE is acceptable regarding the houses average price which is equal to 180,921 dollars which corresponds to 15% of the price.

Overall, The linear regression model performed pretty good to predict houses'prices with +- 15% of the predictions. We can try non linear machine learning algorithm such as Random Forest, XGBoost and GradientBoosting for example for less error.
