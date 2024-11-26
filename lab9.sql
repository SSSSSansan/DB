-- 1
CREATE OR REPLACE FUNCTION increase_value(INOUT value INTEGER)
RETURNS INTEGER AS $$
BEGIN
    value := value + 10;
    RETURN value;
END;
$$ LANGUAGE plpgsql;

-- 2
CREATE OR REPLACE FUNCTION compare_numbers(a INTEGER, b INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF a > b THEN
        RETURN 'Greater';
    ELSIF a = b THEN
        RETURN 'Equal';
    ELSE
        RETURN 'Lesser';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 3
CREATE OR REPLACE FUNCTION number_series(n INTEGER)
RETURNS TEXT AS $$
DECLARE
    result TEXT := '';
    i INTEGER := 1;
BEGIN
    WHILE i <= n LOOP
        result := result || i || CASE WHEN i < n THEN ', ' ELSE '' END;
        i := i + 1;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- 4
CREATE OR REPLACE FUNCTION find_employee(emp_name TEXT)
RETURNS TABLE(id INTEGER, name TEXT, position TEXT, salary NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT id, name, position, salary
    FROM employees
    WHERE name = emp_name;
END;
$$ LANGUAGE plpgsql;

-- 5
CREATE OR REPLACE FUNCTION list_products(category_name TEXT)
RETURNS TABLE(id INTEGER, name TEXT, price NUMERIC, category TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT id, name, price, category
    FROM products
    WHERE category = category_name;
END;
$$ LANGUAGE plpgsql;
-- 6
CREATE OR REPLACE FUNCTION calculate_bonus(emp_id INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    bonus NUMERIC;
BEGIN
    SELECT salary * 0.1 INTO bonus
    FROM employees
    WHERE id = emp_id;
    RETURN bonus;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_salary(emp_id INTEGER)
RETURNS VOID AS $$
DECLARE
    bonus NUMERIC;
BEGIN
    bonus := calculate_bonus(emp_id);
    UPDATE employees
    SET salary = salary + bonus
    WHERE id = emp_id;
END;
$$ LANGUAGE plpgsql;

-- 7
CREATE OR REPLACE FUNCTION complex_calculation(input_number INTEGER, input_string TEXT)
RETURNS TEXT AS $$
DECLARE
    numeric_result INTEGER;
    string_result TEXT;
BEGIN
    numeric_result := input_number * 2;
    BEGIN
        string_result := input_string || ' processed';
    END;
    RETURN 'Number: ' || numeric_result || ', String: ' || string_result;
END;
$$ LANGUAGE plpgsql;
