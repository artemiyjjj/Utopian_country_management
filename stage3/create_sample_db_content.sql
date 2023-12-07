SELECT insert_craft_type('Gardening');
SELECT insert_craft_type('Farming');
SELECT insert_craft_type('Livestock');
SELECT insert_craft_type('Copper');
SELECT insert_craft_type('Factory work');
SELECT insert_craft_type('Crafting');
SELECT insert_craft_type('Teaching');
SELECT insert_craft_type('Servicing');

-- Inside Utopia
SELECT insert_position('Filarch');
SELECT insert_position('Protofilarch');
SELECT insert_position('Kniaz');
SELECT insert_position('Craftsman');
SELECT insert_position('Teacher');
SELECT insert_position('Kelner');
SELECT insert_position('Farmer');
SELECT insert_position('Butcher');
SELECT insert_position('Gardener');
SELECT insert_position('Copper');
SELECT insert_position('Factory worker');

CREATE OR REPLACE FUNCTION get_random_utopian_management_position_id () RETURNS integer AS
$$
    DECLARE
        chance double precision = get_random_double_in_range(0, 1);
    BEGIN
        IF chance > 0.9
            THEN RETURN get_position_id_by_name('Protofilarch');
        ELSE RETURN get_position_id_by_name('Filarch');
        END IF;
    END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION get_random_utopian_position_id() RETURNS integer AS
$$
    DECLARE
        chance double precision = get_random_double_in_range(0, 1);
    BEGIN
        IF chance > 0.9
            THEN RETURN get_position_id_by_name('Teacher');
        ELSIF chance > 0.88
            THEN RETURN get_position_id_by_name('Kelner');
        ELSIF chance > 0.84
            THEN RETURN get_position_id_by_name('Gardener');
        ELSIF chance > 0.8
            THEN RETURN get_position_id_by_name('Butcher');
        ELSIF chance > 0.65
            THEN RETURN get_position_id_by_name('Craftsman');
        ELSIF chance > 0.50
            THEN RETURN get_position_id_by_name('Factory worker');
        ELSIF chance > 0.30
            THEN RETURN get_position_id_by_name('Copper');
        ELSE
            RETURN get_position_id_by_name('Farmer');
        END IF;
    END;
$$ LANGUAGE plpgsql;

-- Outside Utopia
SELECT insert_position('Foreign king');
SELECT insert_position('Foreign diplomat');
SELECT insert_position('Foreign citizen');

CREATE OR REPLACE FUNCTION get_random_foreign_position_id() RETURNS integer AS
$$
    DECLARE
        chance double precision;
    BEGIN
        chance = get_random_double_in_range(0, 1);
        IF chance > 0.97
            THEN RETURN get_position_id_by_name('Foreign diplomat');
        ELSE
            RETURN get_position_id_by_name('Foreign citizen');
        END IF;
    end;
$$ LANGUAGE plpgsql;

SELECT insert_position_craft_type_relation('Craftsman', 'Crafting');
SELECT insert_position_craft_type_relation('Teacher', 'Teaching');
SELECT insert_position_craft_type_relation('Farmer', 'Farming');
SELECT insert_position_craft_type_relation('Gardener', 'Gardening');
SELECT insert_position_craft_type_relation('Butcher', 'Livestock');
SELECT insert_position_craft_type_relation('Copper', 'Copper');
SELECT insert_position_craft_type_relation('Factory worker', 'Factory work');
SELECT insert_position_craft_type_relation('Kelner', 'Servicing');


SELECT insert_building_type('School');
SELECT insert_building_type('Pub');
SELECT insert_building_type('Farm');
SELECT insert_building_type('Garden');
SELECT insert_building_type('Workshop');
SELECT insert_building_type('Administrative');
SELECT insert_building_type('Living');
SELECT insert_building_type('Mine');
SELECT insert_building_type('Factory');

SELECT insert_political_status('War');
SELECT insert_political_status('Conflict');
SELECT insert_political_status('Peace');
SELECT insert_political_status('Cooperation');

SELECT insert_resource_type('Water');
SELECT insert_resource_type('Wood');
SELECT insert_resource_type('Food');
SELECT insert_resource_type('Stone');
SELECT insert_resource_type('Gold');
SELECT insert_resource_type('Oil');


CREATE OR REPLACE FUNCTION generate_resource_storages(min_amount integer, max_amount integer, min_quantity double precision, max_quantity double precision, _resource_type_name text) RETURNS void AS
$$
    DECLARE
        quantity double precision;
    BEGIN
        for i in min_amount..get_random_int_in_range(min_amount, max_amount) LOOP
            SELECT get_random_double_in_range(min_quantity, max_quantity) INTO quantity;
            PERFORM _insert_resource_storage(_resource_type_name, quantity, get_random_double_in_range(0, quantity));
        end loop;
    end;
$$ language plpgsql;

SELECT generate_resource_storages(5, 10, 100, 1500, 'Gold');
SELECT generate_resource_storages(40, 100, 10000, 2000000, 'Water');
SELECT generate_resource_storages(20, 50, 50000, 450000, 'Wood');
SELECT generate_resource_storages(40, 100, 1500, 300000, 'Food');
SELECT generate_resource_storages(3, 20, 300, 10000, 'Oil');
SELECT generate_resource_storages(10, 30, 2000, 100000, 'Stone');

SELECT insert_country('Utopia');
SELECT insert_country('Poland');
SELECT insert_country('Finland');
SELECT insert_country('Sweden');
SELECT insert_country('Great Britain');

SELECT insert_person('Sigizmund III', 'Poland');
SELECT insert_person('Petr I', 'Finland');
SELECT insert_person('Victoria II', 'Great Britain');
SELECT insert_person('Ambrozius The Great', 'Utopia');
SELECT insert_person('Sigizmund IV', 'Poland');
SELECT insert_person('EKATERINA I', 'Finland');
SELECT insert_person('Karl IV', 'Sweden');

SELECT update_country('Utopia', 'Ambrozius The Great');
SELECT update_country('Poland', 'Sigizmund III');
SELECT update_country('Finland', 'Petr I');
SELECT update_country('Sweden', 'Karl IV');
SELECT update_country('Great Britain', 'Victoria II');

SELECT _insert_position_history('Sigizmund III', 'Foreign king', make_date(2000, 10, 20));
SELECT _insert_position_history('Sigizmund IV', 'Foreign diplomat', make_date(2001, 3, 5));
SELECT _insert_position_history('Petr I', 'Foreign king', make_date(1998, 5, 30));
SELECT _insert_position_history('EKATERINA I', 'Foreign diplomat', make_date(1998, 5, 30));
SELECT _insert_position_history('Karl IV', 'Foreign king', make_date(1998, 5, 30));
SELECT _insert_position_history('Victoria II', 'Foreign king', make_date(2002, 4, 17));
SELECT _insert_position_history('Ambrozius The Great', 'Kniaz', make_date(2000, 4, 17));

CREATE OR REPLACE FUNCTION generate_positions(amount integer) RETURNS void AS
$$
    DECLARE
    BEGIN
        FOR i IN 1..amount/10 LOOP
            INSERT INTO position (name) VALUES (get_random_string(5)), (get_random_string(6)), (get_random_string(7)), (get_random_string(8)),
                                               (get_random_string(9)), (get_random_string(10)), (get_random_string(11)), (get_random_string(12)),
                                               (get_random_string(13)), (get_random_string(14));
            end loop;
    end;
$$ LANGUAGE plpgsql;

SELECT generate_positions(10000);

CREATE OR REPLACE FUNCTION generate_foreign_people (min_people_amount integer, max_people_amount integer, country_name text) RETURNS void AS
$$
    DECLARE
        added_person_id integer;
    BEGIN
        IF get_country_id_by_name(country_name) IS NULL
            THEN RAISE EXCEPTION 'Country % does not exists yet.', country_name;
        ELSE
            FOR i IN 1..get_random_int_in_range(min_people_amount,max_people_amount) LOOP
                SELECT insert_person(get_random_string_with_delimiter(), country_name) INTO added_person_id;
                PERFORM _insert_position_history(added_person_id, get_random_foreign_position_id(), CURRENT_DATE);
                end loop;
        END IF;
    END;
$$ LANGUAGE plpgsql;

SELECT generate_foreign_people(10, 20, 'Poland');
SELECT generate_foreign_people(10, 20, 'Finland');
SELECT generate_foreign_people(10, 20, 'Sweden');
SELECT generate_foreign_people(10, 20, 'Great Britain');

CREATE OR REPLACE FUNCTION generate_utopian_managers (min_amount integer, max_amount integer) RETURNS void AS
$$
    DECLARE
        added_person_id integer;
    BEGIN
        FOR i IN 1..get_random_int_in_range(min_amount,max_amount) LOOP
                SELECT insert_person(get_random_string_with_delimiter(), 'Utopia') INTO added_person_id;
                PERFORM _insert_position_history(added_person_id, get_random_utopian_management_position_id(), CURRENT_DATE);
                end loop;
    end;
$$ LANGUAGE plpgsql;

SELECT generate_utopian_managers(100, 400);

CREATE OR REPLACE FUNCTION get_random_filarch() RETURNS integer AS
$$
    SELECT person_id FROM person_position_history WHERE position_id = get_position_id_by_name('Filarch') ORDER BY random();
$$ language sql;

CREATE OR REPLACE FUNCTION get_random_protofilarch() RETURNS integer AS
$$
    SELECT person_id FROM person_position_history WHERE position_id = get_position_id_by_name('Protofilarch') ORDER BY random();
$$ language sql;

CREATE OR REPLACE FUNCTION insert_50_people (names text[], country_id integer, family_id_val integer)RETURNS TABLE(id integer) AS
$$
    INSERT INTO person (name, motherland_id, family_id) VALUES
    (names[50], country_id, family_id_val), (names[1], country_id, family_id_val), (names[2], country_id, family_id_val), (names[3], country_id, family_id_val),
    (names[4], country_id, family_id_val), (names[5], country_id, family_id_val), (names[6], country_id, family_id_val), (names[7], country_id, family_id_val),
    (names[8], country_id, family_id_val), (names[9], country_id, family_id_val), (names[10], country_id, family_id_val), (names[11], country_id, family_id_val),
    (names[12], country_id, family_id_val), (names[13], country_id, family_id_val), (names[14], country_id, family_id_val), (names[15], country_id, family_id_val),
    (names[16], country_id, family_id_val), (names[17], country_id, family_id_val), (names[18], country_id, family_id_val), (names[19], country_id, family_id_val),
    (names[20], country_id, family_id_val), (names[21], country_id, family_id_val), (names[22], country_id, family_id_val), (names[23], country_id, family_id_val),
    (names[24], country_id, family_id_val), (names[25], country_id, family_id_val), (names[26], country_id, family_id_val), (names[27], country_id, family_id_val),
    (names[28], country_id, family_id_val), (names[29], country_id, family_id_val), (names[30], country_id, family_id_val), (names[31], country_id, family_id_val),
    (names[32], country_id, family_id_val), (names[33], country_id, family_id_val), (names[34], country_id, family_id_val), (names[35], country_id, family_id_val),
    (names[36], country_id, family_id_val), (names[37], country_id, family_id_val), (names[38], country_id, family_id_val), (names[39], country_id, family_id_val),
    (names[40], country_id, family_id_val), (names[41], country_id, family_id_val), (names[42], country_id, family_id_val), (names[43], country_id, family_id_val),
    (names[44], country_id, family_id_val), (names[45], country_id, family_id_val), (names[46], country_id, family_id_val), (names[47], country_id, family_id_val),
    (names[48], country_id, family_id_val), (names[49], country_id, family_id_val) RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_50_positions (ids integer[], pos_id integer, hire_date_ date, dismissal_date_ date) RETURNS void AS
$$
    INSERT INTO person_position_history (person_id, position_id, hire_date, dismissal_date) VALUES
    (ids[50], pos_id, hire_date_, dismissal_date_), (ids[1], pos_id, hire_date_, dismissal_date_), (ids[2], pos_id, hire_date_, dismissal_date_), (ids[3], pos_id, hire_date_, dismissal_date_),
    (ids[4], pos_id, hire_date_, dismissal_date_), (ids[5], pos_id, hire_date_, dismissal_date_), (ids[6], pos_id, hire_date_, dismissal_date_), (ids[7], pos_id, hire_date_, dismissal_date_),
    (ids[8], pos_id, hire_date_, dismissal_date_), (ids[9], pos_id, hire_date_, dismissal_date_), (ids[10], pos_id, hire_date_, dismissal_date_), (ids[11], pos_id, hire_date_, dismissal_date_),
    (ids[12], pos_id, hire_date_, dismissal_date_), (ids[13], pos_id, hire_date_, dismissal_date_), (ids[14], pos_id, hire_date_, dismissal_date_), (ids[15], pos_id, hire_date_, dismissal_date_),
    (ids[16], pos_id, hire_date_, dismissal_date_), (ids[17], pos_id, hire_date_, dismissal_date_), (ids[18], pos_id, hire_date_, dismissal_date_), (ids[19], pos_id, hire_date_, dismissal_date_),
    (ids[20], pos_id, hire_date_, dismissal_date_), (ids[21], pos_id, hire_date_, dismissal_date_), (ids[22], pos_id, hire_date_, dismissal_date_), (ids[23], pos_id, hire_date_, dismissal_date_),
    (ids[24], pos_id, hire_date_, dismissal_date_), (ids[25], pos_id, hire_date_, dismissal_date_), (ids[26], pos_id, hire_date_, dismissal_date_), (ids[27], pos_id, hire_date_, dismissal_date_),
    (ids[28], pos_id, hire_date_, dismissal_date_), (ids[29], pos_id, hire_date_, dismissal_date_), (ids[30], pos_id, hire_date_, dismissal_date_), (ids[31], pos_id, hire_date_, dismissal_date_),
    (ids[32], pos_id, hire_date_, dismissal_date_), (ids[33], pos_id, hire_date_, dismissal_date_), (ids[34], pos_id, hire_date_, dismissal_date_), (ids[35], pos_id, hire_date_, dismissal_date_),
    (ids[36], pos_id, hire_date_, dismissal_date_), (ids[37], pos_id, hire_date_, dismissal_date_), (ids[38], pos_id, hire_date_, dismissal_date_), (ids[39], pos_id, hire_date_, dismissal_date_),
    (ids[40], pos_id, hire_date_, dismissal_date_), (ids[41], pos_id, hire_date_, dismissal_date_), (ids[42], pos_id, hire_date_, dismissal_date_), (ids[43], pos_id, hire_date_, dismissal_date_),
    (ids[44], pos_id, hire_date_, dismissal_date_), (ids[45], pos_id, hire_date_, dismissal_date_), (ids[46], pos_id, hire_date_, dismissal_date_), (ids[47], pos_id, hire_date_, dismissal_date_),
    (ids[48], pos_id, hire_date_, dismissal_date_), (ids[49], pos_id, hire_date_, dismissal_date_);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION generate_utopian_people (max_people_amount integer, family_size integer) RETURNS void AS
$$
    DECLARE
        i integer;
        country_id integer = get_country_id_by_name('Utopia');
        added_person_ids integer ARRAY[50];
        position_id integer;
        craft_type_id integer;
        family_id integer;
        new_people_names text ARRAY[50];
    BEGIN
        ALTER TABLE person DROP CONSTRAINT person_family_id_fkey;
        ALTER TABLE person DROP CONSTRAINT person_motherland_id_fkey;
        ALTER TABLE person_position_history DROP CONSTRAINT person_position_history_person_id_fkey;
        ALTER TABLE person_position_history DROP CONSTRAINT person_position_history_position_id_fkey;
        ALTER TABLE person_position_history DROP CONSTRAINT is_after_hire;
        ALTER TABLE family DROP CONSTRAINT family_craft_type_id_fkey;
        ALTER TABLE family DROP CONSTRAINT responsible_foreign_key;

        IF family_size < 1
            THEN RAISE EXCEPTION 'Family size can not be less then 1.';
        END IF;
        FOR i IN (SELECT * FROM generate_series(0, max_people_amount, family_size)) LOOP
            SELECT get_random_utopian_position_id() INTO position_id;
            SELECT get_craft_type_id_by_position(position_id) INTO craft_type_id;
            SELECT insert_family(craft_type_id, get_random_filarch()) INTO family_id;

            FOR k in 0..family_size LOOP
                new_people_names[k] = get_random_string_with_delimiter();
                end loop;
            SELECT array(SELECT id FROM insert_50_people(new_people_names, country_id, family_id)) INTO added_person_ids;
            RAISE info 'some id:%', added_person_ids[50];

            PERFORM insert_50_positions(added_person_ids, position_id, CURRENT_DATE, NULL);
            PERFORM insert_50_positions(added_person_ids, get_random_utopian_position_id(), CURRENT_DATE-get_random_int_in_range(3, 15), CURRENT_DATE);
        end loop;

        ALTER TABLE person ADD CONSTRAINT person_family_id_fkey FOREIGN KEY (family_id) REFERENCES family ON UPDATE CASCADE ON DELETE SET NULL;
        ALTER TABLE person ADD CONSTRAINT person_motherland_id_fkey FOREIGN KEY (motherland_id) REFERENCES Country ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE person_position_history ADD CONSTRAINT person_position_history_person_id_fkey FOREIGN KEY (person_id) REFERENCES Person ON UPDATE CASCADE ON DELETE CASCADE;
        ALTER TABLE person_position_history ADD CONSTRAINT person_position_history_position_id_fkey foreign key (position_id) REFERENCES Position (id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE person_position_history ADD CONSTRAINT is_after_hire CHECK (hire_date <= dismissal_date);
        ALTER TABLE family ADD CONSTRAINT family_craft_type_id_fkey foreign key (craft_type_id) REFERENCES Craft_type (id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE family ADD CONSTRAINT responsible_foreign_key foreign key(responsible_person_id) REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL;
    END;
$$ LANGUAGE plpgsql;

SELECT generate_utopian_people(10000, 50);

-- SELECT insert_family('Farming', VARIADIC ARRAY[
--     ( SELECT id from person where name = 'Kopatich')
--     ]::integer[]);

CREATE OR REPLACE FUNCTION generate_building_construction_artefacts(min_amount integer, max_amount integer, building_type_name text) RETURNS void AS
$$
    DECLARE
        res_id integer;
        sen_id integer;
    BEGIN
        ALTER TABLE building DROP CONSTRAINT building_building_type_id_fkey;
        ALTER TABLE building_construction_artefact DROP CONSTRAINT building_construction_artefact_building_id_fkey;
        ALTER TABLE building_construction_artefact DROP CONSTRAINT building_construction_artefact_responsible_person_id_fkey;
        ALTER TABLE building_construction_artefact DROP CONSTRAINT is_construction_date_range_correct;
        ALTER TABLE report DROP Constraint report_receiver_id_fkey;
        ALTER TABLE report DROP CONSTRAINT report_sender_id_fkey;

        SELECT get_random_protofilarch() INTO sen_id;
        FOR i IN 0..max_amount LOOP
            SELECT get_random_protofilarch() into res_id;
            PERFORM insert_building_construction_artefact(res_id, building_type_name, CURRENT_DATE);
            PERFORM insert_report('Building construction', 'Build the ' || building_type_name, sen_id, res_id);
        end loop;

        ALTER TABLE building ADD CONSTRAINT building_building_type_id_fkey FOREIGN KEY (building_type_id) REFERENCES Building_type (id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE building_construction_artefact ADD CONSTRAINT building_construction_artefact_building_id_fkey FOREIGN KEY (building_id) REFERENCES Building (id) ON UPDATE CASCADE ON DELETE SET NULL;
        ALTER TABLE building_construction_artefact ADD CONSTRAINT building_construction_artefact_responsible_person_id_fkey FOREIGN KEY(responsible_person_id) REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL;
        ALTER TABLE building_construction_artefact ADD CONSTRAINT is_construction_date_range_correct CHECK ( construction_beginning_date <= construction_end_date );
        ALTER TABLE report ADD Constraint report_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL;
        ALTER TABLE report ADD CONSTRAINT report_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES Person (id) ON UPDATE CASCADE ON DELETE SET NULL;
    end;
$$ language plpgsql;

SELECT generate_building_construction_artefacts(2500, 2500, 'Farm');
SELECT generate_building_construction_artefacts(2500, 2500, 'Living');
SELECT generate_building_construction_artefacts(500, 500, 'School');
SELECT generate_building_construction_artefacts(50, 50, 'Administrative');
SELECT generate_building_construction_artefacts(25, 25, 'Pub');
SELECT generate_building_construction_artefacts(2000, 2000, 'Workshop');
SELECT generate_building_construction_artefacts(1000, 1000, 'Mine');
SELECT generate_building_construction_artefacts(500, 500, 'Factory');
SELECT generate_building_construction_artefacts(500, 500, 'Garden');

CREATE OR REPLACE FUNCTION generate_people_detachment_to_building() RETURNS void AS
$$
    DECLARE
        _person person;
        _building integer;
    BEGIN
        FOR _person in SELECT * FROM person LOOP
            SELECT id from building where building_type_id = get_building_type_id_by_name('Living') ORDER BY random() LIMIT 1 INTO _building;
            PERFORM insert_people_detachment_to_building(_person.name, _building);
    end loop;
    end;
$$ LANGUAGE plpgsql;

SELECT generate_people_detachment_to_building();

CREATE OR REPLACE FUNCTION generate_resources_to_families(min_resource_amount double precision, max_resource_amount double precision) RETURNS void AS
$$
    DECLARE
        _family_id integer;
    BEGIN
        FOR _family_id in SELECT id FROM Family LOOP
            INSERT INTO family_resource_ownership (family_id, resource_id)
                VALUES (_family_id, get_resource_from_resource_storage('Water', max_resource_amount)),
                    (_family_id, get_resource_from_resource_storage('Food', max_resource_amount)),
                    (_family_id, get_resource_from_resource_storage('Wood', max_resource_amount));
            end loop;
    end;
$$ language plpgsql;

SELECT generate_resources_to_families(10, 10);

SELECT insert_event_group('Antanta');
SELECT insert_event_group('Bechennie');
SELECT insert_event_group('Ognennie');
SELECT insert_event_group('Crutie');
SELECT insert_event_group('Ne pri delah');

SELECT insert_event_group_countries('Antanta', 'Finland');
SELECT insert_event_group_countries('Antanta', 'Sweden');
SELECT insert_event_group_countries('Bechennie', 'Poland');
SELECT insert_event_group_countries('Crutie', 'Finland');
SELECT insert_event_group_countries('Crutie', 'Great Britain');
SELECT insert_event_group_countries('Ne pri delah', 'Utopia');

CREATE OR REPLACE FUNCTION generate_country_relationships (min_amount integer, max_amount integer) RETURNS void AS
$$
    DECLARE
        chance double precision;
BEGIN
    For i in 0..max_amount LOOP
        SELECT get_random_double_in_range(0, 1) INTO chance;
        if chance > 0.85
            THEN PERFORM insert_country_relationship_event('War', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                                                           VARIADIC ARRAY [get_event_group_id_by_name('Antanta'), get_event_group_id_by_name('Crutie')]);
        ELSIF chance > 0.7
            THEN PERFORM insert_country_relationship_event('War', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                         VARIADIC ARRAY [get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Bechenie'), get_event_group_id_by_name('Ne pri delah')]);
        ELSIF chance > 0.6
            THEN PERFORM insert_country_relationship_event('Cooperation', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                         VARIADIC ARRAY [get_event_group_id_by_name('Bechenie'), get_event_group_id_by_name('Ne pri delah')]);
        ELSIF chance > 0.5
            THEN PERFORM insert_country_relationship_event('Cooperation', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                         VARIADIC ARRAY [get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Antanta'), get_event_group_id_by_name('Ne pri delah')]);
        ELSIF chance > 0.4
            THEN PERFORM insert_country_relationship_event('Peace', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                         VARIADIC ARRAY [get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Antanta')]);
        ELSIF chance > 0.3
            THEN PERFORM insert_country_relationship_event('Conflict', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                         VARIADIC ARRAY [get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Antanta')]);
       ELSIF chance > 0.1
            THEN PERFORM insert_country_relationship_event('Conflict', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                         VARIADIC ARRAY [get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Antanta'), get_event_group_id_by_name('Bechenie')]);
       ELSE PERFORM insert_country_relationship_event('Peace', CURRENT_DATE - get_random_int_in_range(1000, 1000),
                         VARIADIC ARRAY [get_event_group_id_by_name('Ne pri delah'), get_event_group_id_by_name('Bechenie')]);
       END if;
       end loop;
end;
$$ language plpgsql;

SELECT generate_country_relationships(10000, 10000);

-- SELECT insert_country_relationship_event('War', make_date(2020, 11, 8),
--                                          Variadic ARRAY[get_event_group_id_by_name('Antanta'), get_event_group_id_by_name('Bechennie')]);
-- SELECT insert_country_relationship_event('Peace', make_date(2023, 11, 8),
--                                          VARIADIC ARRAY [get_event_group_id_by_name('Ne pri delah'), get_event_group_id_by_name('Bechennie')]);
-- SELECT insert_country_relationship_event('Conflict', make_date(2015, 11, 8),
--                                          VARIADIC ARRAY[get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Ne pri delah')]);
-- SELECT insert_country_relationship_event('Cooperation', make_date(2018, 11, 8),
--                                          VARIADIC ARRAY[get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Ne pri delah')]);

-- SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = make_date(2023, 11, 8)), 'Crutie');
-- SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = make_date(2023, 11, 8)), 'Ne pri delah');

SELECT get_or_insert_resource_usage_type_id_by_amount(0.2);
SELECT get_or_insert_resource_usage_type_id_by_amount(0.5);
SELECT get_or_insert_resource_usage_type_id_by_amount(50);

