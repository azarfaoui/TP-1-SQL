-------------------------------------FONCTIONS---------------------------

-- QUESTION 1
CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY_ID NUMBER) RETURN NUMBER IS
    NB_WORKERS NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO NB_WORKERS
    FROM WORKERS_FACTORY_1
    WHERE factory_id = FACTORY_ID;

    RETURN NB_WORKERS;
END;
/

-- QUESTION 2
CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER IS
    NB_BIG_ROBOTS NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO NB_BIG_ROBOTS
    FROM ROBOTS_HAS_SPARE_PARTS
    GROUP BY robot_id
    HAVING COUNT(*) > 3;

    RETURN NB_BIG_ROBOTS;
END;
/

-- QUESTION 3
CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 IS
    BEST_SUPPLIER_NAME VARCHAR2(100);
BEGIN
    SELECT name
    INTO BEST_SUPPLIER_NAME
    FROM BEST_SUPPLIERS
    WHERE ROWNUM = 1; -- Assuming there's only one best supplier

    RETURN BEST_SUPPLIER_NAME;
END;
/

-- QUESTION 4
CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER IS
    OLDEST_WORKER_ID NUMBER;
BEGIN
    SELECT worker_id
    INTO OLDEST_WORKER_ID
    FROM (
        SELECT worker_id
        FROM (
            SELECT worker_id, first_day
            FROM WORKERS_FACTORY_1
            UNION ALL
            SELECT worker_id, start_date
            FROM WORKERS_FACTORY_2
        )
        ORDER BY first_day ASC
    )
    WHERE ROWNUM = 1;

    RETURN OLDEST_WORKER_ID;
END;

-------------------------------------------------PROCEDURES----------------------------------------

-- QUESTION 1
CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) IS
BEGIN
    FOR i IN 1..NB_WORKERS LOOP
        INSERT INTO WORKERS_FACTORY_1 (factory_id, first_name, last_name, start_date)
        VALUES (FACTORY_ID, 'worker_f_' || i, 'worker_l_' || i, TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J'));
    END LOOP;
END;
/

-- QUESTION 2
CREATE OR REPLACE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2(50)) IS
BEGIN
    INSERT INTO ROBOTS (model)
    VALUES (MODEL_NAME);
END;
/

-- QUESTION 3
CREATE OR REPLACE PROCEDURE SEED_DATA_SPARE_PARTS(NB_SPARE_PARTS NUMBER) IS
BEGIN
    FOR i IN 1..NB_SPARE_PARTS LOOP
        INSERT INTO SPARE_PARTS (color, name)
        VALUES (
            CASE MOD(i, 5)
                WHEN 0 THEN 'red'
                WHEN 1 THEN 'gray'
                WHEN 2 THEN 'black'
                WHEN 3 THEN 'blue'
                WHEN 4 THEN 'silver'
            END,
            'Spare Part ' || i
        );
    END LOOP;
END;
/

