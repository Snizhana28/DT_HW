--1. ������� �� ������ ���� ����� ���������� �� ����.

SELECT Teachers.Name AS [TeacherName], Teachers.Surname AS [TeacherSurname], Groups.Name AS [GroupName]
FROM Teachers
CROSS JOIN Groups;

--2. ������� ����� ����������, ���� ������������ ������ ���� �������� ���� ������������ ����������.

SELECT F1.Name AS [FacultyName]
FROM Faculties F1
WHERE EXISTS (
    SELECT 1
    FROM Departments D
    WHERE D.FacultyId = F1.Id
    GROUP BY D.FacultyId
    HAVING SUM(D.Financing) > F1.Financing
);

--3. ������� ������� �������� ���� �� ����� ����, �� ���� ���������.

SELECT Curators.Surname AS [CuratorSurname], Groups.Name AS [GroupName]
FROM Curators
JOIN GroupsCurators ON Curators.Id = GroupsCurators.CuratorId
JOIN Groups ON GroupsCurators.GroupId = Groups.Id;

--4. ������� ����� �� ������� ����������, �� ������� ������ � ���� �P107�.

SELECT DISTINCT Teachers.Name AS [TeacherName], Teachers.Surname AS [TeacherSurname]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId
JOIN Groups ON GroupsLectures.GroupId = Groups.Id
WHERE Groups.Name = 'P107';

--5. ������� ������� ���������� �� ����� ����������, �� ���� ���� ������� ������.

SELECT Teachers.Surname AS [TeacherSurname], Faculties.Name AS [FacultyName]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
JOIN Departments ON Subjects.Id = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id;

--6. ������� ����� ������ �� ����� ����, �� �� ��� ��������.

SELECT Departments.Name AS [DepartmentName], Groups.Name AS [GroupName]
FROM Departments
JOIN Groups ON Departments.Id = Groups.DepartmentId;

--7. ������� ����� ��������, �� ���� �������� �Samantha Adams�.

SELECT Subjects.Name AS [SubjectName]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
WHERE Teachers.Name = 'Samantha' AND Teachers.Surname = 'Adams';

--8. ������� ����� ������, �� �������� ��������� �Database Theory�.

SELECT Departments.Name AS [DepartmentName]
FROM Subjects
JOIN Lectures ON Subjects.Id = Lectures.SubjectId
JOIN Departments ON Lectures.TeacherId = Departments.Id
WHERE Subjects.Name = 'Database Theory';

--9. ������� ����� ����, �� �������� �� ���������� Computer Science.

SELECT Groups.Name AS [GroupName]
FROM Groups
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Faculties.Name = 'Computer Science';

--10. ������� ����� ���� 5-�� �����, � ����� ����� ����������, �� ���� ���� ��������.

SELECT Groups.Name AS [GroupName], Faculties.Name AS [FacultyName]
FROM Groups
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Groups.Year = 5;

--11. ������� ���� ����� ���������� �� ������, �� ���� ������� (����� �������� �� ����), ������� ������� ���� � ������, �� ��������� � ������� �B103�.

SELECT Teachers.Name + ' ' + Teachers.Surname AS [FullTeacherName], Lectures.LectureRoom, Subjects.Name AS [SubjectName], Groups.Name AS [GroupName]
FROM Teachers
JOIN Lectures ON Teachers.Id = Lectures.TeacherId
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
JOIN GroupsLectures ON Lectures.Id = GroupsLectures.LectureId
JOIN Groups ON GroupsLectures.GroupId = Groups.Id
WHERE Lectures.LectureRoom = 'B103';