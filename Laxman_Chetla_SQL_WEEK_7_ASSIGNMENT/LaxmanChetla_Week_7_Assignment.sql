--ASSIGNMENT WEEK 7 (STORED PROCEDURES FOR SCD TYPES 0,1,2,3,4,6)
--NAME: LAXMAN CHETLA
--CSI ID: CT_CSI_SQ_1310
--CSI'25 BATCH 1 SQL DOMAIN



--STORED PROCEDURE FOR SCD 0(Immutable records)



CREATE PROCEDURE Insert_SCD_Type_0
    @Key INT,
    @Attribute1 VARCHAR(100),
    @Attribute2 VARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM DimExample WHERE Key = @Key)
    BEGIN
        INSERT INTO DimExample (Key, Attribute1, Attribute2)
        VALUES (@Key, @Attribute1, @Attribute2)
    END
END



--STORED PROCEDURE FOR SCD 1(OverWrite with the latest value)

CREATE PROCEDURE SCD_Type_1
    @Key INT,
    @Attribute1 VARCHAR(100),
    @Attribute2 VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DimExample WHERE Key = @Key)
    BEGIN
        UPDATE DimExample
        SET Attribute1 = @Attribute1,
            Attribute2 = @Attribute2,
            UpdatedDate = GETDATE()
        WHERE Key = @Key
    END
    ELSE
    BEGIN
        INSERT INTO DimExample (Key, Attribute1, Attribute2)
        VALUES (@Key, @Attribute1, @Attribute2)
    END
END





--STORED PROCEDURE FOR SCD 2(Historical versioning)

CREATE PROCEDURE Insert_SCD_Type_2
    @Key INT,
    @Attribute1 VARCHAR(100),
    @Attribute2 VARCHAR(100)
AS
BEGIN
    DECLARE @Today DATE = GETDATE()

    -- Expire existing version
    UPDATE DimExample
    SET EndDate = @Today,
        IsCurrent = 0,
        UpdatedDate = GETDATE()
    WHERE Key = @Key AND IsCurrent = 1

    -- Insert new version
    INSERT INTO DimExample (Key, Attribute1, Attribute2, StartDate, EndDate, IsCurrent)
    VALUES (@Key, @Attribute1, @Attribute2, @Today, NULL, 1)
END






--STORED PROCEDURE FOR SCD 3(maintaing new column for new value)

CREATE PROCEDURE Update_SCD_Type_3
    @Key INT,
    @NewValue VARCHAR(100)
AS
BEGIN
    DECLARE @OldValue VARCHAR(100)

    SELECT @OldValue = CurrentValue
    FROM DimExample
    WHERE Key = @Key

    UPDATE DimExample
    SET PreviousValue = @OldValue,
        CurrentValue = @NewValue,
        UpdatedDate = GETDATE()
    WHERE Key = @Key
END






--STORED PROCEDURE FOR SCD 4( update+maintain history table)

CREATE PROCEDURE Insert_SCD_Type_4
    @Key INT,
    @NewValue VARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DimExample WHERE Key = @Key)
    BEGIN
        INSERT INTO HistoryTable (Key, AttributeValue, ChangeDate)
        SELECT Key, Attribute1, GETDATE()
        FROM DimExample
        WHERE Key = @Key

        UPDATE DimExample
        SET Attribute1 = @NewValue,
            UpdatedDate = GETDATE()
        WHERE Key = @Key
    END
    ELSE
    BEGIN
        INSERT INTO DimExample (Key, Attribute1)
        VALUES (@Key, @NewValue)
    END
END






--STORED PROCEDURE FOR SCD 6(scd type1 +scd type2+scd type3)


CREATE PROCEDURE Update_SCD_Type_6
    @Key INT,
    @NewValue VARCHAR(100)
AS
BEGIN
    DECLARE @Today DATE = GETDATE()
    DECLARE @OldValue VARCHAR(100)

    -- Capture old value for Type 3
    SELECT @OldValue = CurrentValue
    FROM DimExample
    WHERE Key = @Key AND IsCurrent = 1

    -- Expire current record for Type 2
    UPDATE DimExample
    SET EndDate = @Today,
        IsCurrent = 0,
        UpdatedDate = GETDATE()
    WHERE Key = @Key AND IsCurrent = 1

    -- Insert new version combining all three types
    INSERT INTO DimExample (
        Key, CurrentValue, PreviousValue, StartDate, EndDate, IsCurrent, CreatedDate
    )
    VALUES (
        @Key, @NewValue, @OldValue, @Today, NULL, 1, GETDATE()
    )
END
