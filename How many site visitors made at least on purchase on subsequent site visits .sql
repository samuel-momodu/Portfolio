-- How many visitors bought on subsequent visits to the website?
#standardSQL
# visitors who bought on a return visit (could have bought on first as well
WITH all_visitor_stats AS (
SELECT
  fullvisitorid, --With 741,721 unique visitors
  IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_buy_on_return_visit
  FROM `data-to-insights.ecommerce.web_analytics`
  GROUP BY fullvisitorid
)
SELECT
  COUNT(DISTINCT fullvisitorid) AS total_visitors,
  will_buy_on_return_visit
FROM all_visitor_stats
GROUP BY will_buy_on_return_visit;
/*Analyzing the results, I divide 11873 by the total number of unique visitors,
* (11873 / 729848) = 1.6% of total visitors will return and purchase from the website. 
* This includes the subset of visitors who bought on their very first session and then came back and bought again.
*/

/* What are some of the reasons a typical ecommerce customer will browse the site but not buy until a later visit?
* There is no popular answer, however, one popular reason is comparison shopping between different
* ecommerce sites before ultimately making a purchase decision. 
* This is very common for luxury goods where significant up-front research and comparison is required by the customer before deciding 
* (think car purchases) but also true to a lesser extent for the merchandise on this site 
* (t-shirts, accessories, etc).
* In the world of online marketing, identifying and marketing to these future customers based on the characteristics of their first visit
* will increase conversion rates and reduce the outflow to competitor sites.