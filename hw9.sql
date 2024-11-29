-- Створення бази даних
CREATE DATABASE Hospital;
GO

-- Перехід до створеної бази даних
USE Hospital;
GO

-- Створення таблиці Departments
CREATE TABLE Departments (
    Id INT IDENTITY PRIMARY KEY,
    BuildingNumber INT NOT NULL CHECK (BuildingNumber BETWEEN 1 AND 5),
    Funding MONEY NOT NULL DEFAULT 0 CHECK (Funding >= 0),
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE
);

-- Створення таблиці Diseases
CREATE TABLE Diseases (
    Id INT IDENTITY PRIMARY KEY,
    DiseaseName NVARCHAR(100) NOT NULL UNIQUE,
    SeverityLevel INT NOT NULL DEFAULT 1 CHECK (SeverityLevel >= 1)
);

-- Створення таблиці Doctors
CREATE TABLE Doctors (
    Id INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    PhoneNumber CHAR(10),
    BaseSalary MONEY NOT NULL CHECK (BaseSalary > 0),
    Bonus MONEY NOT NULL DEFAULT 0
);

-- Створення таблиці Examinations
CREATE TABLE Examinations (
    Id INT IDENTITY PRIMARY KEY,
    ExaminationName NVARCHAR(100) NOT NULL UNIQUE,
    DayOfWeek INT NOT NULL CHECK (DayOfWeek BETWEEN 1 AND 7),
    StartTime TIME NOT NULL CHECK (StartTime >= '08:00' AND StartTime <= '18:00'),
    EndTime TIME NOT NULL CHECK (EndTime > StartTime)
);

-- Створення таблиці Wards
CREATE TABLE Wards (
    Id INT IDENTITY PRIMARY KEY,
    BuildingNumber INT NOT NULL CHECK (BuildingNumber BETWEEN 1 AND 5),
    FloorNumber INT NOT NULL CHECK (FloorNumber >= 1),
    WardName NVARCHAR(20) NOT NULL UNIQUE
);

-- Вставка даних у таблицю Departments
INSERT INTO Departments (BuildingNumber, Funding, DepartmentName) VALUES
(1, 18000, 'Therapy'),
(3, 25000, 'Surgery'),
(5, 32000, 'Oncology');

-- Вставка даних у таблицю Diseases
INSERT INTO Diseases (DiseaseName, SeverityLevel) VALUES
('Common Cold', 1),
('Hepatitis', 4),
('Asthma', 3);

-- Вставка даних у таблицю Doctors
INSERT INTO Doctors (FirstName, LastName, PhoneNumber, BaseSalary, Bonus) VALUES
('Alice', 'Johnson', '1234567890', 1900, 400),
('Bob', 'Taylor', '0987654321', 2200, 600),
('Nina', 'Brown', NULL, 1500, 200);

-- Вставка даних у таблицю Examinations
INSERT INTO Examinations (ExaminationName, DayOfWeek, StartTime, EndTime) VALUES
('Ultrasound', 1, '10:00', '11:30'),
('CT Scan', 2, '13:00', '14:30'),
('Blood Pressure Check', 3, '08:30', '09:00');

-- Вставка даних у таблицю Wards
INSERT INTO Wards (BuildingNumber, FloorNumber, WardName) VALUES
(4, 1, 'Ward X'),
(5, 2, 'Ward Y'),
(3, 3, 'Ward Z');

-- 1. Вивести вміст таблиці палат
SELECT * FROM Wards;

-- 2. Вивести прізвища та телефони всіх лікарів
SELECT LastName, PhoneNumber FROM Doctors;

-- 3. Вивести всі поверхи без повторень, де розміщуються палати
SELECT DISTINCT FloorNumber FROM Wards;

-- 4. Вивести назви захворювань та їхню тяжкість
SELECT DiseaseName AS [Name of Disease], SeverityLevel AS [Severity of Disease] FROM Diseases;

-- 5. Використання псевдонімів для трьох таблиць
SELECT d.FirstName AS Doctor, e.ExaminationName AS Examination, w.WardName AS Ward
FROM Doctors d
JOIN Examinations e ON d.Id = e.Id
JOIN Wards w ON e.Id = w.Id;

-- 6. Назви відділень у корпусі 5 з фондом меншим за 30000
SELECT DepartmentName FROM Departments WHERE BuildingNumber = 5 AND Funding < 30000;

-- 7. Відділення корпусу 3 з фондом від 12000 до 15000
SELECT DepartmentName FROM Departments WHERE BuildingNumber = 3 AND Funding BETWEEN 12000 AND 15000;

-- 8. Назви палат у корпусах 4 та 5 на 1 поверсі
SELECT WardName FROM Wards WHERE BuildingNumber IN (4, 5) AND FloorNumber = 1;

-- 9. Відділення корпусів 3 або 6, фонд <11000 або >25000
SELECT DepartmentName, BuildingNumber, Funding
FROM Departments
WHERE BuildingNumber IN (3, 6) AND (Funding < 11000 OR Funding > 25000);

-- 10. Прізвища лікарів, зарплата яких > 1500
SELECT LastName
FROM Doctors
WHERE BaseSalary + Bonus > 1500;

-- 11. Прізвища лікарів, у яких половина зарплати перевищує триразову надбавку
SELECT LastName
FROM Doctors
WHERE (BaseSalary / 2) > (Bonus * 3);

-- 12. Назви обстежень у перші 3 дні тижня з 12:00 до 15:00
SELECT DISTINCT ExaminationName
FROM Examinations
WHERE DayOfWeek BETWEEN 1 AND 3 AND StartTime >= '12:00' AND EndTime <= '15:00';

-- 13. Відділення корпусів 1, 3, 8, або 10
SELECT DepartmentName, BuildingNumber
FROM Departments
WHERE BuildingNumber IN (1, 3, 8, 10);

-- 14. Захворювання всіх ступенів тяжкості, крім 1 і 2
SELECT DiseaseName
FROM Diseases
WHERE SeverityLevel NOT IN (1, 2);

-- 15. Відділення, які не знаходяться в корпусах 1 або 3
SELECT DepartmentName
FROM Departments
WHERE BuildingNumber NOT IN (1, 3);

-- 16. Відділення корпусів 1 або 3
SELECT DepartmentName
FROM Departments
WHERE BuildingNumber IN (1, 3);

-- 17. Прізвища лікарів, що починаються на "N"
SELECT LastName
FROM Doctors
WHERE LastName LIKE 'N%';
