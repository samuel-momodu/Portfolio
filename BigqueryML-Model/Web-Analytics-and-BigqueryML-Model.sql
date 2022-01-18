/*
* Perform exploratory analysis on the web analytics data set to undedrstand customer behavoir.
* Measure product perforomance.
* To determing customer conversion rate.
* To meausre marketing strategies and thier effectiveness towards our business goals.
* To understnd what marketing channels are most effective.
* To show customer lifetime value and prospects of customers to return and make a purchase.
*/
#BigQuery
#standardSQL
SELECT DISTINCT
  fullVisitorId, # This columns describes the visitor unique identifiction number.
  date, # Date event occured
  city, 
  pageTitle # WHat papge on our platform is the customer interacting with the most.
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE date = '20180708' AND date = '20170708' # Comment this section out to obtain site visits for full data date range. 
LIMIT 5;

/*
* What are the top (5) selling products?
*/
#standardSQL
SELECT
  p.v2ProductName, # Name of purchased products 
  p.v2ProductCategory, # From what line of products rollout did the sale occur 
  SUM(p.productQuantity) AS units_sold,
  ROUND(SUM(p.localProductRevenue/1000000),2) AS revenue # Generated revenue group by products
FROM `data-to-insights.ecommerce.web_analytics`,
UNNEST(hits) AS h,
UNNEST(h.product) AS p
GROUP BY 1, 2 
ORDER BY revenue DESC
LIMIT 5; # Change this value to suit our needs per time

/*
* What is the conversion rate
* Is our currernt business model effective
* Are we achieving our business goals (sales and revenue)
* What is the percentage of purchase from site visits
*/
#StandardSQL
WITH visitors AS(
SELECT
COUNT(DISTINCT fullVisitorId) AS total_visitors
FROM `data-to-insights.ecommerce.web_analytics`
),
purchasers AS(
SELECT
COUNT(DISTINCT fullVisitorId) AS total_purchasers
FROM `data-to-insights.ecommerce.web_analytics`
WHERE totals.transactions IS NOT NULL
)
SELECT
  total_visitors,
  total_purchasers,
  ROUND(total_purchasers / total_visitors * 100,2) AS conversion_rate
FROM visitors, purchasers
;

/*
* What marketing channels are our most effective channels
* 
*/
#StandardSQL #BigQuery
WITH Click_Bids AS 
(SELECT id,
        FirstName,
        LastName,
        Gender,
        EmailAddress AS Email,
        TelephoneNumber AS Tel_NO,
        CountryFull,
FROM `data-to-insights.customer_insights.customer_web_data_cleaned`
WHERE
    AdWords = FALSE  AND   # These values can be tuned depending on the current goal of the analysis.
    DoubleClickBidCampaignManager = TRUE AND
    DoubleClickPublishers = FALSE AND
    YouTube = FALSE AND
    GooglePlayStore = FALSE  AND
    Adsense = FALSE AND
    AdMob = FALSE
)
SELECT * 
FROM    Click_Bids 
;
/*
* Create a machine learning model
* Using logistic regression, determine to classify customer cohorts
* This gives us an idea as to which customers are our most valuable customers
* Helps us know the customer segment to include in specific remarketing and win-back strategies
* Specify features for the model
*/
#BigQuery
#BigQueryML
#standardSQL
CREATE OR REPLACE MODEL `ecommerce.classification_model`
OPTIONS
(
model_type='logistic_reg',
labels = ['will_buy_on_return_visit']
)
AS
#standardSQL
SELECT
  * EXCEPT(fullVisitorId)
FROM
  # features
  (SELECT
    fullVisitorId,
    IFNULL(totals.bounces, 0) AS bounces, # Bounce rate of each site visitor
    IFNULL(totals.timeOnSite, 0) AS time_on_site # total time spent on site
  FROM
    `data-to-insights.ecommerce.web_analytics`
  WHERE
    totals.newVisits = 1
    AND date BETWEEN '20160801' AND '20170430') # train on first 9 months 
  JOIN
  (SELECT
    fullvisitorid,
    IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
  FROM
      `data-to-insights.ecommerce.web_analytics`
  GROUP BY fullvisitorid)
  USING (fullVisitorId)
;
/*  Evaluate the ML model for accuracy
*   Evaluate classification model performance
*   Select your performance criteria
*   For classification problems in ML, you want to minimize the False Positive Rate
*   (predict that the user will return and purchase and they don't) and 
*   maximize the True Positive Rate (predict that the user will return and purchase and they do).
*   This relationship is visualized with a ROC 
*   (Receiver Operating Characteristic) curve, 
*   In BQML, roc_auc is simply a queryable field when evaluating your trained ML model.
*   Now that training is complete, you can evaluate how well the model performs 
*/
#BigQuery #BigQueryML
#standardSQL
SELECT
  roc_auc,
  CASE
    WHEN roc_auc > .9 THEN 'good'
    WHEN roc_auc > .8 THEN 'fair'
    WHEN roc_auc > .7 THEN 'decent'
    WHEN roc_auc > .6 THEN 'not great'
  ELSE 'poor' END AS model_quality
FROM
  ML.EVALUATE(MODEL ecommerce.classification_model,  (
SELECT
  * EXCEPT(fullVisitorId)
FROM
  # Selected Features
  (SELECT
    fullVisitorId,
    IFNULL(totals.bounces, 0) AS bounces,
    IFNULL(totals.timeOnSite, 0) AS time_on_site
  FROM
    `data-to-insights.ecommerce.web_analytics`
  WHERE
    totals.newVisits = 1
    AND date BETWEEN '20170501' AND '20170630') # eval on 2 months
  JOIN
  (SELECT
    fullvisitorid,
    IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
  FROM
      `data-to-insights.ecommerce.web_analytics`
  GROUP BY fullvisitorid)
  USING (fullVisitorId)
))
;
/* Improve model performance with Feature Engineering
* Use different features present in the dataset that may help 
* the model better understand the relationship between a visitor's first session and 
* the likelihood that they will purchase on a subsequent visit.
* Add some new features and create a second machine learning model which will be 
* called classification_model_2:
* How far the visitor got in the checkout process on their first visit
* Where the visitor came from (traffic source: organic search, referring site etc..)
* Device category (mobile, tablet, desktop)
* Geographic information (country)
*/
#BigQueryML
#standardSQL
CREATE OR REPLACE MODEL `ecommerce.classification_model_2`
OPTIONS
  (model_type='logistic_reg', labels = ['will_buy_on_return_visit']) AS
WITH all_visitor_stats AS (
SELECT
  fullvisitorid,
  IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
  FROM `data-to-insights.ecommerce.web_analytics`
  GROUP BY fullvisitorid
)
# Add in new features
SELECT * EXCEPT(unique_session_id) FROM (
  SELECT
      CONCAT(fullvisitorid, CAST(visitId AS STRING)) AS unique_session_id,
      # Labels
      will_buy_on_return_visit,
      MAX(CAST(h.eCommerceAction.action_type AS INT64)) AS latest_ecommerce_progress,
      # Customer behavior on the site
      IFNULL(totals.bounces, 0) AS bounces,
      IFNULL(totals.timeOnSite, 0) AS time_on_site,
      IFNULL(totals.pageviews, 0) AS pageviews,
      # What marketing channels are the most effective (where the visitor came from)
      trafficSource.source,
      trafficSource.medium,
      channelGrouping,
      # Mobile or desktop
      device.deviceCategory,
      # Geographic region
      IFNULL(geoNetwork.country, "") AS country
  FROM `data-to-insights.ecommerce.web_analytics`,
     UNNEST(hits) AS h
    JOIN all_visitor_stats USING(fullvisitorid)
  WHERE 1=1
    # Only predict for new visits
    AND totals.newVisits = 1
    AND date BETWEEN '20160801' AND '20170430' # train 9 months
  GROUP BY
  unique_session_id,
  will_buy_on_return_visit,
  bounces,
  time_on_site,
  totals.pageviews,
  trafficSource.source,
  trafficSource.medium,
  channelGrouping,
  device.deviceCategory,
  country
);
/* A new key feature that was added to the training dataset query is the maximum checkout 
* progress each visitor reached in their session, which is recorded in 
* the field hits.eCommerceAction.action_type. If you search for that field in 
* the field definitions you will see the field mapping of 6 = Completed Purchase.
* As an aside, the web analytics dataset has nested and repeated fields like ARRAYS which 
* need to broken apart into separate rows in your dataset. 
* This is accomplished by using the UNNEST() function, which can be seen being used repeatedly above.
*/

/* Evaluste the new model (ecommerce.classification_model_2)
* To understand the accuracy of the newly created model
*  and to understand if adding new features has improved our ability to predict on customer cohorts 
*/
#BigQueryML
#standardSQL
SELECT
  roc_auc,
  CASE
    WHEN roc_auc > .9 THEN 'good'
    WHEN roc_auc > .8 THEN 'fair'
    WHEN roc_auc > .7 THEN 'decent'
    WHEN roc_auc > .6 THEN 'not great'
  ELSE 'poor' END AS model_quality
FROM
  ML.EVALUATE(MODEL ecommerce.classification_model_2,  (
WITH all_visitor_stats AS (
SELECT
  fullvisitorid,
  IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
  FROM `data-to-insights.ecommerce.web_analytics`
  GROUP BY fullvisitorid
)
# Add in new features
SELECT * EXCEPT(unique_session_id) FROM (
  SELECT
      CONCAT(fullvisitorid, CAST(visitId AS STRING)) AS unique_session_id,
      # Labels
      will_buy_on_return_visit,
      MAX(CAST(h.eCommerceAction.action_type AS INT64)) AS latest_ecommerce_progress,
      # Customer behavior on the site
      IFNULL(totals.bounces, 0) AS bounces,
      IFNULL(totals.timeOnSite, 0) AS time_on_site,
      totals.pageviews,
      # where the visitor came from
      trafficSource.source,
      trafficSource.medium,
      channelGrouping,
      # mobile or desktop
      device.deviceCategory,
      # geographic
      IFNULL(geoNetwork.country, "") AS country
  FROM `data-to-insights.ecommerce.web_analytics`,
     UNNEST(hits) AS h
    JOIN all_visitor_stats USING(fullvisitorid)
  WHERE 1=1
    # only predict for new visits
    AND totals.newVisits = 1
    AND date BETWEEN '20170501' AND '20170630' # eval 2 months
  GROUP BY
  unique_session_id,
  will_buy_on_return_visit,
  bounces,
  time_on_site,
  totals.pageviews,
  trafficSource.source,
  trafficSource.medium,
  channelGrouping,
  device.deviceCategory,
  country
)
))
;





