CREATE OR REPLACE FUNCTION get_country_id_by_name(country_name text) RETURNS integer AS
$$
    BEGIN
    SELECT id FROM Country WHERE name = country_name;

    EXCEPTION
        WHEN no_data_found THEN RAISE EXCEPTION 'No country with name %.', country_name;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_event_group_id_by_name(event_group_name text) RETURNS integer AS
$$
    BEGIN
    SELECT id FROM event_group WHERE name = event_group_name;

    EXCEPTION
        WHEN no_data_found THEN RAISE EXCEPTION 'No event group with name %.', event_group_name;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_political_status_id_by_name (political_status_name text) RETURNS integer AS
$$
    BEGIN
    SELECT id FROM political_status WHERE name = political_status_name;
    EXCEPTION
        WHEN no_data_found THEN RAISE EXCEPTION 'No political status type with name % found.', political_status_name;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_position_id_by_name (position_name text) RETURNS integer AS
$$
    SELECT id FROM Position WHERE name = position_name;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION get_person_id_by_name (person_name text) RETURNS integer AS
$$
    SELECT id FROM Person WHERE name = person_name;
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
    SELECT id FROM Building_type WHERE type_name = building_type_name;
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

CREATE OR REPLACE FUNCTION insert_country(country_name text, leader_name text) RETURNS integer AS
$$
    DECLARE
        country_leader_id integer;
    BEGIN
        SELECT get_person_id_by_name(leader_name) INTO country_leader_id;
        IF country_leader_id IS NOT NULL
            THEN
                INSERT INTO Country (name, leader_id) VALUES (country_name, country_leader_id)
                RETURNING country.id;
            ELSE RAISE EXCEPTION 'Person with name % does not exists.', leader_name;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_country (country_name text, leader_name text) RETURNS country AS
$$
    DECLARE
        country_id integer;
        person_leader_id integer;
    BEGIN
        SELECT get_person_id_by_name(leader_name) INTO person_leader_id;
        SELECT get_country_id_by_name(country_name) INTO country_id;
        IF country_id IS NOT NULL && person_leader_id IS NOT NULL
            THEN
                UPDATE country
                    SET leader_id = person_leader_id
                    WHERE id = country_id
                RETURNING (id, name, leader_id);
        end if;
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

CREATE OR REPLACE FUNCTION insert_event_group_countries (group_name text, country_name text) RETURNS event_group_countries AS
$$
    DECLARE
        group_id_val integer;
        country_id_val integer;
    BEGIN
        SELECT get_country_id_by_name(country_name) INTO country_id_val;
        SELECT get_event_group_id_by_name(group_name) INTO group_id_val;
        IF group_id_val IS NOT NULL && country_id_val IS NOT NULL
            THEN
                INSERT INTO event_group_countries (group_id, country_id)
                VALUES (group_id_val, country_id_val)
                RETURNING (group_id, country_id);
        end if;
    end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_relationship_events_groups (event_id integer, group_name text) RETURNS event_groups AS
$$
    DECLARE
        group_id integer;
    BEGIN
        SELECT get_event_group_id_by_name(group_name) INTO group_id;
        IF event_group_id IS NOT NULL && is_country_relationship_event_exists(event_id)
            THEN
                INSERT INTO event_groups (id, event_group_id) VALUES (event_id, group_id)
                RETURNING (id, event_group_id);
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_country_relationship_event (political_status_name text, event_start_date date) RETURNS integer AS
$$
    DECLARE
        political_status_id_val integer;
    BEGIN
        SELECT get_political_status_id_by_name(political_status_name) INTO political_status_id_val;
        IF political_status_id_val IS NOT NULL
            THEN
                INSERT INTO country_relationship_event_history (political_status_id, start_event_date)
                VALUES (political_status_id_val, event_start_date)
                RETURNING id;
        end if;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_country_relationship_event (political_status_name text, event_start_date date, groups_id integer) RETURNS integer AS
$$
    DECLARE
        political_status_id_val integer;
    BEGIN
        SELECT get_political_status_id_by_name(political_status_name) INTO political_status_id_val;
        IF political_status_id_val IS NOT NULL && is_event_groups_exists(groups_id) && event_start_date IS NOT NULL
            THEN
                INSERT INTO country_relationship_event_history (political_status_id, event_groups_id, start_event_date)
                VALUES (political_status_id_val, groups_id, event_start_date)
                RETURNING id;
        end if;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_country_relationship_event (political_status_name text, event_start_date date, VARIADIC event_groups_name_set text[]) RETURNS integer AS
$$
    DECLARE
        group_name integer;
        country_relationship_event_id integer;
    BEGIN
        SELECT insert_country_relationship_event(political_status_name, event_start_date) INTO country_relationship_event_id;
        IF country_relationship_event_id IS NOT NULL
            THEN
                FOREACH group_name IN ARRAY event_groups_name_set LOOP
                    SELECT insert_relationship_events_groups(country_relationship_event_id, group_name);
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

CREATE OR REPLACE FUNCTION insert_resource_storage (resource_type_name text, resource_storage_quantity double precision) RETURNS integer AS
$$
    DECLARE
        resource_type_id_val integer;
    BEGIN
        SELECT get_resource_type_id_by_name(resource_type_name) INTO resource_type_id_val;
        IF resource_type_name IS NOT NULL && resource_storage_quantity >= 0
            THEN
                INSERT INTO resource_storage (resource_type_id, total_quantity)
                VALUES (resource_type_id_val, resource_storage_quantity)
                RETURNING resource_storage.id;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_resource (storage_id integer, resource_initial_quantity double precision) RETURNS integer AS
$$
    BEGIN
        IF is_resource_storage_exists(storage_id) && resource_initial_quantity >= 0
            THEN INSERT INTO Resource (resource_storage_id, initial_quantity)
                VALUES (storage_id, resource_initial_quantity)
                RETURNING id;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_resource_usage_type (resource_usage_type_amount double precision) RETURNS integer AS
$$
    INSERT INTO resource_usage_type (amount) VALUES (resource_usage_type_amount)
    RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_resource_usage (resource_id_val integer, resource_usage_type_amount double precision) RETURNS resource_usage AS
$$
    DECLARE
        resource_usage_type_id_val integer;
    BEGIN
        SELECT get_or_insert_resource_usage_type_id_by_amount(resource_usage_type_amount) INTO resource_usage_type_id_val;
        IF is_resource_exists(resource_id_val) && resource_usage_type_id_val IS NOT NULL
            THEN
                INSERT INTO resource_usage (resource_id, resource_usage_type_id)
                VALUES (resource_id_val, resource_usage_type_id_val)
                RETURNING (id, resource_id, resource_usage_type_id);
        END IF;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_craft_type (craft_type_name text) RETURNS craft_type AS
$$
    INSERT INTO Craft_type (craft_name) VALUES (craft_type_name) RETURNING (id, craft_name);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_family(craft_type_name text) RETURNS family AS
$$
    INSERT INTO Family (craft_type_id)
    VALUES
        (get_craft_type_id_id_by_name(craft_type_name)) RETURNING (family.id, family.craft_type_id);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_family(craft_type_name text, VARIADIC person_id integer[]) RETURNS family AS
$$
    DECLARE
        new_family_id integer;
        p_id integer;
    BEGIN
    SELECT insert_family(craft_type_name) INTO new_family_id;
    FOREACH p_id IN ARRAY person_id LOOP
        SELECT update_person(p_id, new_family_id);
        END LOOP;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_family_resource_ownership (family_id_val integer, resource_id_val integer, resource_quantity double precision) RETURNS family_resource_ownership AS
$$
    BEGIN
        IF is_family_exists(family_id_val) && is_resource_exists(resource_id_val) && resource_quantity >= 0
            THEN
                INSERT INTO family_resource_ownership (family_id, resource_id, quantity)
                VALUES (family_id_val, resource_id_val, resource_quantity)
                RETURNING (family_id, resource_id, quantity);
        END IF;
    END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION insert_person (person_name text) RETURNS integer AS
$$
    INSERT INTO Person (name) VALUES (person_name) RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_person (person_name text, motherland_name text) RETURNS person AS
$$
    DECLARE
        country_id integer;
    BEGIN
        SELECT get_country_id_by_name(motherland_name) INTO country_id;
        INSERT INTO Person (name, motherland_id) VALUES (person_name, country_id)
        RETURNING (person.id, person.name, person.motherland_id);

        EXCEPTION
            WHEN no_data_found THEN RAISE EXCEPTION 'Country % was not found.', motherland_name;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_person (person_name text, motherland_name text, some_family_id integer) RETURNS person AS
$$
    DECLARE
        country_id integer;
    BEGIN
        SELECT get_country_id_by_name (motherland_name) INTO country_id;
        IF NOT is_family_exists(some_family_id)
            THEN RAISE EXCEPTION 'Family with id % does not exists', some_family_id;
        ELSIF country_id IS NULL
            THEN RAISE EXCEPTION 'Country with name % does not exists', motherland_name;
        ELSE
            INSERT INTO Person (name, motherland_id, family_id)
            VALUES
                (person_name, country_id, some_family_id)
            RETURNING person.id, person.name, person.motherland_id, person.family_id;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_person (person_name text, new_motherland_name text) RETURNS person AS
$$
    DECLARE
        new_motherland_id integer;
    BEGIN
        SELECT get_country_id_by_name(new_motherland_name) INTO new_motherland_id;
        IF new_motherland_id IS NOT NULL
            THEN
                UPDATE person
                    SET motherland_id = new_motherland_id
                    WHERE name = person_name
                RETURNING (person.id, person.name, person.family_id, person.motherland_id);
            ELSE RAISE EXCEPTION 'Country with name % does not exists', new_motherland_name;
        END IF;
    END;
$$ Language plpgsql;

CREATE OR REPLACE FUNCTION update_person (person_id integer, new_family_id integer) RETURNS person AS
$$
    BEGIN
        IF is_family_exists(new_family_id)
            THEN
                UPDATE person
                    SET family_id = new_family_id
                    WHERE id = person_id
                RETURNING (person.id, person.name, person.family_id, person.motherland_id);
            ELSE RAISE EXCEPTION 'Family with id % does not exists', new_family_id;
        END IF;
    END;
$$ Language plpgsql;

CREATE OR REPLACE FUNCTION insert_position (position_name text) RETURNS integer AS
$$
    INSERT INTO Position (name) VALUES (position_name) RETURNING (position.id);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_person_position_history (person_name text, person_position text, person_hire_date date) RETURNS integer AS
$$
    DECLARE
        person_id_val integer;
        person_position_id integer;
    BEGIN
        SELECT get_person_id_by_name(person_name) INTO person_id_val;
        SELECT get_position_id_by_name(person_position) INTO person_position_id;
        IF person_id_val IS NOT NULL && person_position_id IS NOT NULL && person_hire_date IS NOT NULL
            THEN
                INSERT INTO person_position_history (person_id, position_id, hire_date)
                VALUES (person_id_val, person_position_id, person_hire_date)
                RETURNING person_position_history.id;
        END iF;
    END;
$$ LANGUAGE plpgsql;

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
        IF person_sender_id IS NOT NULL && person_receiver_id IS NOT NULL && report_title IS NOT NULL && report_contents IS NOT NULL
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

CREATE OR REPLACE FUNCTION insert_building (new_building_type_name text) RETURNS integer AS
$$
    DECLARE
        new_building_type_id integer;
    BEGIN
        SELECT get_building_type_id_by_name(new_building_type_name) INTO new_building_type_id;
        IF new_building_type_id IS NOT NULL
            THEN
                INSERT INTO BUILDING (building_type_id) VALUES (new_building_type_id) RETURNING (building.id);
        end if;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_building_construction_artefact (responsible_person_name text, new_building_type text, building_construction_beginning_date date) RETURNS integer AS
$$
    DECLARE
        responsible_id integer;
        new_building_type_id integer;
        new_building_id integer;
    BEGIN
        SELECT get_person_id_by_name(responsible_person_name) INTO responsible_id;
        SELECT get_building_type_id_by_name(new_building_type) INTO new_building_type_id;
        IF responsible_id IS NOT NULL && new_building_type_id IS NOT NULL && building_construction_beginning_date IS NOT NULL
            THEN
                SELECT insert_building(new_building_type_id) INTO new_building_id;
                INSERT INTO building_construction_artefact (building_id, responsible_person_id, construction_beginning_date) VALUES (new_building_id, responsible_person_id, building_construction_beginning_date)
                RETURNING building_construction_artefact.building_id;
        end if;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_building_construction_artefact (responsible_person_name text, new_building_id integer, building_construction_beginning_date date) RETURNS integer AS
$$
    DECLARE
        responsible_id integer;
        new_building_id integer;
    BEGIN
        SELECT get_person_id_by_name(responsible_person_name) INTO responsible_id;
        IF responsible_id IS NOT NULL && is_building_exists(new_building_id) && building_construction_beginning_date IS NOT NULL
            THEN
                INSERT INTO building_construction_artefact (building_id, responsible_person_id, construction_beginning_date)
                VALUES (new_building_id, responsible_id, building_construction_beginning_date)
                RETURNING building_construction_artefact.building_id;
        end if;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_building_construction_artefact (new_building_id integer, building_construction_end_date date) RETURNS building AS
$$
    BEGIN
        IF is_building_exists(new_building_id) && building_construction_end_date IS NOT NULL
            THEN
                UPDATE building_construction_artefact
                SET construction_end_date = building_construction_end_date
                WHERE id = new_building_id
                RETURNING (building_id, responsible_person_id, construction_beginning_date, construction_end_date);
        end if;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_people_detachment_to_building (detached_person_name text, new_building_id integer) RETURNS people_detachment_to_building AS
$$
    DECLARE
        detached_person_id integer;
    BEGIN
        SELECT get_person_id_by_name(detached_person_name) INTO detached_person_id;
        IF is_building_exists(new_building_id) && detached_person_id IS NOT NULL
            THEN
                INSERT INTO people_detachment_to_building (person_id, building_id)
                VALUES (detached_person_id, new_building_id)
                RETURNING (person_id, building_id);
        END IF;
    END;
$$ LANGUAGE plpgsql;
