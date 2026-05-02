-- INSERTION: (PL/SQL loops used to generate large-scale consistent data)

-- MIGRANT TABLE
BEGIN
FOR i IN 1..150 LOOP
    INSERT INTO Migrant VALUES (
        i,
        'Migrant_' || i,
        CASE WHEN MOD(i,2)=0 THEN 'Male' ELSE 'Female' END,
        CASE 
            WHEN MOD(i,4)=0 THEN 'Bihar'
            WHEN MOD(i,4)=1 THEN 'UP'
            WHEN MOD(i,4)=2 THEN 'Odisha'
            ELSE 'West Bengal'
        END,
        'District_' || i,
        TO_CHAR(100000000000 + i),
        TO_CHAR(9000000000 + i),
        DATE '2025-01-01' + MOD(i,60)
    );
END LOOP;
END;
/

-- Static entities like kiln and admin are kept limited

-- KILN TABLE
INSERT ALL
INTO Kiln VALUES (101, 'Punjab - Ludhiana', 'Sharma Bricks', 320)
INTO Kiln VALUES (102, 'Punjab - Patiala', 'Verma Kiln', 300)
INTO Kiln VALUES (103, 'Haryana - Ambala', 'Singh Kiln', 310)
INTO Kiln VALUES (104, 'Punjab - Amritsar', 'Gill Kiln', 330)
INTO Kiln VALUES (105, 'Haryana - Karnal', 'Malik Kiln', 310)
SELECT * FROM dual;

-- ADMIN TABLE
INSERT ALL
INTO Admin VALUES (1, 'Anil Sharma', 'NGO', 'Inspector')
INTO Admin VALUES (2, 'Neha Verma', 'Government', 'Labour Officer')
INTO Admin VALUES (3, 'Rajiv Kumar', 'NGO', 'Auditor')
SELECT * FROM dual;

-- CHILD TABLE
BEGIN
FOR i IN 1..120 LOOP
    INSERT INTO Child VALUES (
        i,
        'Child_' || i,
        6 + MOD(i,10),
        TO_CHAR(1 + MOD(i,8)) || 'th',
        'Govt School ' || MOD(i,50),
        CASE WHEN MOD(i,4)=0 THEN 'Dropped' ELSE 'Enrolled' END,
        MOD(i,150) + 1   -- FIXED
    );
END LOOP;
END;
/

-- SHIFT TABLE
BEGIN
FOR i IN 1..300 LOOP
    INSERT INTO Shift VALUES (
        i,
        DATE '2026-04-01' + MOD(i,30),
        DATE '2026-04-01' + MOD(i,30),
        6 + MOD(i,5),
        CASE WHEN MOD(i,2)=0 THEN 'Day' ELSE 'Night' END,
        MOD(i,150)+1,
        101 + MOD(i,5)
    );
END LOOP;
END;
/

-- WAGE TABLE
BEGIN
FOR i IN 1..300 LOOP
    INSERT INTO Wage VALUES (
        i,
        300 + MOD(i,200),
        MOD(i,150),
        300,
        CASE WHEN MOD(i,3)=0 THEN 'Unpaid' ELSE 'Paid' END,
        i
    );
END LOOP;
END;
/

-- AUDIT_LOG TABLE
BEGIN
FOR i IN 1..30 LOOP
    INSERT INTO Audit_Log VALUES (
        i,
        SYSDATE - i,
        'Inspection Report ' || i,
        MOD(i,2)+1,
        101 + MOD(i,5)
    );
END LOOP;
END;
/