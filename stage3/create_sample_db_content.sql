SELECT insert_craft_type('Gardening');
SELECT insert_craft_type('Farming');
SELECT insert_craft_type('Livestock');
SELECT insert_craft_type('Copper');
SELECT insert_craft_type('Factory work');
SELECT insert_craft_type('Teaching');

SELECT insert_political_status('In state of war');
SELECT insert_political_status('In state of conflict');
SELECT insert_political_status('Peaceful state');

SELECT insert_building_type('School');
SELECT insert_building_type('Pub');
SELECT insert_building_type('Farm');
SELECT insert_building_type('Garden');
SELECT insert_building_type('Workshop');
SELECT insert_building_type('Administrative');
SELECT insert_building_type('Living');
SELECT insert_building_type('Mine');
SELECT insert_building_type('Factory');

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
SELECT insert_position('Foreign king');
SELECT insert_position('Foreign diplomat');
SELECT insert_position('Foreign citizen');

-- | need fix
SELECT insert_position_craft_type_relation('Craftsman', 'Factory work');
SELECT insert_position_craft_type_relation('Teacher', 'Teaching');
SELECT insert_position_craft_type_relation('Farmer', 'Farming');
SELECT insert_position_craft_type_relation('Gardener', 'Gardening');
SELECT insert_position_craft_type_relation('Butcher', 'Livestock');
SELECT insert_position_craft_type_relation('Copper', 'Copper');
SELECT insert_position_craft_type_relation('Factory worker', 'Factory work');

SELECT insert_resource_type('Water');
SELECT insert_resource_type('Wood');
SELECT insert_resource_type('Food');
SELECT insert_resource_type('Stone');
SELECT insert_resource_type('Gold');
SELECT insert_resource_type('Oil');

SELECT _insert_resource_storage('Water', 3000.0, 3000.0);
SELECT _insert_resource_storage('Water', 4789.3, 4000);
SELECT _insert_resource_storage('Gold', 142.0, 120);
SELECT _insert_resource_storage('Food', 2081.3, 1700);
SELECT _insert_resource_storage('Oil', 392.0, 390);

SELECT insert_person('Sigizmund III');
SELECT insert_person('Petr I');
SELECT insert_person('The Queen');
SELECT insert_person('Person 1254');
SELECT insert_person('Sigizmund IV');
SELECT insert_person('EKATERINA I');

SELECT _insert_position_history('Sigizmund III', 'Foreign king', make_date(2000, 10, 20));
SELECT _insert_position_history('Sigizmund IV', 'Foreign diplomat', make_date(2001, 3, 5));
SELECT _insert_position_history('Petr I', 'Foreign king', make_date(1998, 5, 30));
SELECT _insert_position_history('EKATERINA I', 'Foreign diplomat', make_date(1998, 5, 30));
SELECT _insert_position_history('The Queen', 'Foreign king', make_date(2002, 4, 17));
SELECT _insert_position_history('Person 1254', 'Kniaz', make_date(2000, 4, 17));

SELECT insert_country('Utopia', 'Person 1254');
SELECT insert_country('Poland', 'Sigizmund III');
SELECT insert_country('Finland', 'Petr I');
SELECT insert_country('Sweden');

-- SELECT update_country('Poland', 'Sigizmund IV');
-- SELECT update_country('Sweden', 'The Queen');

SELECT insert_person('Ivan Semenich', 'Poland');
SELECT insert_person('Sid Floyd', 'Utopia');
SELECT insert_person('Person 5347', 'Utopia');
SELECT insert_person('Person 4499', 'Utopia');
SELECT insert_person('Person 400', 'Utopia');
SELECT insert_person('Alex Mayhem', 'Utopia');
SELECT insert_person('Kirill Abvgd', 'Utopia');
SELECT insert_person('Kopatich', 'Utopia');
SELECT insert_person('Mr. Undwick', 'Utopia');
SELECT insert_person('Anton Mirniy', 'Utopia');
SELECT insert_person('Evgeniy Krivchov', 'Utopia');

SELECT _insert_position_history('Sid Floyd', 'Filarch', make_date(2000, 1, 1));
SELECT _insert_position_history('Person 5347', 'Copper', make_date(2000, 1, 1));
SELECT _insert_position_history('Person 4499', 'Copper', make_date(2000, 1, 2));
SELECT _insert_position_history('Person 400', 'Teacher', make_date(2000, 1, 2));
SELECT _insert_position_history('Alex Mayhem', 'Butcher', make_date(2000, 1, 1));
SELECT _insert_position_history('Kirill Abvgd', 'Factory worker', make_date(2000, 1, 1));
SELECT _insert_position_history('Kopatich', 'Farmer', make_date(2000, 1, 1));
SELECT _insert_position_history('Mr. Undwick', 'Teacher', make_date(2000, 1, 5));
SELECT _insert_position_history('Anton Mirniy', 'Butcher', make_date(2000, 2, 3));
SELECT _insert_position_history('Evgeniy Krivchov', 'Gardener', make_date(2000, 2, 3));

SELECT insert_family('Farming', VARIADIC ARRAY[
    ( SELECT id from person where name = 'Kopatich')
    ]::integer[]);

SELECT insert_family('Copper', VARIADIC ARRAY [
    get_person_id_by_name('Person 5347'),
    get_person_id_by_name('Person 4499')
    ]);

SELECT insert_family('Livestock', VARIADIC ARRAY [
    get_person_id_by_name('Alex Mayhem'),
    get_person_id_by_name('Anton Mirniy')
    ]);

SELECT insert_family('Teaching', VARIADIC ARRAY [
    get_person_id_by_name('Mr. Undwick'),
    get_person_id_by_name('Person 400')
    ]);

SELECT insert_family('Factory work', VARIADIC ARRAY [
    get_person_id_by_name('Kirill Abvgd')
    ]);

SELECT insert_family('Gardening', VARIADIC ARRAY[
    get_person_id_by_name('Evgeniy Krivchov')
           ]);

SELECT insert_building('Farm');

-- | need fix
SELECT insert_building_construction_artefact('Sid Floyd', 'Farm', make_date(2005, 5, 13));
SELECT insert_building_construction_artefact('Sid Floyd', 'Workshop', make_date(2005, 5, 15));
SELECT insert_building_construction_artefact('Sid Floyd', 'Living', make_date(2005, 5, 17));
SELECT insert_building_construction_artefact('Sid Floyd', 'Living', make_date(2005, 5, 19));
SELECT insert_building_construction_artefact('Sid Floyd', 'School', make_date(2005, 5, 20));

SELECT insert_event_group('Antanta');
SELECT insert_event_group('Bechennie');
SELECT insert_event_group('Ognennie');
SELECT insert_event_group('Crutie');
SELECT insert_event_group('Ne pri delah');

SELECT insert_event_group_countries('Antanta', 'Finland');
SELECT insert_event_group_countries('Antanta', 'Sweden');
SELECT insert_event_group_countries('Bechennie', 'Poland');
SELECT insert_event_group_countries('Crutie', 'Finland');
SELECT insert_event_group_countries('Ne pri delah', 'Utopia');
-- | fix
SELECT insert_country_relationship_event('In state of war', make_date(2020, 11, 8), Variadic ARRAY['Antanta', 'Bechennie']::text[]);
SELECT insert_country_relationship_event('Peaceful state', make_date(2023, 11, 8));
-- | fix
SELECT insert_country_relationship_event('In state of conflict', make_date(2015, 11, 8), VARIADIC ARRAY['Crutie', 'Ne pri delah']);

SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = make_date(2023, 11, 8)), 'Crutie');
SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = make_date(2023, 11, 8)), 'Ne pri delah');

SELECT get_or_insert_resource_usage_type_id_by_amount(0.2);
SELECT get_or_insert_resource_usage_type_id_by_amount(0.5);
SELECT get_or_insert_resource_usage_type_id_by_amount(50);
