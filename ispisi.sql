--1
SELECT (FoodName, FoodPrice) FROM Food
	WHERE FoodPrice > 15;

--2
SELECT (TotalPrice, DeliveryTime) Bills
	WHERE EXTRACT(YEAR FROM DeliveryTime) = 2023 AND TotalPrice > 50;

--3
SELECT e.EmployeeName, e.EmployeeLastName, COUNT(b.BillId) AS SuccessfulDeliveries
FROM Employees e
JOIN Bills b ON e.EmployeeId = b.EmployeeId
WHERE e.JobId = (SELECT JobId FROM Jobs WHERE JobName = 'Deliverer')
GROUP BY e.EmployeeId
HAVING COUNT(b.BillId) > 100;

--4
SELECT e.EmployeeName, e.EmployeeLastName
FROM Employees e
JOIN Restaurants r ON e.RestaurantId = r.RestaurantId
JOIN Cities c ON r.CityId = c.CityId
WHERE e.JobId = (SELECT JobId FROM Jobs WHERE JobName = 'Cook')
  AND c.CityName = 'Zagreb';

--5
 SELECT r.RestaurantName, COUNT(b.BillId) AS OrderCount
FROM Restaurants r
JOIN Bills b ON r.RestaurantId = b.RestaurantId
JOIN Cities c ON r.CityId = c.CityId
WHERE c.CityName = 'Split'
  AND EXTRACT(YEAR FROM b.DeliveryTime) = 2023
GROUP BY r.RestaurantName;

--6
SELECT f.FoodName, SUM(fb.Quantity) AS TotalOrders
FROM Food f
JOIN FoodBills fb ON f.FoodId = fb.FoodId
JOIN FoodCategories fc ON f.CategoryId = fc.CategoryId
WHERE fc.CategoryName = 'Dessert'
  AND EXTRACT(MONTH FROM fb.BillId) = 12
  AND EXTRACT(YEAR FROM fb.BillId) = 2023
GROUP BY f.FoodName
HAVING SUM(fb.Quantity) > 10;


--7
SELECT COUNT(b.BillId) AS OrderCount
FROM Bills b
JOIN Customers c ON b.CustomerId = c.CustomerId
WHERE c.CustomerName LIKE 'M%';

--8
SELECT r.RestaurantName, AVG(b.DeliveryStars) AS AverageRating
FROM Restaurants r
JOIN Bills b ON r.RestaurantId = b.RestaurantId
JOIN Cities c ON r.CityId = c.CityId
WHERE c.CityName = 'Rijeka'
GROUP BY r.RestaurantName;

--9
SELECT r.RestaurantName
FROM Restaurants r
WHERE r.Capacity > 30
  AND EXISTS (
      SELECT 1
      FROM Bills b
      WHERE b.RestaurantId = r.RestaurantId
        AND b.OrderType = 'Dostava'
  );

--10
DELETE FROM MenuFood
WHERE FoodId IN (
    SELECT f.FoodId
    FROM Food f
    LEFT JOIN FoodBills fb ON f.FoodId = fb.FoodId
    LEFT JOIN Bills b ON fb.BillId = b.BillId
    WHERE b.DeliveryTime < CURRENT_DATE - INTERVAL '2 years' OR b.BillId IS NULL
);

--11
DELETE FROM LoyalityCards
WHERE CustomerId IN (
    SELECT lc.CustomerId
    FROM LoyalityCards lc
    LEFT JOIN Bills b ON lc.CustomerId = b.CustomerId
    WHERE b.DeliveryTime < CURRENT_DATE - INTERVAL '1 year' OR b.BillId IS NULL
);
