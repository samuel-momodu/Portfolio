
   # Web Analytics Using Logistic Regression to Predict Customer Retention

   ## Table of Contents

1. Introduction

2. Exploratory Data Analysis

3. Model Selection

4. Feature Engineering

5. Model Evaluation

6. Conclusion

7. Summary

8. Future Recommendation

    
   ## Introduction
   
The goal of this analysis project is to generate actionable insights on customer behavior for a firm's e-commerce web platform. 
- To identify the top-performing marketing channels 
- To understand the top performing product category 
- To measure customer conversion rates 
- To create a machine learning model using [logistic regression](https://en.wikipedia.org/wiki/Logistic_regression#:~:text=Logistic%20regression%20is%20a%20statistical%20model%20that%20in,logistic%20model%20%28a%20form%20of%20binary%20regression%20%29.) to make predictions on what segment of current customers are willing to make subsequent purchases from the web platform.

Equipping both primary and secondary stakeholders to make informed decisions which can be used to improve marketing startegies, sales targeting efforts, user experience on the firm's web platforms and to innovate services and products, leading to achievement of business goals and increase in revenue.
   
Data Source: This data can be accessed using google cloud or querying it directly through bigquery.

   ## Exploratory Data Analysis
   
The first query gives us a sense of the number of site visits and also what site pages are most relevant to our customers.
![E-commerce-eda](https://user-images.githubusercontent.com/76920750/149993930-a7b91400-0958-4da1-9b99-c4217c4a2874.PNG)

From these reults we can formulate a hypothesis on how our customers are attracted to our web platform and what exactly our customers expect from our service.

![number-of-purchasing-customers](https://user-images.githubusercontent.com/76920750/150150451-6bbd7f27-83cb-47e9-a7a7-e0ff4f7eecd4.PNG)

Continuing on in our exploration I write a query to understand which of our products are in top demand, this helps us to further understand our brand identity among our customers.

![Top-selling-Products](https://user-images.githubusercontent.com/76920750/150146142-51f7f409-b8a3-4732-aad1-ef4bffeb99f8.PNG)

This query informs us on which categrory of products are in high demand over a period of time and how much revenue has been generated from these category of products. With these insights, we can restock that specific category of products efficiently., and measure our sales performance.

Further exploration of this data helps us to answer business specific questions like:

- What is the conversion rate (what is the percentage of purchase from site visits)
- Is our currernt business model effective
- Are we achieving our business goals (sales and revenue)

![conversion-rate](https://user-images.githubusercontent.com/76920750/150146610-96c185d8-5f05-4edd-90f5-b6fbf090d9a6.PNG)

This allows us to compliment our marketing efforts by optimising the [C.T.A](https://samuel-momodu.medium.com/bounce-rate-reduction-7e26825a66c3) (call to action) along the custommer journey, and create effective re-marketing and customer [win-back](https://emarsys.com/learn/blog/top-4-customer-win-back-strategies-for-success/) strategies.

To obtain further knowledge as to how relevant a brand is to prospective customers, I need to understand how these web users find us. Answering the business question of what marketing channels and strategies are our most efficient.

![Performing-Marketing-ChannelsCapture](https://user-images.githubusercontent.com/76920750/150145256-35c6ad95-7fd1-4b73-912a-3b039cd0e0a2.PNG)

With these insights we are better suited to formulate and test a hypothesis which will yeild an achievement of our business objectives. After exploring the data to obtain a sense of what the brand is worth to current and prospective customers, strategies need to be optimised and created to compliment the efforts of primary and secondary stakeholders, to this end we create a machine learning model.

  ## Model Selection 
  
However, to increase the accuracy of these strategies, I selected a logistic regression machine learning algorithm. This algorithm will inform us on the probable likeliness of current customers making subsequent purchases from the firm's web platform. the algorithm will also provide us with answer to businness qestions like.

![Model Selection](https://user-images.githubusercontent.com/76920750/150151551-87c9c002-c343-4ead-bf54-568c4c409f12.png)

- This gives us an idea as to which customers are our most valuable customers
- Helps us know the customer segment to include in specific remarketing and win-back strategies

![classification model schema](https://user-images.githubusercontent.com/76920750/150154080-5f98d161-3689-442b-acdf-9cf38669ec7f.png)

The results of the model will be used to target the customer cohort effectively with remarketing strategies like loyalty bonuses and email marketing. Because maintaininng a healthy and active relationships with customers is vital for the stable growth of any firm.

![Classification Model ](https://user-images.githubusercontent.com/76920750/150151982-21d630e0-d743-40d2-8f59-2098502a25ed.png)
![classification model duration](https://user-images.githubusercontent.com/76920750/150152924-d2fc4719-90d4-4035-ba2c-57c165fef1f9.png)
![classification model loss](https://user-images.githubusercontent.com/76920750/150152953-d6677276-aa70-43b0-ba83-9a5abef7cc81.png)

Evaluating the model helps  us to understand the accuracy of the created model.

![classification model roc_auc code](https://user-images.githubusercontent.com/76920750/150154782-9b3c1286-5ec3-4e76-affd-71461fd08709.png)
![classification model learning rate](https://user-images.githubusercontent.com/76920750/150152969-d00b9e1c-758c-47b7-8411-fb778c7345ac.png)
![classification model score](https://user-images.githubusercontent.com/76920750/150153386-7712dfe8-4142-4583-98cd-33c64615fc06.png)
![classification model confusion matrix](https://user-images.githubusercontent.com/76920750/150157455-15795ccf-85ab-4db6-835f-4b9a8b08add6.png)
  
  ## Feature Engineering
  
The features selected for the algorithm is a combination of the time spent by each customer on the firm's web platform, the bounce rate for each web session and the unique vistor identification number. The goal of this algorithm will be to predict which customers will make subsequent purchases from the web platform.
      
  ## Model Evaluationns
  
After obtaining the results from the model, I need to ensure the results obtained are accurate, becuase business decisiosn will be made based on the resulsts from the algorithm, hence the accuracy of any model is vital. To evaluate the model, I have pre-selected performance criteria for the model, ensuring that False Positive Rate (predict that the user will return and purchase and they don't) is lowered, and maximize the True Positive Rate (predict that the user will return and purchase and they do).

This relationship is visualized with a ROC (Receiver Operating Characteristic) curve, in BigQuery Machine Learning, roc_auc is simply a queryable field when evaluating your trained ML model. In these scenario I believe the model can be further optimised with additional features to improve prediction accuracy. I believe using different features present in the dataset may help the model better understand the relationship between a visitor's first session and the likelihood that they will purchase on a subsequent visit.
    
To achieve this objective I added some new features and created a second machine learning model which answers business questions like;
- How far the visitor got in the checkout process on their first visit
- Where the visitor came from (traffic source: organic search, referring site etc..)
- Device category used to access the firm's web platform (mobile, tablet, desktop)
- Geographic information (country, city etc.)


![classification model 2 part 1](https://user-images.githubusercontent.com/76920750/150155887-a1f05c3e-cf53-40d8-9b81-5abebe6d006a.png)
![classification model 2 part 2](https://user-images.githubusercontent.com/76920750/150155906-8b78320c-7129-4709-b29b-ca66dd4360a1.png)
![classification model 2](https://user-images.githubusercontent.com/76920750/150156761-db98cc73-41a2-4e6f-ad41-c1c2972b0f36.png)

   After adding features to the model, I re-evaluate the model for accuracy, and to understand if the model better understands the relationship betweeen the customer's first visit, total time spent on the site and how far the customer progressed into the conversion funnel. I am satisfied with the performance report of the model and will use this to make recommendations to both stakeholders and cross-functional teams. 
   
![classification  model 2 loss and duration](https://user-images.githubusercontent.com/76920750/150157396-4deeed9b-f70f-4579-9a87-0136c959618d.png)
![classificationn model 2 learning rate](https://user-images.githubusercontent.com/76920750/150157245-fb9db9f0-bc0e-43c3-b297-0f7a6d089f40.png)
![classification model confusion matrix](https://user-images.githubusercontent.com/76920750/150158540-5bcd53c1-9899-4b62-8925-25dad6cfd0d0.png)
![classification model 2 roc curve](https://user-images.githubusercontent.com/76920750/150158666-7945d724-79b5-4c27-9ad3-75a7de5fafd0.png)
![classifiaction model 2 sccore](https://user-images.githubusercontent.com/76920750/150158740-07887434-bf3b-4fc3-b23a-6d39a365eeb1.png)
    
   ## Conclusion
    
   I have been able successfully predict web platform behavioral patterns of customers who would be willing to make subsequent purchases from our web platform, based on their behaviour (bounce rate, total time on site, how far along the marketing funnel the converted or abandoned). This will allow us to monitor our customers and allocate our resources accurately to engage and encourage customers who fit the behaviour pattern as described by the machiine learining model to make purchases. If the company uses effective marketing and customer success strategies (discounts, loyalty rewards and clear Call to actions) to engage with customers with similar behavioral patterns, I believe it will help the firm achieve it's business goals.
   
   ## Summary
    
   The goal of this data analysis is to identify a customer segment with a consistent purchasing characteristic  and make predictions on the probability that customers with similar behavioral patterns will make recurrent purchases, this is based on the behavior of the identified customer cohorts on the web platform by a logistic regression machine learning model. To achieve this goal, data from the e-commerce site was analyzed and a logistic regression machine learning model was used to make these predictions succesfully. To ensure the prediction model was accurate in describing this cohort, we evaluated it and the result of this analysis tells us that there is a ***98% chance that customers who have been succesfully identified to exhibit similar behaviour while engaging with our web platforom are likely to make recurrent purchases.***
    
   ## Furture Recommendation
    
   During this data analysis project it was assumed that the customer cohort was divided into two namely: 
   - High probability of recurrent purchase
   - Low probability of recurrent purchase 
Although this was insightful for this firm, due to its business domain being e-commerce sector, and the category of products it displays for sale. However, for other firms, in unrelated business domians (i.e SAAS), with more than one product category or service category. The algorithm's feature should be domain specific, and model selection should accurately predict for multivariate cohorts.


