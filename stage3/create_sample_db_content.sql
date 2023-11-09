SELECT insert_craft_type('Gardening');
SELECT insert_craft_type('Farming');
SELECT insert_craft_type('Livestock');
SELECT insert_craft_type('Copper');
SELECT insert_craft_type('Factory worker');
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

SELECT insert_position('Filarch');
SELECT insert_position('Protofilarch');
SELECT insert_position('Duke');
SELECT insert_position('Craftsman');
SELECT insert_position('Kniaz');
SELECT insert_position('Foreign king');
SELECT insert_position('Foreign diplomat');
SELECT insert_position('Foreign citizen');

SELECT insert_resource_type('Water');
SELECT insert_resource_type('Wood');
SELECT insert_resource_type('Food');
SELECT insert_resource_type('Stone');
SELECT insert_resource_type('Gold');
SELECT insert_resource_type('Oil');

SELECT _insert_resource_storage('Water', 3000.0);
SELECT _insert_resource_storage('Water', 4789.3);
SELECT _insert_resource_storage('Gold', 142.0);
SELECT _insert_resource_storage('Food', 2081.3);
SELECT _insert_resource_storage('Oil', 392.0);

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
SELECT _insert_position_history('Person 1254', 'kniaz', make_date(2000, 4, 17));

SELECT insert_country('Utopia', 'Person 1254');
SELECT insert_country('Poland', 'Sigizmund III');
SELECT insert_country('Finland', 'Petr I');
SELECT insert_country('Sweden');

-- SELECT update_country('Poland', 'Sigizmund IV');
SELECT update_country('Sweden', 'The Queen');

SELECT insert_person('Ivan Semenich', 'Poland');
SELECT insert_person('Person 5347', 'Utopia');
SELECT insert_person('Person 4499', 'Utopia');
SELECT insert_person('Person 400', 'Utopia');
SELECT insert_person('Alex Mayhem', 'Utopia');
SELECT insert_person('Kirill Abvgd', 'Utopia');
SELECT insert_person('Kopatich', 'Utopia');
SELECT insert_person('Mr. Undwick', 'Utopia');
SELECT insert_person('Anton Mirniy', 'Utopia');
SELECT insert_person('Evgeniy Krivchov', 'Utopia');

SELECT make_date(2023, 10, 9);

SELECT insert_family('Farming', [
    get_person_id_by_name('Kopatich')
    ]);

SELECT insert_family('Copper',
    [get_person_id_by_name('Person 5347'),
    get_person_id_by_name('Person 4499')
    ]);

SELECT insert_family('Livestock', [
    get_person_id_by_name('Alex Mayhem'),
    get_person_id_by_name('Anton Mirniy')
    ]);

SELECT insert_family('Teaching', [
    get_person_id_by_name('Mr. Undwick'),
    get_person_id_by_name('Person 400')
    ]);

SELECT insert_family('Factory worker', [
    get_person_id_by_name('Kirill Abvgd')
    ]);
SELECT insert_family('Copper', {
    get_person_id_by_name('Evgeniy Krivchov')
           });


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

SELECT insert_country_relationship_event('In state of war', '08.11.2020', ['Antanta', 'Bechennie']);
SELECT insert_country_relationship_event('Peaceful state', '08.11.2023');
SELECT insert_country_relationship_event('In state of conflict', '15.08.2015', ['Crutie', 'Ne pri delah']);
-- SELECT id FROM country_relationship_event_history where start_event_date = '08.11.2020';

SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = '08.11.2023'), 'Crutie');
SELECT insert_relationship_events_groups((Select id from country_relationship_event_history where start_event_date = '08.11.2023'), 'Ne pri delah');

SELECT get_or_insert_resource_usage_type_id_by_amount(0.2);
SELECT get_or_insert_resource_usage_type_id_by_amount(0.5);
SELECT get_or_insert_resource_usage_type_id_by_amount(50);
