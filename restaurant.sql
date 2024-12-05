CREATE TABLE Cities(
	CityId INT NOT NULL PRIMARY KEY, 
	CityName VARCHAR(30) NOT NULL
);

CREATE TABLE Menus(
	MenuId INT NOT NULL PRIMARY KEY
);

CREATE TABLE Restaurants(
	RestaurantId INT NOT NULL PRIMARY KEY,
	RestaurantName VARCHAR(30) NOT NULL,
	Capacity INT NOT NULL, 
	CityId INT REFERENCES Cities(CityId),
	MenuId INT REFERENCES Menu(MenuId)
);

CREATE TABLE FoodCategories(
	CategoryId INT NOT NULL PRIMARY KEY, 
	CategoryName VARCHAR(15) NOT NULL
);

CREATE TABLE Food(
	FoodId INT NOT NULL PRIMARY KEY,
	FoodName VARCHAR(30) NOT NULL,
	FoodPrice DEC(10, 2) NOT NULL,
	CategoryId INT REFERENCES FoodCategory(CategoryId) NOT NULL,
	Calories DEC(10,2),
	Availability BOOL NOT NULL
);

CREATE TABLE Jobs(
	JobId INT NOT NULL PRIMARY KEY, 
	JobName VARCHAR(20) NOT NULL
);

CREATE TABLE Employees(
	EmployeeId INT NOT NULL PRIMARY KEY,
	EmployeeName VARCHAR(30),
	EmployeeLastName VARCHAR(39),
	RestaurantId INT REFERENCES Restaurants(RestaurantId),
	JobId INT REFERENCES Jobs(JobId)
	 CHECK (
        (JobId = 3 AND DriverLicense = TRUE) OR
        (JobId <> 3 AND DriverLicense IS NULL)
    ),
    CHECK (
        (JobId IN (1, 2) AND Age >= 18) OR
        (JobId = 3 AND Age >= 18) 
    )
);

CREATE TABLE Customers(
	CustomerId INT NOT NULL PRIMARY KEY,
	CustomerName VARCHAR(20) NOT NULL,
	LoyalityCard BOOL NOT NULL
);

CREATE TABLE Deliverers(
	DelivererId INT NOT NULL PRIMARY KEY, 
	DelivererName VARCHAR(20),
	DelivererLastName VARCHAR(20)
);

CREATE TABLE Bills (
    BillId INT NOT NULL PRIMARY KEY, 
    CustomerId INT REFERENCES Customers(CustomerId), 
    RestaurantId INT REFERENCES Restaurants(RestaurantId), 
    OrderType VARCHAR(20) NOT NULL CHECK (OrderType IN ('Dostava', 'Konzumacija')),
    DelivererId INT REFERENCES Deliverers(DelivererId), 
    DeliveryTime DATETIME, 
    UserNote VARCHAR(255),
    IssuingTime DATETIME NOT NULL, 
    TotalPrice DECIMAL(10, 2) NOT NULL,
    CHECK (
        (OrderType = 'Dostava' AND DelivererId IS NOT NULL AND DeliveryTime IS NOT NULL) OR 
        (OrderType = 'Konzumacija' AND DelivererId IS NULL AND DeliveryTime IS NULL)
    )
);

CREATE TABLE MenuFood(
	MenuId INT REFERENCES Menus(MenuId),
	FoodId INT REFERENCES Food(FoodId),
	PRIMARY KEY (MenuId, FoodId)
);

CREATE TABLE BillFood (
    BillId INT REFERENCES Bills(BillId),
    FoodId INT REFERENCES Food(FoodId),
    Quantity INT NOT NULL,
    PRIMARY KEY (BillId, FoodId)
);