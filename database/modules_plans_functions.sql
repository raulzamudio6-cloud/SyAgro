-- =============================
-- MODULES FUNCTIONS
-- =============================

-- 1. Get all modules
-- FUNCTION: public.get_modules()

-- DROP FUNCTION IF EXISTS public.get_modules();

CREATE OR REPLACE FUNCTION public.get_modules(
	)
    RETURNS TABLE(id uuid, code character varying, name character varying, description text, is_core boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY SELECT m.id, m.code, m.name, m.description, m.is_core FROM modules as m ORDER BY m.id;
END;
$BODY$;

ALTER FUNCTION public.get_modules()
    OWNER TO postgres;



-- 2. Get module by id
-- FUNCTION: public.get_module_by_id(uuid)

-- DROP FUNCTION IF EXISTS public.get_module_by_id(uuid);

CREATE OR REPLACE FUNCTION public.get_module_by_id(
	p_id uuid)
    RETURNS TABLE(id uuid, code character varying, name character varying, description text, is_core boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY SELECT m.id, m.code, m.name, m.description, m.is_core FROM modules as m WHERE m.id = p_id;
END;
$BODY$;

ALTER FUNCTION public.get_module_by_id(uuid)
    OWNER TO postgres;



-- 3. Create module
-- FUNCTION: public.create_module(character varying, character varying, text, boolean)

-- DROP FUNCTION IF EXISTS public.create_module(character varying, character varying, text, boolean);

CREATE OR REPLACE FUNCTION public.create_module(
	p_code character varying,
	p_name character varying,
	p_description text,
	p_is_core boolean)
    RETURNS uuid
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    new_id uuid;
BEGIN
    INSERT INTO modules (code, name, description, is_core)
    VALUES (p_code, p_name, p_description, p_is_core)
    RETURNING id INTO new_id;
    RETURN new_id;
EXCEPTION WHEN unique_violation THEN
    RAISE EXCEPTION 'Module code must be unique';
END;
$BODY$;

ALTER FUNCTION public.create_module(character varying, character varying, text, boolean)
    OWNER TO postgres;


-- 4. Update module
-- FUNCTION: public.update_module(uuid, character varying, character varying, text, boolean)

-- DROP FUNCTION IF EXISTS public.update_module(uuid, character varying, character varying, text, boolean);

CREATE OR REPLACE FUNCTION public.update_module(
	p_id uuid,
	p_code character varying,
	p_name character varying,
	p_description text,
	p_is_core boolean)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    UPDATE modules
    SET code = p_code,
        name = p_name,
        description = p_description,
        is_core = p_is_core
    WHERE id = p_id;
END;
$BODY$;

ALTER FUNCTION public.update_module(uuid, character varying, character varying, text, boolean)
    OWNER TO postgres;



-- 5. Delete module
-- FUNCTION: public.delete_module(uuid)

-- DROP FUNCTION IF EXISTS public.delete_module(uuid);

CREATE OR REPLACE FUNCTION public.delete_module(
	p_id uuid)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    DELETE FROM modules WHERE id = p_id;
END;
$BODY$;

ALTER FUNCTION public.delete_module(uuid)
    OWNER TO postgres;


-- =============================
-- PLANS FUNCTIONS
-- =============================

-- 1. Get all plans
-- FUNCTION: public.get_plans()

-- DROP FUNCTION IF EXISTS public.get_plans();

CREATE OR REPLACE FUNCTION public.get_plans(
	)
    RETURNS TABLE(id uuid, name character varying, description text, price_monthly numeric, price_yearly numeric, is_active boolean, created_at timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY SELECT p.id, p.name, p.description, p.price_monthly, p.price_yearly, p.is_active, p.created_at FROM plans p ORDER BY id;
END;
$BODY$;

ALTER FUNCTION public.get_plans()
    OWNER TO postgres;

-- FUNCTION: public.get_plan_by_id(integer)

-- DROP FUNCTION IF EXISTS public.get_plan_by_id(uuid);

CREATE OR REPLACE FUNCTION public.get_plan_by_id(
	p_id uuid)
    RETURNS TABLE(id uuid, name character varying, description text, price_monthly numeric, price_yearly numeric, is_active boolean, created_at timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
    RETURN QUERY SELECT p.id, p.name, p.description, p.price_monthly, p.price_yearly, p.is_active, p.created_at FROM plans as p WHERE p.id = p_id;
END;
$BODY$;

ALTER FUNCTION public.get_plan_by_id(uuid)
    OWNER TO postgres;




-- 3. Create plan
CREATE OR REPLACE FUNCTION create_plan(
    p_name VARCHAR,
    p_description TEXT,
    p_price_monthly NUMERIC,
    p_price_yearly NUMERIC,
    p_is_active BOOLEAN
) RETURNS INT AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO plans (name, description, price_monthly, price_yearly, is_active, created_at)
    VALUES (p_name, p_description, p_price_monthly, p_price_yearly, p_is_active, NOW())
    RETURNING id INTO new_id;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION: public.update_plan(integer, character varying, text, numeric, numeric, boolean)

-- DROP FUNCTION IF EXISTS public.update_plan(integer, character varying, text, numeric, numeric, boolean);

CREATE OR REPLACE FUNCTION public.update_plan(
	p_id uuid,
	p_name character varying,
	p_description text,
	p_price_monthly numeric,
	p_price_yearly numeric,
	p_is_active boolean)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    UPDATE plans
    SET name = p_name,
        description = p_description,
        price_monthly = p_price_monthly,
        price_yearly = p_price_yearly,
        is_active = p_is_active
    WHERE id = p_id;
END;
$BODY$;

ALTER FUNCTION public.update_plan(uuid, character varying, text, numeric, numeric, boolean)
    OWNER TO postgres;


-- FUNCTION: public.delete_plan(UUID)

-- DROP FUNCTION IF EXISTS public.delete_plan(UUID);

CREATE OR REPLACE FUNCTION public.delete_plan(
	p_id UUID)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    DELETE FROM plans WHERE id = p_id;
END;
$BODY$;

ALTER FUNCTION public.delete_plan(UUID)
    OWNER TO postgres;

