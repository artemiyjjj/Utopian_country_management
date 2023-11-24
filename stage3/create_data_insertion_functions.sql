CREATE OR REPLACE FUNCTION get_random_int_in_range (_from integer, _to integer) RETURNS integer AS
$$
    SELECT (random() * (_to - _from)) + _from;
$$ language sql;

CREATE OR REPLACE FUNCTION get_random_double_in_range (_from double precision, _to double precision) RETURNS double precision AS
$$
    SELECT (random() * (_to - _from)) + _from;
$$ language sql;

CREATE OR REPLACE FUNCTION get_random_string(length integer) RETURNS text AS
$$
DECLARE  chars text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
BEGIN
  if length < 0
      THEN RAISE EXCEPTION 'Length cannot be less than 0';
  end if;
  for i in 1..length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  RETURN result;
end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION get_random_string_with_delimiter() RETURNS text AS
$$
DECLARE
    result text := '';
BEGIN
    result := get_random_string(get_random_int_in_range(5, 15)) || ' ' || get_random_string(get_random_int_in_range(8, 12));
    RETURN result;
end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION get_country_id_by_name(country_name text) RETURNS integer AS
$$
    SELECT id FROM Country WHERE name = country_name;
$$ STABLE LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_event_group_id_by_name(event_group_name text) RETURNS integer AS
$$
    SELECT id FROM event_group WHERE name = event_group_name;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_political_status_id_by_name (political_status_name text) RETURNS integer AS
$$
    SELECT id FROM political_status WHERE name = political_status_name;
--     EXCEPTION
--         WHEN no_data_found THEN RAISE EXCEPTION 'No political status type with name % found.', political_status_name;
--     END;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_position_id_by_name (position_name text) RETURNS integer AS
$$
    SELECT id FROM Position WHERE name = position_name;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_position_id_by_craft_type (_craft_type_id integer) RETURNS integer AS
$$
    SELECT position_id FROM position_craft_type_relation WHERE craft_type_id = _craft_type_id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_craft_type_id_by_position (_position_id integer) RETURNS integer AS
$$
    SELECT craft_type_id FROM position_craft_type_relation WHERE position_id = _position_id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_person_id_by_name (person_name text) RETURNS integer AS
$$
    SELECT id FROM Person WHERE name = person_name;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_family_id_by_filarch_name (filarch_name text) RETURNS integer AS
$$
    SELECT id FROM family WHERE responsible_person_id = get_person_id_by_name(filarch_name);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_craft_type_id_id_by_name (craft_type_name text) RETURNS integer AS
$$
    SELECT id FROM Craft_type WHERE craft_name = craft_type_name;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_resource_type_id_by_name (resource_type_name text) RETURNS integer AS
$$
    SELECT id FROM resource_type WHERE resource_type = resource_type_name;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_or_insert_resource_usage_type_id_by_amount (resource_usage_type_amount double precision) RETURNS integer AS
$$
    DECLARE
        usage_type_id integer;
    BEGIN
        SELECT id FROM resource_usage_type WHERE amount = resource_usage_type_amount INTO usage_type_id;
        IF usage_type_id IS NULL
            THEN RETURN insert_resource_usage_type(resource_usage_type_amount);
            ELSE RETURN usage_type_id;
        END IF;
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_building_type_id_by_name (building_type_name text) RETURNS integer AS
$$
    BEGIN
    RETURN (SELECT id FROM Building_type WHERE type_name = building_type_name);
    EXCEPTION
        WHEN no_data_found THEN RAISE EXCEPTION 'No building type with name % found.', building_type_name;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_building_exists (building_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS (SELECT 1 FROM building WHERE id = building_id);
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_craft_type_exists (craft_type_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS( SELECT 1 FROM craft_type WHERE id = craft_type_id);
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_family_exists (family_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS( SELECT 1 FROM family WHERE id = family_id);
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_resource_exists (resource_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS( SELECT 1 FROM resource WHERE id = resource_id);
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_resource_storage_exists (resource_storage_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS( SELECT 1 FROM resource_storage WHERE id = resource_storage_id);
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_event_group_exists (group_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS( SELECT 1 FROM event_group WHERE id = group_id);
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_event_groups_exists (groups_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS( SELECT 1 FROM event_groups WHERE id = groups_id);
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_country_relationship_event_exists (relationship_event_id integer) RETURNS bool AS
$$
    BEGIN
        RETURN EXISTS (SELECT 1 FROM country_relationship_event_history WHERE id = relationship_event_id);
    end;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_country(country_name text) RETURNS integer AS
$$
    INSERT INTO Country (name) VALUES (country_name) RETURNING (country.id);
$$ LANGUAGE sql;

-- CREATE OR REPLACE FUNCTION insert_country(country_name text, leader_name text) RETURNS integer AS
-- $$
--     DECLARE
--         country_leader_id integer;
--     BEGIN
--         SELECT get_person_id_by_name(leader_name) INTO country_leader_id;
--         IF country_leader_id IS NOT NULL
--             THEN
--                 INSERT INTO country (name, leader_id) VALUES (country_name, country_leader_id)
--                 RETURNING (id);
-- --             ELSE RAISE EXCEPTION 'Person with name % does not exists.', leader_name;
--         END IF;
--     END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_country (country_name text, leader_name text) RETURNS integer AS
$$
    INSERT INTO country (name, leader_id) VALUES (country_name, get_person_id_by_name(leader_name))
    RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION update_country (country_name text, leader_name text) RETURNS void AS
$$
    DECLARE
        country_id integer;
        person_leader_id integer;
    BEGIN
        SELECT get_person_id_by_name(leader_name) INTO person_leader_id;
        SELECT get_country_id_by_name(country_name) INTO country_id;
--         RAISE info 'old: %', (Select leader_id from country where id = country_id);
        IF country_id IS NOT NULL and person_leader_id IS NOT NULL
            THEN
                UPDATE country
                    SET leader_id = person_leader_id
                    WHERE id = country_id;
--                 RETURNING *;
        end if;
--         RAISE info 'new: %', person_leader_id;
        RETURN;
    end;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_political_status (status_name text) RETURNS integer AS
$$
    INSERT INTO Political_status (name) VALUES (status_name) RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_event_group (group_name text) RETURNS integer AS
$$
    INSERT INTO event_group (name) VALUES (group_name) RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_event_group_countries (group_name text, country_name text) RETURNS void AS
$$
    DECLARE
        group_id_val integer;
        country_id_val integer;
    BEGIN
        SELECT get_country_id_by_name(country_name) INTO country_id_val;
        SELECT get_event_group_id_by_name(group_name) INTO group_id_val;
        IF group_id_val IS NOT NULL and country_id_val IS NOT NULL
            THEN
                INSERT INTO event_group_countries (group_id, country_id)
                VALUES (group_id_val, country_id_val);
--                 RETURNING *;
        end if;
        RETURN;
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_relationship_events_groups (event_id integer, group_name text) RETURNS void AS
$$
    DECLARE
        group_id integer;
    BEGIN
        SELECT get_event_group_id_by_name(group_name) INTO group_id;
        IF group_id IS NOT NULL and is_country_relationship_event_exists(event_id)
            THEN
                INSERT INTO event_groups (id, event_group_id) VALUES (event_id, group_id);
        END IF;
    RETURN;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_relationship_events_groups (event_id integer, group_id integer) RETURNS void AS
$$
    BEGIN
        IF is_event_group_exists(group_id) and is_country_relationship_event_exists(event_id)
            THEN
                INSERT INTO event_groups (id, event_group_id) VALUES (event_id, group_id);
        END IF;
    RETURN;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_country_relationship_event (political_status_name text, event_start_date date) RETURNS integer AS
$$
    DECLARE
        political_status_id_val integer;
        new_event_id integer;
    BEGIN
        SELECT get_political_status_id_by_name(political_status_name) INTO political_status_id_val;
        IF political_status_id_val IS NOT NULL
            THEN
                INSERT INTO country_relationship_event_history (political_status_id, start_event_date)
                VALUES (political_status_id_val, event_start_date)
                RETURNING id INTO new_event_id;
        end if;
        RETURN new_event_id;
    END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION insert_country_relationship_event (political_status_name text, event_start_date date, groups_id integer) RETURNS integer AS
-- $$
--     DECLARE
--         political_status_id_val integer;
--     BEGIN
--         SELECT get_political_status_id_by_name(political_status_name) INTO political_status_id_val;
--         IF political_status_id_val IS NOT NULL and is_event_groups_exists(groups_id) and event_start_date IS NOT NULL
--             THEN
--                 INSERT INTO country_relationship_event_history (political_status_id, start_event_date)
--                 VALUES (political_status_id_val, groups_id, event_start_date)
--                 RETURNING id;
--         end if;
--     END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_country_relationship_event (political_status_name text, event_start_date date, VARIADIC event_groups_id_array integer[]) RETURNS integer AS
$$
    DECLARE
        group_id integer;
        country_relationship_event_id integer;
    BEGIN
        SELECT insert_country_relationship_event(political_status_name, event_start_date) INTO country_relationship_event_id;
        IF country_relationship_event_id IS NOT NULL
            THEN
                FOREACH group_id IN ARRAY event_groups_id_array LOOP
                    PERFORM insert_relationship_events_groups(country_relationship_event_id, group_id);
                END LOOP;
        END IF;
        RETURN country_relationship_event_id;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_country_relationship_event (event_id integer, event_end_date date) RETURNS country_relationship_event_history AS
$$
    BEGIN
        IF is_country_relationship_event_exists(event_id)
            THEN
                UPDATE country_relationship_event_history
                    SET end_event_date = event_end_date
                    WHERE id = event_id
                RETURNING (id, political_status_id, start_event_date, end_event_date);
        end if;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_resource_type (resource_type_name text) RETURNS integer AS
$$
    INSERT INTO resource_type (resource_type) VALUES (resource_type_name)
    RETURNING id;
$$ LANGUAGE sql;

-- CREATE OR REPLACE FUNCTION insert_resource_storage (resource_type_name text, resource_storage_quantity double precision, resource_storage_current_quantity double precision) RETURNS integer AS
-- $$
--     DECLARE
--         resource_type_id_val integer;
--     BEGIN
--         SELECT get_resource_type_id_by_name(resource_type_name) INTO resource_type_id_val;
--         IF resource_type_name IS NOT NULL and resource_storage_quantity >= 0 and resource_storage_current_quantity >= 0 and resource_storage_current_quantity <= resource_storage_quantity
--             THEN
--                 INSERT INTO resource_storage (resource_type_id, total_quantity, current_quantity)
--                 VALUES (resource_type_id_val, resource_storage_quantity, resource_storage_current_quantity)
--                 RETURNING id;
--         END IF;
--     END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION _insert_resource_storage (_resource_type_name text, _resource_storage_quantity double precision, _resource_storage_current_quantity double precision) RETURNS integer AS
    $$

        INSERT INTO resource_storage (resource_type_id, total_quantity, current_quantity)
        VALUES ((SELECT id FROM resource_type WHERE resource_type = _resource_type_name), _resource_storage_quantity, _resource_storage_current_quantity )
        RETURNING id;
    $$ language sql;

CREATE OR REPLACE FUNCTION insert_resource (storage_id integer, resource_initial_quantity double precision) RETURNS integer AS
$$
    DECLARE
        _resource_id integer;
    BEGIN
        IF is_resource_storage_exists(storage_id) and resource_initial_quantity >= 0
            THEN INSERT INTO Resource (resource_storage_id, initial_quantity)
                VALUES (storage_id, resource_initial_quantity)
                RETURNING id INTO _resource_id;
        END IF;
        RETURN _resource_id;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_resource_usage_type (resource_usage_type_amount double precision) RETURNS integer AS
$$
    INSERT INTO resource_usage_type (amount) VALUES (resource_usage_type_amount)
    RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_resource_usage (resource_id_val integer, resource_usage_type_amount double precision) RETURNS integer AS
$$
    DECLARE
        resource_usage_type_id_val integer;
    BEGIN
        SELECT get_or_insert_resource_usage_type_id_by_amount(resource_usage_type_amount) INTO resource_usage_type_id_val;
        IF is_resource_exists(resource_id_val) and resource_usage_type_id_val IS NOT NULL
            THEN
                INSERT INTO resource_usage (resource_id, resource_usage_type_id)
                VALUES (resource_id_val, resource_usage_type_id_val)
                RETURNING (id);
        END IF;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_craft_type (craft_type_name text) RETURNS integer AS
$$
    INSERT INTO Craft_type (craft_name) VALUES (craft_type_name) RETURNING (id);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_family(craft_type_name text) RETURNS integer AS
$$
    INSERT INTO Family (craft_type_id)
    VALUES
        (get_craft_type_id_id_by_name(craft_type_name)) RETURNING (id);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_family(_craft_type_id integer) RETURNS integer AS
$$
    INSERT INTO Family (craft_type_id) VALUES (_craft_type_id) RETURNING (id);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_family(craft_type_name text, VARIADIC person_id integer[]) RETURNS integer AS
$$
    DECLARE
        new_family_id integer;
        p_id integer;
    BEGIN
    SELECT insert_family(craft_type_name) INTO new_family_id;
    FOREACH p_id IN ARRAY person_id LOOP
        PERFORM update_person(p_id, new_family_id);
        END LOOP;
    RETURN new_family_id;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_family(craft_type integer, responsible_person integer) RETURNS integer AS
$$
    DECLARE
        _family_id integer;
    BEGIN
        INSERT INTO family (craft_type_id, responsible_person_id)
        VALUES (craft_type, responsible_person) RETURNING (id) INTO _family_id;
        RETURN _family_id;
    end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION insert_family_resource_ownership (family_id_val integer, resource_id_val integer) RETURNS void AS
$$
    BEGIN
        IF is_family_exists(family_id_val) and is_resource_exists(resource_id_val)
            THEN
                INSERT INTO family_resource_ownership (family_id, resource_id)
                VALUES (family_id_val, resource_id_val);
        END IF;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_person (person_name text) RETURNS integer AS
$$
    INSERT INTO Person (name) VALUES (person_name) RETURNING id;
$$ LANGUAGE sql;

-- CREATE OR REPLACE FUNCTION insert_person (person_name text, motherland_name text) RETURNS integer AS
-- $$
--     DECLARE
--         country_id integer;
--     BEGIN
--         SELECT get_country_id_by_name(motherland_name) INTO country_id;
--         INSERT INTO Person (name, motherland_id) VALUES (person_name, country_id)
--         RETURNING person.id;
--
-- --         EXCEPTION
-- --             WHEN no_data_found THEN RAISE EXCEPTION 'Country % was not found.', motherland_name;
--     END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_person (_name text, _motherland_name text) RETURNS integer AS
$$
    INSERT INTO person (name, motherland_id) VALUES (_name, (SELECT get_country_id_by_name(_motherland_name))) RETURNING (id);
$$ language sql;

-- CREATE OR REPLACE FUNCTION insert_person (person_name text, motherland_name text, some_family_id integer) RETURNS person AS
-- $$
--     DECLARE
--         country_id integer;
--     BEGIN
--         SELECT get_country_id_by_name (motherland_name) INTO country_id;
--         IF NOT is_family_exists(some_family_id)
--             THEN RAISE EXCEPTION 'Family with id % does not exists', some_family_id;
--         ELSIF country_id IS NULL
--             THEN RAISE EXCEPTION 'Country with name % does not exists', motherland_name;
--         ELSE
--             INSERT INTO Person (name, motherland_id, family_id)
--             VALUES
--                 (person_name, country_id, some_family_id)
--             RETURNING person.id, person.name, person.motherland_id, person.family_id;
--         END IF;
--     END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_person (_name text, _motherland_name text, _family_id integer) RETURNS integer AS
$$
    INSERT INTO person (name, motherland_id, family_id) VALUES (_name, get_country_id_by_name(_motherland_name), _family_id) RETURNING (id);
$$ language sql;

-- CREATE OR REPLACE FUNCTION update_person (person_name text, new_motherland_name text) RETURNS person AS
-- $$
--     DECLARE
--         new_motherland_id integer;
--     BEGIN
--         SELECT get_country_id_by_name(new_motherland_name) INTO new_motherland_id;
--         IF new_motherland_id IS NOT NULL
--             THEN
--                 UPDATE person
--                     SET motherland_id = new_motherland_id
--                     WHERE name = person_name
--                 RETURNING (person.id, person.name, person.family_id, person.motherland_id);
--             ELSE RAISE EXCEPTION 'Country with name % does not exists', new_motherland_name;
--         END IF;
--     END;
-- $$ Language plpgsql;

CREATE OR REPLACE FUNCTION update_person (_name text, _motherland_name text) RETURNS person AS
$$
    UPDATE person
    SET motherland_id = get_country_id_by_name(_motherland_name)
    WHERE name = _name
    RETURNING (id, name, motherland_id, family_id);
$$ language sql;

CREATE OR REPLACE FUNCTION update_person (_person_id integer, _new_family_id integer) RETURNS person AS
$$
    UPDATE person
    SET family_id = _new_family_id
    WHERE id = _person_id
    RETURNING (id, name, motherland_id, family_id);
$$ language sql;

-- CREATE OR REPLACE FUNCTION update_person (person_id integer, new_family_id integer) RETURNS person AS
-- $$
--     BEGIN
--         IF is_family_exists(new_family_id)
--             THEN
--                 UPDATE person
--                     SET family_id = new_family_id
--                     WHERE id = person_id
--                 RETURNING (person.id, person.name, person.family_id, person.motherland_id);
--             ELSE RAISE EXCEPTION 'Family with id % does not exists', new_family_id;
--         END IF;
--     END;
-- $$ Language plpgsql;

CREATE OR REPLACE FUNCTION update_person (_name text, _new_family_id integer) RETURNS person AS
$$
    UPDATE person
    SET family_id = _new_family_id
    WHERE name = _name
    RETURNING (id, name, motherland_id, family_id);
$$ language sql;

CREATE OR REPLACE FUNCTION update_person (_person_id integer, _new_family_id integer) RETURNS person AS
$$
    UPDATE person
    SET family_id = _new_family_id
    WHERE id = _person_id
    RETURNING (id, name, motherland_id, family_id);
$$ language sql;

CREATE OR REPLACE FUNCTION insert_position (position_name text) RETURNS integer AS
$$
    INSERT INTO Position (name) VALUES (position_name) RETURNING (position.id);
$$ LANGUAGE sql;

-- CREATE OR REPLACE FUNCTION insert_position_craft_type_relation (position_name text, craft_type_name text) RETURNS void AS
-- $$
--     DECLARE
--         _position_id integer;
--         _craft_type_id integer;
--     BEGIN
--         SELECT get_position_id_by_name(position_name) INTO _position_id;
--         SELECT get_position_id_by_name(craft_type_name) INTO _craft_type_id;
--         IF _position_id IS NOT NULL and _craft_type_id IS NOT NULL
--             THEN
--                 INSERT INTO position_craft_type_relation (position_id, craft_type_id)
--                 VALUES (_position_id, _craft_type_id);
--         ELSE RAISE EXCEPTION 'Position or craft_type does not exists.';
--         end if;
--     END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_position_craft_type_relation (position_name text, craft_type_name text) RETURNs void as
$$
    INSERT INTO position_craft_type_relation (position_id, craft_type_id)
    VALUES (get_position_id_by_name(position_name),
            get_craft_type_id_id_by_name(craft_type_name));
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION _insert_position_history (_person text, _position text, _date date ) RETURNS integer AS
    $$
        INSERT INTO person_position_history (person_id, position_id, hire_date)
        VALUES ((SELECT id FROM person WHERE name = _person), (SELECT id FROM Position WHERE name = _position), _date )
        RETURNING id;
    $$ language sql;

CREATE OR REPLACE FUNCTION _insert_position_history (_person_id integer, _position_id integer, _date date ) RETURNS integer AS
    $$
        INSERT INTO person_position_history (person_id, position_id, hire_date)
        VALUES (_person_id, _position_id, _date )
        RETURNING id;
    $$ language sql;

CREATE OR REPLACE FUNCTION _insert_position_history (_person text, _position text, _hire_date date, _dismissal_date date ) RETURNS integer AS
    $$
        INSERT INTO person_position_history (person_id, position_id, hire_date, dismissal_date)
        VALUES ((SELECT id FROM person WHERE name = _person), (SELECT id FROM Position WHERE name = _position), _hire_date, _dismissal_date )
        RETURNING id;
    $$ language sql;

-- CREATE OR REPLACE FUNCTION insert_person_position_history (person_name text, person_position text, person_hire_date date) RETURNS integer AS
-- $$
--     DECLARE
--         person_id_val integer;
--         person_position_id integer;
--     BEGIN
--         SELECT get_person_id_by_name(person_name) INTO person_id_val;
--         SELECT get_position_id_by_name(person_position) INTO person_position_id;
--         IF person_id_val IS NOT NULL and person_position_id IS NOT NULL and person_hire_date IS NOT NULL
--             THEN
--                 INSERT INTO person_position_history (person_id, position_id, hire_date)
--                 VALUES (person_id_val, person_position_id, person_hire_date)
--                 RETURNING id;
--         ELSE
--             RAISE EXCEPTION 'Wrong inputs.';
-- Return null;
-- END iF;
-- END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_person_position_history (person_position_history_id integer, person_dismissal_date date) RETURNS person_position_history AS
$$
    UPDATE person_position_history
        SET dismissal_date = person_dismissal_date
        WHERE id = person_position_history_id
    RETURNING (id, person_id, position_id, hire_date, dismissal_date);
$$ Language sql;



CREATE OR REPLACE FUNCTION insert_report (report_title text, report_contents text, person_sender_name text, person_receiver_name text) RETURNS integer AS
$$
    DECLARE
        person_sender_id integer;
        person_receiver_id integer;
    BEGIN
        SELECT get_person_id_by_name(person_sender_name) INTO person_sender_id;
        SELECT get_person_id_by_name(person_receiver_name) INTO person_receiver_id;
        IF person_sender_id IS NOT NULL and person_receiver_id IS NOT NULL and report_title IS NOT NULL and report_contents IS NOT NULL
            THEN
                INSERT INTO Report (title, contents, sender_id, receiver_id, delivered)
                VALUES (report_title, report_contents, person_sender_id, person_receiver_id, FALSE)
                RETURNING id;
        end if;
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_report_to_delivered (report_id integer) RETURNS text AS
$$
    UPDATE Report
        SET delivered = TRUE
        WHERE id = report_id
    RETURNING (id, title, contents, sender_id, receiver_id, delivered);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_building_type (building_type_name text) RETURNS integer AS
$$
    INSERT INTO Building_type (type_name) VALUES (building_type_name) RETURNING (id);
$$ LANGUAGE sql;

-- CREATE OR REPLACE FUNCTION insert_building (new_building_type_name text) RETURNS integer AS
-- $$
--     DECLARE
--         new_building_type_id integer;
--     BEGIN
--         SELECT get_building_type_id_by_name(new_building_type_name) INTO new_building_type_id;
--         IF new_building_type_id IS NOT NULL
--             THEN
--                 INSERT INTO BUILDING (building_type_id) VALUES (new_building_type_id) RETURNING *;
--         end if;
--     RETURN *;
--     END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_building (new_building_type_name text) RETURNS integer AS
$$
    INSERT INTO building (building_type_id) VALUES (get_building_type_id_by_name(new_building_type_name)) RETURNING (id);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_building_construction_artefact (responsible_person_name text, new_building_type text, building_construction_beginning_date date) RETURNS integer AS
$$
    DECLARE
        responsible_id integer;
        new_building_type_id integer;
        new_building_id integer;
        artefact_id integer;
    BEGIN
        SELECT get_person_id_by_name(responsible_person_name) INTO responsible_id;
        IF responsible_id IS NOT NULL and new_building_type_id IS NOT NULL and building_construction_beginning_date IS NOT NULL
            THEN
                SELECT insert_building(new_building_type) INTO new_building_id;
                INSERT INTO building_construction_artefact (building_id, responsible_person_id, construction_beginning_date)
                VALUES (new_building_id, responsible_id, building_construction_beginning_date)
                RETURNING building_construction_artefact.building_id INTO artefact_id;
        end if;
        return artefact_id;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_building_construction_artefact (_responsible_person_id integer, new_building_type_name text, building_construction_beginning_date date) RETURNS integer AS
$$
    DECLARE
        new_building_id integer;
        artefact_id integer;
    BEGIN

        IF building_construction_beginning_date IS NOT NULL
            THEN
                IF NOT is_building_exists(new_building_id)
                    THEN SELECT insert_building(new_building_type_name) INTO new_building_id;
                END IF;
                INSERT INTO building_construction_artefact (building_id, responsible_person_id, construction_beginning_date)
                VALUES (new_building_id, _responsible_person_id, building_construction_beginning_date)
                RETURNING building_construction_artefact.building_id INTO artefact_id;
        ELSE RAISE EXCEPTION 'Conditions are failed.';
        end if;
        RETURN artefact_id;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_building_construction_artefact (new_building_id integer, building_construction_end_date date) RETURNS building AS
$$
    BEGIN
        IF is_building_exists(new_building_id) and building_construction_end_date IS NOT NULL
            THEN
                UPDATE building_construction_artefact
                SET construction_end_date = building_construction_end_date
                WHERE id = new_building_id
                RETURNING (building_id, responsible_person_id, construction_beginning_date, construction_end_date);
        end if;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_people_detachment_to_building (detached_person_name text, new_building_id integer) RETURNS void AS
$$
    DECLARE
        detached_person_id integer;
    BEGIN
        SELECT get_person_id_by_name(detached_person_name) INTO detached_person_id;
        IF is_building_exists(new_building_id) and detached_person_id IS NOT NULL
            THEN
                INSERT INTO people_detachment_to_building (person_id, building_id)
                VALUES (detached_person_id, new_building_id);
        END IF;
    END;
$$ LANGUAGE plpgsql;

