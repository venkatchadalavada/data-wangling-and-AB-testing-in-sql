--Final assignment data wangling and AB testing report
--Note: Using Postgresql 


-Note: for the report and analysis summary and study, refer to Final assignment data wangling and AB testing .doc

--Query code

--Question 1

SELECT 
  count (*) as count_items,
  count (test_a) as test_a,
  count (test_b) as test_b,
  count (test_b) as test_c,
  count (test_b) as test_d,
  count (test_b) as test_e,
  count (test_b) as test_f
FROM 
  dsv1069.final_assignments_qa
  

--Question 2

SELECT
*
FROM
(
  SELECT 
    item_id,
    MAX (CASE WHEN test_a = '1' THEN '1'
    ELSE '0'
    END) AS test_assignment,
    MAX (CASE WHEN item_id is NOT NULL THEN 'item_test_1'
    ELSE NULL
    END) as test_number,
    max (CASE WHEN item_id is NOT NULL THEN '2013-01-05 00:00'::timestamp
    ELSE NULL
    END) AS test_start_date
  FROM
    dsv1069.final_assignments_qa
  GROUP BY item_id

UNION 

  SElECT
    item_id,
    max (CASE WHEN test_b = '1' THEN '1'
    ELSE '0'
    END) as test_assignment,
    max (CASE WHEN item_id is NOT NULL THEN 'item_test_2'
    ELSE NULL
    END) AS test_number,
    max (CASE WHEN item_id is NOT NULL THEN '2015-03-14 00:00'::timestamp
    ELSE NULL
    END) AS test_start_date
  FROM
    dsv1069.final_assignments_qa
  GROUP BY item_id 

UNION 

  (SELECT 
    item_id,
    max (CASE WHEN test_c = '1' THEN '1'
    ELSE '0'
    END) AS test_assignment,
    max (CASE WHEN item_id is NOT NULL THEN 'item_test_3'
    ELSE NULL
    END) as test_number,
    max (CASE WHEN item_id is NOT NULL THEN '2016-01-07 00:00'::timestamp
    ELSE NULL
    END) AS test_start_date
  FROM
    dsv1069.final_assignments_qa
  GROUP BY item_id)

)  AS union_test_number


--Question 3

SELECT
  test_assignment,
  COUNT (test_assignment) as count_n,
  SUM (binary_order) as binary_count,
  SUM (binary_order_30days) as binary_count_30days
FROM
(
  SELECT 
    final_assignments.item_id,
    test_assignment, 
    max (CASE WHEN created_at>test_start_date THEN 1 ELSE 0 END) AS binary_order,
    max (CASE WHEN (created_at>test_start_date AND date_part ('day', created_at - test_start_date) <= 30) THEN 1 ELSE 0 END) AS binary_order_30days
  FROM
    dsv1069.final_assignments
  LEFT OUTER JOIN
    dsv1069.orders
  ON dsv1069.final_assignments.item_id = dsv1069.orders.item_id
  WHERE test_number = 'item_test_2'
  GROUP BY final_assignments.item_id, test_assignment) item_level
GROUP BY test_assignment


--Question 4

SELECT
  test_assignment,
  COUNT (test_assignment) AS count_n,
  SUM (binary_order) AS binary_count,
  SUM (binary_order_30days) AS binary_count_30days
FROM 
(
  SELECT 
  final_assignments.item_id,
  test_assignment, 
  MAX (CASE WHEN event_time>test_start_date THEN 1 ELSE 0 END) AS binary_order,
  MAX (CASE WHEN (event_time>test_start_date AND date_part ('day', event_time - test_start_date) <= 30) THEN 1 ELSE 0 END) AS binary_order_30days
  FROM
    dsv1069.final_assignments
  LEFT OUTER JOIN
  
  (
    SELECT 
      event_id, event_time, 
      MAX (CASE WHEN parameter_name = 'item_id' THEN cast (parameter_value AS int) ELSE NULL END) AS item_id
    FROM 
      dsv1069.events
    WHERE event_name = 'view_item'  AND parameter_name = 'item_id'
    GROUP BY event_id, event_time ) view_item
  
  ON dsv1069.final_assignments.item_id = view_item.item_id
  WHERE test_number = 'item_test_2'
  GROUP  BY final_assignments.item_id, test_assignment) item_level
GROUP  BY test_assignment