--NAME:LAXMAN CHETLA
--Celebal intern CSI id :CT_CSI_SQ_1310 
--WEEK 5 ASSIGNMENT : STUDENT SUBJECT CHANGE REQUEST PROBLEM
--CREATED STORED PROCEDURE BELOW FOR THE GIVEN ASSIGNMENT






-- Create SubjectAllotments table
CREATE TABLE SubjectAllotments (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Is_Valid BIT
);

-- Insert sample data into SubjectAllotments
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid) VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

-- Create SubjectRequest table
CREATE TABLE SubjectRequest (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20)
);

-- Insert sample data into SubjectRequest
INSERT INTO SubjectRequest (StudentId, SubjectId) VALUES
('159103036', 'PO1496');





--STORED PROCEDURE TO SOLVE "CHANGE SUBJECT ALLOTMENT ROBLEM""

CREATE PROCEDURE UpdateSubjectAllotments
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StudentId VARCHAR(50);
    DECLARE @RequestedSubjectId VARCHAR(50);

    DECLARE request_cursor CURSOR FOR
    SELECT StudentId, SubjectId FROM SubjectRequest;

    OPEN request_cursor;
    FETCH NEXT FROM request_cursor INTO @StudentId, @RequestedSubjectId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = @StudentId)
        BEGIN
            DECLARE @CurrentSubjectId VARCHAR(50);
            SELECT @CurrentSubjectId = SubjectId 
            FROM SubjectAllotments 
            WHERE StudentId = @StudentId AND Is_Valid = 1;

            IF @CurrentSubjectId IS NULL OR @CurrentSubjectId <> @RequestedSubjectId
            BEGIN
                -- Invalidate current subject
                UPDATE SubjectAllotments
                SET Is_Valid = 0
                WHERE StudentId = @StudentId AND Is_Valid = 1;

                -- Insert new valid subject
                INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
                VALUES (@StudentId, @RequestedSubjectId, 1);
            END
        END
        ELSE
        BEGIN
            -- If no record exists, insert directly as valid
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
            VALUES (@StudentId, @RequestedSubjectId, 1);
        END

        FETCH NEXT FROM request_cursor INTO @StudentId, @RequestedSubjectId;
    END;

    CLOSE request_cursor;
    DEALLOCATE request_cursor;

    -- Optional: clear processed requests
    DELETE FROM SubjectRequest;
END;

--checking the Stored procedure for correctness

exec  UpdateSubjectAllotments;

select * from SubjectAllotments;
