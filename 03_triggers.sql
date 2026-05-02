-- TRIGGERS (used to automate logic and avoid manual mistakes)


-- Trigger 1: calculate balance automatically
CREATE OR REPLACE TRIGGER trg_balance_calc
BEFORE INSERT OR UPDATE ON Wage
FOR EACH ROW
BEGIN
    :NEW.balance_due := :NEW.amount - :NEW.advance_paid;
END;
/
 


-- Trigger 2: stop advance from being more than total amount
CREATE OR REPLACE TRIGGER trg_no_invalid_advance
BEFORE INSERT OR UPDATE ON Wage
FOR EACH ROW
BEGIN
    IF :NEW.advance_paid > :NEW.amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Advance cannot exceed total wage');
    END IF;
END;
/
 


-- Trigger 3: check wage is not below kiln minimum wage
CREATE OR REPLACE TRIGGER trg_minimum_wage_check
BEFORE INSERT OR UPDATE ON Wage
FOR EACH ROW
DECLARE
    v_min_wage NUMBER;
BEGIN
    SELECT k.min_wage INTO v_min_wage
    FROM Shift s
    JOIN Kiln k ON s.kiln_id = k.kiln_id
    WHERE s.shift_id = :NEW.shift_id;

    IF :NEW.amount < v_min_wage THEN
        RAISE_APPLICATION_ERROR(-20002, 'Wage below minimum wage');
    END IF;
END;
/
 


-- Trigger 4: update payment status based on balance
CREATE OR REPLACE TRIGGER trg_payment_status_update
BEFORE INSERT OR UPDATE ON Wage
FOR EACH ROW
BEGIN
    IF :NEW.balance_due = 0 THEN
        :NEW.payment_status := 'Paid';
    ELSE
        :NEW.payment_status := 'Pending';
    END IF;
END;
/
 



-- QUERIES (used for reports and checking data)


-- migrants working in each kiln
SELECT k.location, COUNT(DISTINCT s.migrant_id) AS total_workers
FROM Shift s
JOIN Kiln k ON s.kiln_id = k.kiln_id
GROUP BY k.location;


-- total wage earned by each migrant
SELECT m.name, SUM(w.amount) AS total_wage
FROM Migrant m
JOIN Shift s ON m.migrant_id = s.migrant_id
JOIN Wage w ON s.shift_id = w.shift_id
GROUP BY m.name;


-- list of pending payments
SELECT * 
FROM Wage
WHERE payment_status = 'Pending';


-- children who are not enrolled
SELECT * 
FROM Child
WHERE enrollment_status = 'Dropped';


-- number of audits per kiln
SELECT k.location, COUNT(a.audit_id) AS total_audits
FROM Audit_Log a
JOIN Kiln k ON a.kiln_id = k.kiln_id
GROUP BY k.location;


-- optional view for summary (extra marks)
CREATE OR REPLACE VIEW migrant_wage_summary AS
SELECT m.name, SUM(w.amount) AS total_income
FROM Migrant m
JOIN Shift s ON m.migrant_id = s.migrant_id
JOIN Wage w ON s.shift_id = w.shift_id
GROUP BY m.name;