-- DROP added to Remove all existing tables, Reset database to fresh state, Avoid hidden errors
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Wage CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Shift CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Child CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Audit_Log CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Admin CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Kiln CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Migrant CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- TABLES CREATION:

-- MIGRANT TABLE
CREATE TABLE Migrant (
    migrant_id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    gender VARCHAR2(10),
    state VARCHAR2(30),
    home_district VARCHAR2(50),
    aadhaar_no VARCHAR2(12) UNIQUE NOT NULL,
    phone VARCHAR2(10),
    registration_date DATE DEFAULT SYSDATE
);

-- KILN TABLE
CREATE TABLE Kiln (
    kiln_id NUMBER PRIMARY KEY,
    location VARCHAR2(50) NOT NULL,
    owner_name VARCHAR2(50),
    min_wage NUMBER CHECK (min_wage > 0)
);

-- ADMIN TABLE
CREATE TABLE Admin (
    admin_id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    organization VARCHAR2(50),
    role VARCHAR2(30)
);

-- CHILD TABLE
CREATE TABLE Child (
    child_id NUMBER PRIMARY KEY,
    child_name VARCHAR2(50) NOT NULL,
    age NUMBER CHECK (age >= 0),
    class_last_attended VARCHAR2(20),
    school_name VARCHAR2(50),
    enrollment_status VARCHAR2(20),
    migrant_id NUMBER,
    
    CONSTRAINT fk_child_migrant 
    FOREIGN KEY (migrant_id) 
    REFERENCES Migrant(migrant_id)
    ON DELETE CASCADE
);

-- SHIFT TABLE
CREATE TABLE Shift (
    shift_id NUMBER PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE,
    hours_worked NUMBER CHECK (hours_worked >= 0),
    shift_type VARCHAR2(20),
    migrant_id NUMBER,
    kiln_id NUMBER,
    
    CONSTRAINT fk_shift_migrant 
    FOREIGN KEY (migrant_id) REFERENCES Migrant(migrant_id),
    
    CONSTRAINT fk_shift_kiln 
    FOREIGN KEY (kiln_id) REFERENCES Kiln(kiln_id),
    
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
); 

-- WAGE TABLE
CREATE TABLE Wage (
    wage_id NUMBER PRIMARY KEY,
    amount NUMBER,
    advance_paid NUMBER,
    balance_due NUMBER,
    payment_status VARCHAR2(20),
    shift_id NUMBER UNIQUE,
    FOREIGN KEY (shift_id) REFERENCES Shift(shift_id)
);

-- AUDIT TABLE  
CREATE TABLE Audit_log ( -- (couldn't name it as 'Audit' as that's a reserved keyword.)
    audit_id NUMBER PRIMARY KEY,
    audit_date DATE,
    remarks VARCHAR2(100),
    admin_id NUMBER,
    kiln_id NUMBER,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
    FOREIGN KEY (kiln_id) REFERENCES Kiln(kiln_id)
);