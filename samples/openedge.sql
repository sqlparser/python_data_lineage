-- openedge sample sql

CREATE VIEW ne_customers AS
SELECT name, address, city, state
FROM customer
WHERE state IN ( 'NH', 'MA', 'ME', 'RI', 'CT', 'VT' )
WITH CHECK OPTION ;

INSERT INTO neworders (order_no, product, qty)
SELECT order_no, product, qty
FROM orders
WHERE order_date = SYSDATE ;

UPDATE OrderLine
SET (ItemNum, Price) =
(SELECT ItemNum, Price * 3
FROM Item
WHERE ItemName = 'gloves')
WHERE OrderNum = 21 ;

Update Orderline
SET (Itemnum) =
(Select Itemnum
FROM Item
WHERE Itemname = 'Tennis balls')
WHERE Ordernum = 20;