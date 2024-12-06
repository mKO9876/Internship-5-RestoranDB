CREATE TABLE Cities(
	CityId INT NOT NULL PRIMARY KEY, 
	CityName VARCHAR(100) NOT NULL
);

CREATE TABLE Menus(
	MenuId INT NOT NULL PRIMARY KEY,
	MenuName VARCHAR(30) NOT NULL
);

CREATE TABLE FoodCategories(
	CategoryId INT NOT NULL PRIMARY KEY, 
	CategoryName VARCHAR(15) NOT NULL
);

CREATE TABLE Food(
	FoodId INT NOT NULL PRIMARY KEY,
	FoodName VARCHAR(30) NOT NULL,
	FoodPrice DECIMAL(5, 2) NOT NULL,
	CategoryId INT REFERENCES FoodCategories(CategoryId) NOT NULL,
	Calories DECIMAL(7,2),
	Availability BOOL NOT NULL
);

CREATE TABLE MenuFood(
	MenuId INT REFERENCES Menus(MenuId),
	FoodId INT REFERENCES Food(FoodId),
	PRIMARY KEY (MenuId, FoodId)
);

CREATE TABLE Restaurants(
	RestaurantId INT NOT NULL PRIMARY KEY,
	RestaurantName VARCHAR(30) NOT NULL,
	Capacity INT NOT NULL, 
	CityId INT REFERENCES Cities(CityId),
	MenuId INT REFERENCES Menus(MenuId)
);

CREATE TABLE DaysOfWeek(
	DayId INT NOT NULL PRIMARY KEY,
	DayOfWeek VARCHAR(10)
);

CREATE TABLE RestaurantWorkingTime(
	DayId INT REFERENCES DaysOfWeek(DayId),
	RestaurantId INT REFERENCES Restaurants(RestaurantId),
	PRIMARY KEY(RestaurantId, DayId),
	StartTime TIME,
	EndTime TIME
);

CREATE TABLE Jobs(
	JobId INT NOT NULL PRIMARY KEY, 
	JobName VARCHAR(20) NOT NULL
);

CREATE TABLE Employees(
	EmployeeId INT NOT NULL PRIMARY KEY,
	EmployeeName VARCHAR(30),
	EmployeeLastName VARCHAR(30),
	RestaurantId INT REFERENCES Restaurants(RestaurantId),
	DriverLicense BOOL,
	Age INT,
	JobId INT REFERENCES Jobs(JobId)
);

CREATE TABLE Customers(
	CustomerId INT NOT NULL PRIMARY KEY,
	CustomerName VARCHAR(100) NOT NULL
);

CREATE TABLE Bills (
    BillId INT NOT NULL PRIMARY KEY, 
    CustomerId INT REFERENCES Customers(CustomerId), 
    RestaurantId INT REFERENCES Restaurants(RestaurantId), 
    OrderType VARCHAR(20) NOT NULL CHECK (OrderType IN ('Dostava', 'Konzumacija')),
    TotalPrice DECIMAL(10, 2) not null,
	EmployeeId INT REFERENCES Employees(EmployeeId),
    DeliveryTime TIMESTAMP, 
    DeliveryStars INT CHECK (DeliveryStars BETWEEN 1 AND 5),
    Adress VARCHAR(255),
    UserNote VARCHAR(255)
);


CREATE TABLE FoodBill (
    BillId INT REFERENCES Bills(BillId),
    FoodId INT REFERENCES Food(FoodId),
    Quantity INT NOT NULL,
    PRIMARY KEY (BillId, FoodId)
);

CREATE TABLE FoodRatings (
    FoodId INT REFERENCES Food(FoodId),
    CustomerId INT REFERENCES Customers(CustomerId),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    CustomerComment VARCHAR(255),
    PRIMARY KEY (FoodId, CustomerId)
);


CREATE TABLE LoyalityCards(
	CustomerId INT REFERENCES Customers(CustomerId),
	RestaurantId INT REFERENCES Restaurants(RestaurantId),
	PRIMARY KEY (CustomerId, RestaurantId),
	LoyalityCard BOOL NOT NULL
);

