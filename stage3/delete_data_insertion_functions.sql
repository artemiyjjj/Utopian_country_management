DROP FUNCTION IF EXISTS get_country_id_by_name(country_name text) CASCADE;

DROP FUNCTION IF EXISTS get_event_group_id_by_name(event_group_name text) CASCADE;

DROP FUNCTION IF EXISTS get_political_status_id_by_name (political_status_name text) CASCADE;

DROP FUNCTION IF EXISTS get_position_id_by_name (position_name text) CASCADE;

DROP FUNCTION IF EXISTS get_person_id_by_name (person_name text) CASCADE;

DROP FUNCTION IF EXISTS get_craft_type_id_id_by_name (craft_type_name text) CASCADE;

DROP FUNCTION IF EXISTS get_resource_type_id_by_name (resource_type_name text) CASCADE;

DROP FUNCTION IF EXISTS get_or_insert_resource_usage_type_id_by_amount (resource_usage_type_amount double precision) CASCADE;

DROP FUNCTION IF EXISTS get_building_type_id_by_name (building_type_name text) CASCADE;

DROP FUNCTION IF EXISTS is_building_exists(building_id integer) CASCADE;

DROP FUNCTION IF EXISTS is_family_exists(family_id integer) CASCADE;

DROP FUNCTION IF EXISTS is_resource_exists (resource_id integer) CASCADE;

DROP FUNCTION IF EXISTS is_resource_storage_exists (resource_storage_id integer) CASCADE;

DROP FUNCTION IF EXISTS is_event_group_exists (group_id integer) CASCADE;

DROP FUNCTION IF EXISTS is_event_groups_exists (groups_id integer) CASCADE;

DROP FUNCTION IF EXISTS is_country_relationship_event_exists (relationship_event_id integer) CASCADE;



DROP FUNCTION IF EXISTS insert_country(country_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_country(country_name text, leader_name text) CASCADE;

DROP FUNCTION IF EXISTS update_country (country_name text, leader_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_political_status(status_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_event_group (group_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_event_group_countries (group_name text, country_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_relationship_events_groups (event_id integer, group_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_country_relationship_event (political_status_name text, event_start_date date) CASCADE;

DROP FUNCTION IF EXISTS insert_country_relationship_event (political_status_name text, event_start_date date, groups_id integer) CASCADE;

DROP FUNCTION IF EXISTS insert_country_relationship_event (political_status_name text, event_start_date date, VARIADIC event_groups_name_set text[]) CASCADE;

DROP FUNCTION IF EXISTS update_country_relationship_event (event_id integer, event_end_date date) CASCADE;


DROP FUNCTION IF EXISTS insert_resource_type (resource_type_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_resource_storage (resource_type_name text, resource_storage_quantity double precision) CASCADE;

DROP FUNCTION IF EXISTS insert_resource_storage(resource_type_name text, resource_storage_quantity double precision, resource_storage_current_quantity double precision) CASCADE;

DROP FUNCTION IF EXISTS _insert_resource_storage(_resource_type_name text, _resource_storage_quantity double precision) CASCADE;

DROP FUNCTION IF EXISTS _insert_resource_storage(_resource_type_name text, _resource_storage_quantity double precision, _resource_storage_current_quantity double precision) CASCADE;

DROP FUNCTION IF EXISTS insert_resource (storage_id integer, resource_initial_quantity double precision) CASCADE;

DROP FUNCTION IF EXISTS insert_resource_usage_type (resource_usage_type_amount double precision) CASCADE;

DROP FUNCTION IF EXISTS insert_resource_usage (resource_id_val integer, resource_usage_type_amount double precision) CASCADE;


DROP FUNCTION IF EXISTS insert_craft_type (craft_type_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_family(craft_type_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_family(craft_type_name text, VARIADIC person_id integer[]) CASCADE;

DROP FUNCTION IF EXISTS insert_family_resource_ownership(family_id_val integer, resource_id_val integer) CASCADE;

DROP FUNCTION IF EXISTS insert_family_resource_ownership (family_id_val integer, resource_id_val integer, resource_quantity double precision) CASCADE;


DROP FUNCTION IF EXISTS insert_person(person_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_person(_name text, _motherland_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_person (_name text, _motherland_name text, _family_id integer) CASCADE;

DROP FUNCTION IF EXISTS update_person(_name text, _motherland_name text) CASCADE;

DROP FUNCTION IF EXISTS update_person (_name text, _new_family_id text) CASCADE;

DROP FUNCTION IF EXISTS insert_position (position_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_position_craft_type_relation(position_name text, craft_type_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_person_position_history(person_name text, person_position text, person_hire_date date) CASCADE;

DROP FUNCTION IF EXISTS insert_position_history(_person text, _position text, _date date) CASCADE;

DROP FUNCTION IF EXISTS _insert_position_history(_person text, _position text, _date date) CASCADE;

DROP FUNCTION IF EXISTS _insert_position_history(_person text, _position text, _hire_date date, _dismissal_date date) CASCADE;

DROP FUNCTION IF EXISTS update_person_position_history (person_position_history_id integer, person_dismissal_date date) CASCADE;



DROP FUNCTION IF EXISTS insert_report (report_title text, report_contents text, person_sender_name text, person_receiver_name text) CASCADE;

DROP FUNCTION IF EXISTS update_report_to_delivered (report_id integer) CASCADE;

DROP FUNCTION IF EXISTS insert_building_type (building_type_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_building (new_building_type_name text) CASCADE;

DROP FUNCTION IF EXISTS insert_building_construction_artefact (responsible_person_name text, new_building_type text, building_construction_beginning_date date) CASCADE;

DROP FUNCTION IF EXISTS insert_building_construction_artefact (responsible_person_name text, new_building_id integer, building_construction_beginning_date date) CASCADE;

DROP FUNCTION IF EXISTS update_building_construction_artefact (new_building_id integer, building_construction_end_date date) CASCADE;

DROP FUNCTION IF EXISTS insert_people_detachment_to_building (detached_person_name text, the_building_id integer) CASCADE;


DROP FUNCTION IF EXISTS allocate_resource_to_family(_family_id integer, _resource_type_name text, _resource_quantity double precision) CASCADE;