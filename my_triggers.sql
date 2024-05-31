-------------------------------------------------TRIGGERS----------------------------------------


-- QUESTION 1
CREATE OR REPLACE TRIGGER INSERT_WORKER_TRIGGER
INSTEAD OF INSERT ON ALL_WORKERS_ELAPSED
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.factory_id IS NOT NULL THEN
            INSERT INTO WORKERS_FACTORY_1 (id, factory_id, first_name, last_name, start_date)
            VALUES (:NEW.id, :NEW.factory_id, :NEW.first_name, :NEW.last_name, :NEW.start_date);
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Cannot insert worker without factory ID.');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Invalid operation.');
    END IF;
END;
/

-- QUESTION 2
CREATE OR REPLACE TRIGGER AUDIT_ROBOT_TRIGGER
AFTER INSERT ON ROBOTS
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_ROBOT (robot_id, insertion_date)
    VALUES (:NEW.id, SYSDATE);
END;
/

-- QUESTION3
CREATE OR REPLACE TRIGGER CHECK_FACTORY_COUNT_TRIGGER
BEFORE UPDATE OR DELETE ON ROBOTS_FACTORIES
DECLARE
    FACTORY_COUNT NUMBER;
    WORKER_TABLE_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO FACTORY_COUNT FROM FACTORIES;

    SELECT COUNT(*) INTO WORKER_TABLE_COUNT
    FROM USER_TABLES
    WHERE TABLE_NAME LIKE 'WORKERS_FACTORY\_%' ESCAPE '\';

    IF FACTORY_COUNT <> WORKER_TABLE_COUNT THEN
        RAISE_APPLICATION_ERROR(-20003, 'Number of factories does not match number of worker tables.');
    END IF;
END;
/

-- QUESTION 4
CREATE OR REPLACE TRIGGER CALCULATE_WORKER_DURATION_TRIGGER
BEFORE UPDATE OF last_day ON WORKERS_FACTORY_1
FOR EACH ROW
BEGIN
    IF :OLD.last_day IS NULL AND :NEW.last_day IS NOT NULL THEN
        :NEW.duration := :NEW.last_day - :NEW.first_day;
    END IF;
END;
/
