UPDATE Employees
    SET JobId = 3
    WHERE DriverLicense = TRUE;
	
UPDATE Employees
	SET JobId = 2
	WHERE Age >=18;

UPDATE Bills
    SET EmployeeId = NULL, DeliveryTime = NULL, DeliveryStars = NULL, Adress = NULL
    WHERE OrderType = 'Konzumacija';


UPDATE Bills
SET TotalPrice = (
    SELECT SUM(FB.Quantity * F.FoodPrice)
    FROM FoodBill FB
    JOIN Food F ON FB.FoodId = F.FoodId
    WHERE FB.BillId = Bills.BillId
);

INSERT INTO LoyalityCards (CustomerId, RestaurantId, LoyalityCard)
SELECT B.CustomerId, B.RestaurantId, TRUE
FROM Bills B
GROUP BY B.CustomerId, B.RestaurantId
HAVING SUM(B.TotalPrice) > 1000
ON CONFLICT (CustomerId, RestaurantId) 
DO UPDATE SET LoyalityCard = TRUE;
