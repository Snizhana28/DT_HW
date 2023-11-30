CREATE DATABASE [Academy]
go
USE [Academy]
go

CREATE TABLE [Faculties] (
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT CHK_Faculty_Name_NotEmpty CHECK (LEN([Name]) > 0)
);

CREATE TABLE [Departments] (
    [Id] INT PRIMARY KEY IDENTITY,
    [Financing] MONEY NOT NULL DEFAULT 0,
    [Name] NVARCHAR(100) NOT NULL UNIQUE,
    [FacultyId] INT NOT NULL,
    CONSTRAINT CHK_Department_Financing_NonNegative CHECK ([Financing] >= 0),
    CONSTRAINT FK_Department_Faculty FOREIGN KEY ([FacultyId]) REFERENCES [Faculties]([Id])
);

CREATE TABLE [Groups] (
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(10) NOT NULL UNIQUE,
    [Year] INT NOT NULL CHECK ([Year] BETWEEN 1 AND 5),
    [DepartmentId] INT NOT NULL,
    CONSTRAINT FK_Group_Department FOREIGN KEY ([DepartmentId]) REFERENCES [Departments]([Id])
);

CREATE TABLE [Lectures] (
    [Id] INT PRIMARY KEY IDENTITY,
    [DayOfWeek] INT NOT NULL CHECK ([DayOfWeek] BETWEEN 1 AND 7),
    [LectureRoom] NVARCHAR(MAX) NOT NULL,
    [SubjectId] INT NOT NULL,
    [TeacherId] INT NOT NULL,
    CONSTRAINT FK_Lecture_Subject FOREIGN KEY ([SubjectId]) REFERENCES [Subjects]([Id]),
    CONSTRAINT FK_Lecture_Teacher FOREIGN KEY ([TeacherId]) REFERENCES [Teachers]([Id])
);

CREATE TABLE [Subjects] (
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT CHK_Subject_Name_NotEmpty CHECK (LEN([Name]) > 0)
);

CREATE TABLE [Teachers] (
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(MAX) NOT NULL,
    [Salary] MONEY NOT NULL CHECK ([Salary] >= 0),
    [Surname] NVARCHAR(MAX) NOT NULL,
	[DepartmentId] INT NOT NULL,
    CONSTRAINT CHK_Teacher_Name_NotEmpty CHECK (LEN([Name]) > 0),
    CONSTRAINT CHK_Teacher_Surname_NotEmpty CHECK (LEN([Surname]) > 0)
);

CREATE TABLE [GroupsLectures] (
    [Id] INT PRIMARY KEY IDENTITY,
    [GroupId] INT NOT NULL,
    [LectureId] INT NOT NULL,
    CONSTRAINT FK_GroupsLectures_Group FOREIGN KEY ([GroupId]) REFERENCES [Groups]([Id]),
    CONSTRAINT FK_GroupsLectures_Lecture FOREIGN KEY ([LectureId]) REFERENCES [Lectures]([Id])
);

INSERT INTO [Faculties] ([Name]) VALUES
    ('Computer Science'),
    ('Software Development');

INSERT INTO [Departments] ([Financing], [Name], [FacultyId]) VALUES
    (50000, 'CS Department', 1),
    (60000, 'Software Development Department', 2);

INSERT INTO [Groups] ([Name], [Year], [DepartmentId]) VALUES
    ('CS101', 1, 1),
    ('SD101', 1, 2),
    ('CS201', 2, 1),
    ('SD201', 2, 2);

INSERT INTO [Subjects] ([Name]) VALUES
    ('Database Management'),
    ('Software Engineering'),
    ('Algorithms');

INSERT INTO [Teachers] ([Name], [Salary], [Surname], [DepartmentId]) VALUES
    ('Dave McQueen', 60000, 'McQueen0', 1),
    ('Jack Underhill', 70000, 'Underhill', 2);

INSERT INTO [Lectures] ([DayOfWeek], [LectureRoom], [SubjectId], [TeacherId]) VALUES
    (1, 'D201', 1, 1),
    (2, 'D202', 2, 2),
    (3, 'D203', 3, 1);

INSERT INTO [GroupsLectures] ([GroupId], [LectureId]) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 3);

-- 1. Кількість викладачів кафедри «Software Development».
SELECT COUNT(*) AS TeacherCount
FROM Teachers t
JOIN Departments d ON t.DepartmentId = d.Id
JOIN Faculties f ON d.FacultyId = f.Id
WHERE f.Name = 'Software Development';

-- 2. Кількість лекцій, які читає викладач “Dave McQueen”.
SELECT COUNT(*) AS LectureCount
FROM Lectures
WHERE TeacherId = (SELECT Id FROM Teachers WHERE [Name] = 'Dave McQueen');

-- 3. Кількість занять, які проводяться в аудиторії “D201”.
SELECT COUNT(*) AS LectureCount
FROM Lectures
WHERE LectureRoom = 'D201';

-- 4. Назви аудиторій та кількість лекцій, що проводяться в них.
SELECT LectureRoom, COUNT(*) AS LectureCount
FROM Lectures
GROUP BY LectureRoom;

-- 5. Кількість студентів, які відвідують лекції викладача “Jack Underhill”.
SELECT COUNT(DISTINCT gl.GroupId) AS StudentCount
FROM GroupsLectures gl
JOIN Lectures l ON gl.LectureId = l.Id
JOIN Teachers t ON l.TeacherId = t.Id
WHERE t.[Name] = 'Jack Underhill';

-- 6. Середня ставка викладачів факультету Computer Science.
SELECT AVG(Salary) AS AverageSalary
FROM Teachers t
JOIN Departments d ON t.DepartmentId = d.Id
JOIN Faculties f ON d.FacultyId = f.Id
WHERE f.Name = 'Computer Science';

-- 7. Мінімальна та максимальна кількість студентів серед усіх груп.
SELECT MIN(StudentCount) AS MinStudentCount, MAX(StudentCount) AS MaxStudentCount
FROM (SELECT GroupId, COUNT(*) AS StudentCount FROM GroupsLectures GROUP BY GroupId) AS Counts;

-- 8. Середній фонд фінансування кафедр.
SELECT AVG(Financing) AS AverageFinancing
FROM Departments;

-- 9. Повні імена викладачів та кількість читаних ними дисциплін.
SELECT t.[Name] + ' ' + t.Surname AS FullName, COUNT(DISTINCT l.SubjectId) AS SubjectsTaught
FROM Teachers t
JOIN Lectures l ON t.Id = l.TeacherId
GROUP BY t.[Name], t.Surname;

-- 10. Кількість лекцій щодня протягом тижня.
SELECT DayOfWeek, COUNT(*) AS LectureCount
FROM Lectures
GROUP BY DayOfWeek;

-- 11. Номери аудиторій та кількість кафедр, чиї лекції в них читаються.
SELECT l.LectureRoom, COUNT(DISTINCT d.Id) AS DepartmentsCount
FROM Lectures l
JOIN Departments d ON l.TeacherId = d.Id
GROUP BY l.LectureRoom;

-- 12. Назви факультетів та кількість дисциплін, які на них читаються.
SELECT f.[Name] AS FacultyName, COUNT(DISTINCT l.SubjectId) AS SubjectsTaught
FROM Faculties f
JOIN Departments d ON f.Id = d.FacultyId
JOIN Groups g ON d.Id = g.DepartmentId
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON gl.LectureId = l.Id
GROUP BY f.[Name];

-- 13. Кількість лекцій для кожної пари викладач-аудиторія.
SELECT t.[Name] + ' ' + t.Surname AS TeacherFullName, l.LectureRoom, COUNT(*) AS LectureCount
FROM Lectures l
JOIN Teachers t ON l.TeacherId = t.Id
GROUP BY t.[Name], t.Surname, l.LectureRoom;