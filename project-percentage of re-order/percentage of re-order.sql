--Exploratory questions 
--Note: Using Postgresql 
--Given the order table, analyse its item re-order.


--percentage item re-order.

SELECT
	item_name,
	COUNT (CASE WHEN times_user_reordered >1 THEN CAST (1 as INT) ELSE NULL END) *100/ COUNT (*) AS reorder_percentage,
	COUNT (CASE WHEN times_user_reordered =1 THEN CAST (1 AS INT) ELSE NULL END) *100/ COUNT (*) AS no_reorder_percentage
FROM 
	(
	SELECT
		user_id, item_name,
		COUNT (*) AS times_user_reordered
	FROM
		(SELECT 
			user_id,
			invoice_id,
			item_name,
			COUNT (item_name) as Count_item
		FROM
			dsv1069.orders orders	
		WHERE 
			paid_at is NOT NULL
		GROUP BY 
			user_id, invoice_id, item_name) count_item_same_invoice
	GROUP BY user_id,item_name) user_level
GROUP BY item_name
ORDER BY COUNT (CASE WHEN times_user_reordered >1 THEN CAST (1 as INT) ELSE NULL END) *100/ COUNT (*) DESC

--based on the analysis, Majority of items from current list do not have re-order by respective customers (over 90% of customers are not re-ordering). 
--Of those items that are having re-order by customers, the percentage of its re-order are very low.


--draft code 

--item_count of user order the same item in the same orders). (Note: order counts means order at different timing. This means that invoiceID is different)

SELECT 
  user_id,
  invoice_id,
  item_name,
  COUNT (item_name) AS Count_item
FROM
  dsv1069.orders orders
WHERE 
  paid_at IS NOT NULL
GROUP BY 
  user_id, invoice_id, item_name
  

-- users that do have re-order the same items. (Note: order counts means order at different timing. This means that invoiceID is different)


SELECT 
	user_id,
	item_name,
	COUNT (item_name) AS times_user_reordered
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) AS Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at IS NOT NULL
	GROUP BY 
		user_id, invoice_id, item_name) count_item_same_invoice
GROUP BY 
  user_id, item_name 
HAVING 
  COUNT (item_name) >1

-- users that do not have re-order the same items. (Note: order counts means order at different timing. This means that invoiceID is different)


SELECT
	user_id,
	item_name,
	COUNT (item_name) AS times_user_reordered
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) AS Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at IS NOT NULL
	GROUP BY 
		user_id, invoice_id, item_name) count_item_same_invoice
GROUP BY 
  user_id, item_name 
HAVING 
  COUNT (item_name) =1 
