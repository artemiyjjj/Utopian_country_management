SELECT insert_craft_type('Gardening');
SELECT insert_craft_type('Farming');
SELECT insert_craft_type('Livestock');
SELECT insert_craft_type('Copper');
SELECT insert_craft_type('Factory worker');

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

SELECT insert_resource_type('Water');
SELECT insert_resource_type('Wood');
SELECT insert_resource_type('Food');
SELECT insert_resource_type('Stone');
SELECT insert_resource_type('Gold');
SELECT insert_resource_type('Oil');

SELECT insert_resource_storage('Water', 3000.0);
SELECT insert_resource_storage('Water', 4789.3);
SELECT insert_resource_storage('Gold', 142.0);
SELECT insert_resource_storage('Food', 2081.3);
SELECT insert_resource_storage('Oil', 392.0);

SELECT insert_person('Sigizmund III');
SELECT insert_person('Petr I');
SELECT insert_person('The Queen');
SELECT insert_person('Person 1254');
SELECT insert_person('Sigizmund IV');
SELECT insert_person('EKATERINA I');

SELECT insert_country('Utopia', 'Person 1254');
SELECT insert_country('Poland', 'Sigizmund III');
SELECT insert_country('Finland', 'Petr I');
SELECT insert_country('Sweden');

SELECT update_country('Poland', 'Sigizmund IV');
SELECT update_country('Finland', 'EKATERINA I');

SELECT insert_person('Ivan Semenich', 'Poland');
SELECT insert_person('Person 5347', 'Utopia');
SELECT insert_person('Person 4499', 'Utopia');
SELECT insert_person('Person 400', 'Utopia');

SELECT insert_family('Farming');
SELECT insert_family('Copper', [(Select id from person where name = 'Person 5347'), get_person_id_by_name('Person 4499')]);

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


-- SELECT get_country_id_by_name('df');


SELECT insert_person('Karl V', 'German')

SELECT insert_family()