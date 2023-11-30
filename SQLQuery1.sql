--1. ¬ивести вс≥ можлив≥ пари р€дк≥в викладач≥в та груп.

SELECT Teachers.Name AS [TeacherName], Teachers.Surname AS [TeacherSurname], Groups.Name AS [GroupName]
FROM Teachers
CROSS JOIN Groups;

--2. ¬ивести назви факультет≥в, фонд ф≥нансуванн€ кафедр €ких перевищуЇ фонд ф≥нансуванн€ факультету.

SELECT F1.Name AS [FacultyName]
FROM Faculties F1
WHERE EXISTS (
    SELECT 1
    FROM Departments D
    WHERE D.FacultyId = F1.Id
    GROUP BY D.FacultyId
    HAVING SUM(D.Financing) > F1.Financing
);

--3. ¬ивести пр≥звища куратор≥в груп та назви груп, €к≥ вони курирують.

SELECT Curators.Surname AS [CuratorSurname], Groups.Name AS [GroupName]
FROM Curators
JOIN GroupsCurators ON Curators.Id = GroupsCurators.CuratorId
JOIN Groups ON GroupsCurators.GroupId = Groups.Id;

--4. ¬ивести ≥мена та пр≥звища викладач≥в, €к≥ читають лекц≥њ у груп≥ УP107Ф.

SELECT DISTINCT Teachers.Name AS [TeacherName], Teachers.Surname AS [TeacherSurname]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId
JOIN Groups ON GroupsLectures.GroupId = Groups.Id
WHERE Groups.Name = 'P107';

--5. ¬ивести пр≥звища викладач≥в та назви факультет≥в, на €ких вони читають лекц≥њ.

SELECT Teachers.Surname AS [TeacherSurname], Faculties.Name AS [FacultyName]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
JOIN Departments ON Subjects.Id = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id;

--6. ¬ивести назви кафедр та назви груп, €к≥ до них належать.

SELECT Departments.Name AS [DepartmentName], Groups.Name AS [GroupName]
FROM Departments
JOIN Groups ON Departments.Id = Groups.DepartmentId;

--7. ¬ивести назви дисципл≥н, €к≥ читаЇ викладач УSamantha AdamsФ.

SELECT Subjects.Name AS [SubjectName]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
WHERE Teachers.Name = 'Samantha' AND Teachers.Surname = 'Adams';

--8. ¬ивести назви кафедр, де читаЇтьс€ дисципл≥на УDatabase TheoryФ.

SELECT Departments.Name AS [DepartmentName]
FROM Subjects
JOIN Lectures ON Subjects.Id = Lectures.SubjectId
JOIN Departments ON Lectures.TeacherId = Departments.Id
WHERE Subjects.Name = 'Database Theory';

--9. ¬ивести назви груп, що належать до факультету Computer Science.

SELECT Groups.Name AS [GroupName]
FROM Groups
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Faculties.Name = 'Computer Science';

--10. ¬ивести назви груп 5-го курсу, а також назву факультет≥в, до €ких вони належать.

SELECT Groups.Name AS [GroupName], Faculties.Name AS [FacultyName]
FROM Groups
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Groups.Year = 5;

--11. ¬ивести повн≥ ≥мена викладач≥в та лекц≥њ, €к≥ вони читають (назви дисципл≥н та груп), причому в≥д≥брати лише т≥ лекц≥њ, що читаютьс€ в аудитор≥њ УB103Ф.

SELECT Teachers.Name + ' ' + Teachers.Surname AS [FullTeacherName], Lectures.LectureRoom, Subjects.Name AS [SubjectName], Groups.Name AS [GroupName]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId
JOIN Groups ON GroupsLectures.GroupId = Groups.Id
WHERE Lectures.LectureRoom = 'B103';