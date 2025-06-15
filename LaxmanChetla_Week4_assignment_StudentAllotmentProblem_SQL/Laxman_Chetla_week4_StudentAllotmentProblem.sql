--CHETLA LAXMAN
--Celebal technologies SQL internship 2025 id: CT_CSI_SQ_1310
--WEEK 4 Task:Student Allotment Problem







--REQUIRED TABLES FOR THE STORED PROCEDURE DATA

CREATE TABLE StudentDetails (
    StudentId INT PRIMARY KEY,
    StudentName VARCHAR(100),
    GPA DECIMAL(4, 2),
    Branch VARCHAR(50),
    Section CHAR(1)
);
--sample data to insert in studenty details
INSERT INTO StudentDetails (StudentId, StudentName, GPA, Branch, Section) VALUES
(159104001, 'Anjali Mehta', 9.5, 'CSE', 'A'),
(159104002, 'Karan Sharma', 8.3, 'CSE', 'B'),
(159104003, 'Neha Yadav', 6.2, 'CSE', 'A'),
(159104004, 'Aman Gupta', 7.9, 'CSE', 'A'),
(159104005, 'Ritika Verma', 8.7, 'CSE', 'B'),
(159104006, 'Rohan Jain', 5.6, 'CSE', 'A');


CREATE TABLE SubjectDetails (
    SubjectId VARCHAR(10) PRIMARY KEY,
    SubjectName VARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);
--sample data to insert in subject details
INSERT INTO SubjectDetails (SubjectId, SubjectName, MaxSeats, RemainingSeats) VALUES
('PO2001', 'Data Journalism', 50, 50),
('PO2002', 'Blockchain Basics', 40, 40),
('PO2003', 'AI and Ethics', 60, 60),
('PO2004', 'Design Thinking', 45, 45),
('PO2005', 'Cyber Law', 30, 30);


CREATE TABLE StudentPreference (
    StudentId INT,
    SubjectId VARCHAR(10),
    Preference INT,
    PRIMARY KEY (StudentId, Preference),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);
--Sample student preferences for checking the stored procedure
-- Anjali Mehta
INSERT INTO StudentPreference VALUES
(159104001, 'PO2001', 1),
(159104001, 'PO2002', 2),
(159104001, 'PO2003', 3),
(159104001, 'PO2004', 4),
(159104001, 'PO2005', 5);

-- Karan Sharma
INSERT INTO StudentPreference VALUES
(159104002, 'PO2003', 1),
(159104002, 'PO2001', 2),
(159104002, 'PO2004', 3),
(159104002, 'PO2005', 4),
(159104002, 'PO2002', 5);

-- Neha Yadav
INSERT INTO StudentPreference VALUES
(159104003, 'PO2005', 1),
(159104003, 'PO2003', 2),
(159104003, 'PO2001', 3),
(159104003, 'PO2004', 4),
(159104003, 'PO2002', 5);

-- Aman Gupta
INSERT INTO StudentPreference VALUES
(159104004, 'PO2002', 1),
(159104004, 'PO2003', 2),
(159104004, 'PO2005', 3),
(159104004, 'PO2001', 4),
(159104004, 'PO2004', 5);

-- Ritika Verma
INSERT INTO StudentPreference VALUES
(159104005, 'PO2004', 1),
(159104005, 'PO2002', 2),
(159104005, 'PO2003', 3),
(159104005, 'PO2001', 4),
(159104005, 'PO2005', 5);

-- Rohan Jain
INSERT INTO StudentPreference VALUES
(159104006, 'PO2005', 1),
(159104006, 'PO2004', 2),
(159104006, 'PO2001', 3),
(159104006, 'PO2002', 4),
(159104006, 'PO2003', 5);


CREATE TABLE Allotments (
    SubjectId VARCHAR(10),
    StudentId INT,
    PRIMARY KEY (SubjectId, StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);

CREATE TABLE UnallotedStudents (
    StudentId INT PRIMARY KEY,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);


--STORED PROCEDUIRE FOR STUDENT ALLOTMENT PROBLEM

 go
ALTER PROCEDURE AllocateSubjects
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sid INT;                    -- Student ID
    DECLARE @subj_id VARCHAR(10);        -- Subject ID
    DECLARE @pref INT;                   -- Preference number (1 to 5)
    DECLARE @seat_cnt INT;               -- Remaining seats in subject
    DECLARE @is_allotted BIT;            -- Flag if student was allotted

    -- Cursor to fetch students ordered by GPA descending
    DECLARE cur_students CURSOR FOR
        SELECT StudentId FROM StudentDetails ORDER BY GPA DESC;

    OPEN cur_students;
    FETCH NEXT FROM cur_students INTO @sid;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @is_allotted = 0;
        SET @pref = 1;

        -- Loop through preferences 1 to 5
        WHILE @pref <= 5 AND @is_allotted = 0
        BEGIN
            -- Get the SubjectId for this student's preference
            SELECT @subj_id = SubjectId
            FROM StudentPreference
            WHERE StudentId = @sid AND Preference = @pref;

            -- If the subject exists, check if seats are available
            IF @subj_id IS NOT NULL
            BEGIN
                SELECT @seat_cnt = RemainingSeats
                FROM SubjectDetails
                WHERE SubjectId = @subj_id;

                IF @seat_cnt IS NOT NULL AND @seat_cnt > 0
                BEGIN
                    -- Allot the subject to the student
                    INSERT INTO Allotments (SubjectId, StudentId)
                    VALUES (@subj_id, @sid);

                    -- Decrease remaining seat count
                    UPDATE SubjectDetails
                    SET RemainingSeats = RemainingSeats - 1
                    WHERE SubjectId = @subj_id;

                    -- Mark student as allotted
                    SET @is_allotted = 1;
                END
            END

            SET @pref = @pref + 1;
        END

        -- If student wasn't allotted any subject, add to unallotted
        IF @is_allotted = 0
        BEGIN
            INSERT INTO UnallotedStudents (StudentId)
            VALUES (@sid);
        END

        FETCH NEXT FROM cur_students INTO @sid;
    END

    CLOSE cur_students;
    DEALLOCATE cur_students;
END;
go







-- checking for output :
select * from StudentDetails;
select * from SubjectDetails;
select * from StudentPreference;

exec AllocateSubjects;

select * from Allotments;
select * from UnallotedStudents;