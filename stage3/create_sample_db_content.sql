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

CREATE OR REPLACE FUNCTION generate_utopian_people (min_people_amount integer, max_people_amount integer, family_size integer) RETURNS void AS
$$
    DECLARE
        k integer;
        array_index integer;
        added_person_id integer;
        position_id integer;
        craft_type_id integer;
        craft_types_id integer[] = ARRAY [
            get_craft_type_id_id_by_name('Gardening'), get_craft_type_id_id_by_name('Farming'),
            get_craft_type_id_id_by_name('Livestock'), get_craft_type_id_id_by_name('Copper'),
            get_craft_type_id_id_by_name('Factory work'), get_craft_type_id_id_by_name('Crafting'),
            get_craft_type_id_id_by_name('Teaching'), get_craft_type_id_id_by_name('Servicing')];
        available_families integer[] = ARRAY [
            insert_family('Gardening', get_random_filarch()), insert_family('Farming', get_random_filarch()),
            insert_family('Livestock', get_random_filarch()), insert_family('Copper', get_random_filarch()),
            insert_family('Factory work', get_random_filarch()), insert_family('Crafting', get_random_filarch()),
            insert_family('Teaching', get_random_filarch()), insert_family('Servicing', get_random_filarch())];
        places_in_family integer[] = ARRAY [
            0, 0,
            0, 0,
            0, 0,
            0, 0];
    BEGIN
        IF family_size < 1
            THEN RAISE EXCEPTION 'Family size can not be less then 1.';
        END IF;
        FOR i IN min_people_amount..get_random_int_in_range(min_people_amount,max_people_amount) LOOP
            SELECT get_random_utopian_position_id() INTO position_id;
            SELECT get_craft_type_id_by_position(position_id) INTO craft_type_id;
            FOR k in 0..array_length(craft_types_id, 1) LOOP
                IF craft_type_id = craft_types_id[k]
                    THEN
                        array_index = k;
                        EXIT;
                END IF;
                end loop;
--             RAISE INFO '% arr ind', array_index;
            SELECT insert_person(get_random_string_with_delimiter(), 'Utopia', available_families[array_index]) INTO added_person_id;
            places_in_family[array_index] = places_in_family[array_index] + 1;
            IF places_in_family[array_index] >= family_size
                THEN
                    PERFORM craft_types_id[array_index] = insert_family(craft_types_id[array_index], get_random_filarch());
                    PERFORM places_in_family[array_index] = 0;
            end if;
            PERFORM _insert_position_history(added_person_id, position_id, CURRENT_DATE);
            PERFORM _insert_position_history(added_person_id, get_random_utopian_position_id(), CURRENT_DATE - get_random_int_in_range(1, 10));
        end loop;
    END
$$ LANGUAGE plpgsql;

SELECT generate_utopian_people(9000, 11000, 40);

-- SELECT insert_family('Farming', VARIADIC ARRAY[
--     ( SELECT id from person where name = 'Kopatich')
--     ]::integer[]);

CREATE OR REPLACE FUNCTION generate_building_construction_artefacts(min_amount integer, max_amount integer, building_type_name text) RETURNS void AS
$$
    BEGIN
        FOR i IN 1..get_random_int_in_range(min_amount, max_amount) LOOP
            PERFORM insert_building_construction_artefact(get_random_protofilarch(), building_type_name, CURRENT_DATE);
        end loop;
    end;
$$ language plpgsql;

SELECT generate_building_construction_artefacts(15, 30, 'Farm');
SELECT generate_building_construction_artefacts(50, 100, 'Living');
SELECT generate_building_construction_artefacts(10, 15, 'School');
SELECT generate_building_construction_artefacts(6, 8, 'Administrative');
SELECT generate_building_construction_artefacts(2, 5, 'Pub');
SELECT generate_building_construction_artefacts(10, 40, 'Workshop');
SELECT generate_building_construction_artefacts(15, 25, 'Mine');
SELECT generate_building_construction_artefacts(12, 20, 'Factory');
SELECT generate_building_construction_artefacts(3, 8, 'Garden');

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
        _resource_id integer;
    BEGIN
        FOR _family_id in SELECT id FROM Family LOOP
            PERFORM insert_family_resource_ownership(_family_id, (SELECT get_resource_from_resource_storage('Water', get_random_double_in_range(min_resource_amount, max_resource_amount))));
            PERFORM insert_family_resource_ownership(_family_id, (SELECT get_resource_from_resource_storage('Food', get_random_double_in_range(min_resource_amount, max_resource_amount))));
            PERFORM insert_family_resource_ownership(_family_id, (SELECT get_resource_from_resource_storage('Wood', get_random_double_in_range(min_resource_amount, max_resource_amount))));
        end loop;
    end;
$$ language plpgsql;

SELECT generate_resources_to_families(50, 150);

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

-- CREATE OR REPLACE FUNCTION generate_country_relationships (min_amount integer, max_amount integer) RETURNS void AS
-- $$
--     DECLARE
--         chance double precision;
-- BEGIN
--     For i in 1..get_random_int_in_range(min_amount, max_amount) LOOP
--         SELECT get_random_double_in_range(0, 1) INTO chance;
--         if chance > 0.9
--             THEN PERFORM insert_country_relationship_event('War', CURRENT_DATE,
--                                                            VARIADIC ARRAY [ge]) ;
--         end loop;
-- end;
--
-- $$ language plpgsql;

SELECT insert_country_relationship_event('War', make_date(2020, 11, 8),
                                         Variadic ARRAY[get_event_group_id_by_name('Antanta'), get_event_group_id_by_name('Bechennie')]);
SELECT insert_country_relationship_event('Peace', make_date(2023, 11, 8),
                                         VARIADIC ARRAY [get_event_group_id_by_name('Ne pri delah'), get_event_group_id_by_name('Bechennie')]);
SELECT insert_country_relationship_event('Conflict', make_date(2015, 11, 8),
                                         VARIADIC ARRAY[get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Ne pri delah')]);
SELECT insert_country_relationship_event('Cooperation', make_date(2018, 11, 8),
                                         VARIADIC ARRAY[get_event_group_id_by_name('Crutie'), get_event_group_id_by_name('Ne pri delah')]);

SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = make_date(2023, 11, 8)), 'Crutie');
SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = make_date(2023, 11, 8)), 'Ne pri delah');

SELECT get_or_insert_resource_usage_type_id_by_amount(0.2);
SELECT get_or_insert_resource_usage_type_id_by_amount(0.5);
SELECT get_or_insert_resource_usage_type_id_by_amount(50);

