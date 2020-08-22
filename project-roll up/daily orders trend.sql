--Exploratory questions 
--Note: Using Postgresql 
--Given the order table, analyse the trend on daily orders. 

--1)Daily order trend (overview)

SELECT 
  DATE(orders.paid_at)          AS day,
  COUNT(DISTINCT invoice_id)    AS orders, 
  COUNT(DISTINCT line_item_id)  AS items_ordered
FROM 
  dsv1069.orders 
GROUP BY 
  date(orders.paid_at) 

--Analysis study: based on the chart, the trend of daily orders as well as type of item being ordered are generally increasing across the date. 
--There are many fluctative points at a very close interval in which suggesting that there are seasonality in weekly interval. narrowing the observed date is one of the solution to observe a clearer trend.

--2) Daily order trend (To observe seasonality at weekly interval)

SELECT 
  DATE(orders.paid_at)          AS day,
  COUNT(DISTINCT invoice_id)    AS orders, 
  COUNT(DISTINCT line_item_id)  AS items_ordered
FROM 
  dsv1069.orders 
GROUP BY 
  date(orders.paid_at) 
HAVING date(orders.paid_at) BETWEEN  '2015-04-01' AND '2015-04-30'

--Analysis study: based on the chart, daily orders are fluctated across the week in which some of the days in the week are usually higher than the other.
--Thus, in order to improve the accuracy of the data, we can use rolling up quantities from 7 days ago of respective days (for example: orders quantities of 15 april will be the total quantity from 9 april to 15 april).

--3) Daily order trend (quantities roll up from past 7 days)

SELECT 
  dates_rollup.date, 
  SUM(orders)         AS order_count, 
  SUM(items_ordered)  AS items_ordered_count,
  COUNT(day)          AS rows_collapsed
FROM 
  dsv1069.dates_rollup 
LEFT OUTER JOIN 
  (
  SELECT 
    date(orders.paid_at)          AS day,
    COUNT(DISTINCT invoice_id)    AS orders, 
    COUNT(DISTINCT line_item_id)  AS items_ordered
  FROM 
    dsv1069.orders 
  GROUP BY 
    DATE(orders.paid_at) 
  ) daily_orders
ON 
  dates_rollup.date >= daily_orders.day
AND 
  dates_rollup.d7_ago < daily_orders.day
GROUP BY
  dates_rollup.date
ORDER BY dates_rollup.date DESC


